import 'package:dartz/dartz.dart';
import 'package:escooter/core/configs/services/storage/storage_service.dart';
import 'package:escooter/core/usecases/usecase.dart';
import 'package:escooter/features/auth/domain/entities/login_request.dart';
import 'package:escooter/features/auth/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase implements Usecase<void, LoginRequest> {
  final AuthRepository _repository;
  final StorageService _storageService;

  LoginUseCase(this._repository, this._storageService);

  @override
  Future<Either<String, void>> call({LoginRequest? params}) async {
    try {
      // Login
      final loginResult = await _repository.login(params!);

      return await loginResult.fold(
        (failure) => Left(failure),
        (loginResponse) async {
          // Get user profile
          final profileResult =
              await _repository.getUserProfile(loginResponse.token);

          return await profileResult.fold(
            (failure) => Left(failure),
            (userProfile) async {
              // Save user data locally
              await _storageService.saveUser(userProfile);
              return const Right(null);
            },
          );
        },
      );
    } catch (e) {
      return Left('Login failed: $e');
    }
  }
}
