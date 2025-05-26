import 'package:dartz/dartz.dart';
import 'package:escooter/core/error/api_exceptions.dart';
import 'package:escooter/core/usecases/usecase.dart';
import 'package:escooter/features/auth/domain/entities/verify_otp_response.dart';
import 'package:escooter/features/auth/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:escooter/features/auth/domain/entities/verify_otp_params.dart';

@injectable
class VerifyOtpUsecase
    extends Usecase<Either<AuthException, VerifyOtpResponse>, VerifyOtpParams> {
  final AuthRepository _repository;

  VerifyOtpUsecase(this._repository);

  @override
  Future<Either<AuthException, VerifyOtpResponse>> call(
      {VerifyOtpParams? params}) async {
    if (params == null) {
      return Left(AuthException('OTP verification parameters are required'));
    }

    final result = await _repository.verifyOtp(
      params.phoneNumber,
      params.verificationId,
      params.otp,
    );

    return result.fold(
      (error) => Left(error),
      (json) => Right(VerifyOtpResponse.fromJson(json)),
    );
  }
}
