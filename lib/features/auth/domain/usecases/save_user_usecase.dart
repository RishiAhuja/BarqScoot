import 'package:escooter/core/usecases/usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:escooter/features/auth/domain/repository/auth_repository.dart';

class SaveUserParams {
  final String id;
  final String token;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String gender;
  final bool isVerified;
  final String email;
  final String? location;
  final double walletBalance;

  SaveUserParams({
    required this.id,
    required this.walletBalance,
    required this.email,
    this.location,
    required this.token,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.isVerified,
  });
}

@injectable
class SaveUserUseCase implements Usecase<void, SaveUserParams> {
  final AuthRepository _repository;

  SaveUserUseCase(this._repository);

  @override
  Future<Either> call({dynamic params}) {
    return _repository.saveUser(params);
  }
}
