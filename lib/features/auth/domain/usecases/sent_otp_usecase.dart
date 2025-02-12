import 'package:dartz/dartz.dart';
import 'package:escooter/core/usecases/usecase.dart';
import 'package:escooter/features/auth/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SendOtpUseCase extends Usecase {
  final AuthRepository _repository;

  SendOtpUseCase(this._repository);

  @override
  Future<Either<dynamic, dynamic>> call({dynamic params}) async {
    return _repository.sendOtp(params as String);
  }
}
