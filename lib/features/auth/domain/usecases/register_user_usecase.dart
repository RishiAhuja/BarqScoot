import 'package:dartz/dartz.dart';
import 'package:escooter/core/usecases/usecase.dart';
import 'package:escooter/features/auth/domain/entities/create_user_request.dart';
import 'package:escooter/features/auth/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterUserUsecase extends Usecase {
  final AuthRepository _repository;

  RegisterUserUsecase(this._repository);

  @override
  Future<Either<dynamic, dynamic>> call({dynamic params}) async {
    return _repository.registerUser(params as CreateUserRequest);
  }
}
