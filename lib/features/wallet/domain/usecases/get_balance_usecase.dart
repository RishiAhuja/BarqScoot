import 'package:escooter/core/usecases/usecase.dart';
import 'package:escooter/features/wallet/domain/repository/wallet_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetBalanceUseCase implements Usecase<Either, void> {
  final WalletRepository _repository;

  GetBalanceUseCase(this._repository);

  @override
  Future<Either> call({void params}) {
    return _repository.getBalance();
  }
}
