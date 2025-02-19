import 'package:dartz/dartz.dart';

abstract class WalletRepository {
  Future<Either<String, double>> getBalance();
  Future<Either<String, bool>> addMoney(double amount);
}
