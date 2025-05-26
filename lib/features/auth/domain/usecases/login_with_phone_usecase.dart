import 'package:dartz/dartz.dart';
import 'package:escooter/core/usecases/usecase.dart';
import 'package:escooter/features/auth/data/models/otp_response.dart';
import 'package:escooter/features/auth/domain/entities/login_request.dart';
import 'package:escooter/features/auth/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginWithPhoneUseCase
    implements Usecase<Either<String, OtpResponse>, LoginRequest> {
  final AuthRepository _repository;

  LoginWithPhoneUseCase(this._repository);

  @override
  Future<Either<String, OtpResponse>> call({LoginRequest? params}) async {
    if (params == null) {
      return const Left('Phone number is required');
    }

    try {
      return await _repository.loginWithPhone(params.phoneNumber);
    } catch (e) {
      return Left('Failed to initiate login: $e');
    }
  }
}
