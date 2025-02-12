import 'package:dartz/dartz.dart';
import 'package:escooter/core/usecases/usecase.dart';
import 'package:escooter/features/auth/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';

class VerifyOtpParams {
  final String phoneNumber;
  final String otp;

  VerifyOtpParams({required this.phoneNumber, required this.otp});
}

@injectable
class VerifyOtpUsecase extends Usecase {
  final AuthRepository _repository;

  VerifyOtpUsecase(this._repository);

  @override
  Future<Either<dynamic, dynamic>> call({dynamic params}) async {
    final verifyOtpParams = params as VerifyOtpParams;
    return _repository.verifyOtp(
      verifyOtpParams.phoneNumber,
      verifyOtpParams.otp,
    );
  }
}
