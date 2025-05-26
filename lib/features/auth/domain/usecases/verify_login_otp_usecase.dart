import 'package:dartz/dartz.dart';
import 'package:escooter/core/configs/services/storage/storage_service.dart';
import 'package:escooter/core/usecases/usecase.dart' show Usecase;
import 'package:escooter/features/auth/domain/entities/verify_otp_params.dart';
import 'package:escooter/features/auth/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class VerifyLoginOtpUseCase
    implements Usecase<Either<String, void>, VerifyOtpParams> {
  final AuthRepository _repository;
  final StorageService _storageService;

  VerifyLoginOtpUseCase(this._repository, this._storageService);

  @override
  Future<Either<String, void>> call({VerifyOtpParams? params}) async {
    if (params == null) {
      return const Left('Verification parameters are required');
    }

    try {
      // Verify OTP and get token
      final verifyResult = await _repository.verifyLoginOtp(
        phoneNumber: params.phoneNumber,
        verificationId: params.verificationId,
        otp: params.otp,
      );

      return verifyResult.fold(
        (failure) => Left(failure),
        (loginResponse) async {
          // Get user profile using the token
          final profileResult =
              await _repository.getUserProfile(loginResponse.token);

          return profileResult.fold(
            (failure) => Left(failure),
            (userProfile) async {
              // Save the complete user profile (with token)
              await _storageService.saveUser(userProfile);
              return const Right(null);
            },
          );
        },
      );
    } catch (e) {
      return Left('Verification failed: $e');
    }
  }
}
