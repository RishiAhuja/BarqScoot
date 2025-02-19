import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:escooter/core/usecases/usecase.dart';
import 'package:escooter/features/wallet/domain/repository/wallet_repository.dart';

@injectable
class AddMoneyUseCase implements Usecase<Either, double> {
  final WalletRepository _repository;

  AddMoneyUseCase(this._repository);

  @override
  Future<Either> call({double? params}) {
    return _repository.addMoney(params!);
  }
}
