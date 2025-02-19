import 'package:escooter/core/error/api_exceptions.dart';
import 'package:escooter/features/wallet/data/service/wallet_service.dart';
import 'package:escooter/features/wallet/domain/repository/wallet_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: WalletRepository)
class WalletRepositoryImpl implements WalletRepository {
  final WalletService _service;

  WalletRepositoryImpl(this._service);

  @override
  Future<Either<String, double>> getBalance() async {
    try {
      final balance = await _service.getBalance();
      return Right(balance);
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left('Failed to get balance: $e');
    }
  }

  @override
  Future<Either<String, bool>> addMoney(double amount) async {
    try {
      final result = await _service.addMoney(amount);
      return Right(result);
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left('Failed to add money: $e');
    }
  }
}
