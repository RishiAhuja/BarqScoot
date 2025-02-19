import 'package:escooter/core/di/service_locator/service_locator.dart';
import 'package:escooter/features/wallet/domain/usecases/add_money_usecase.dart';
import 'package:escooter/features/wallet/domain/usecases/get_balance_usecase.dart';
import 'package:escooter/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final balanceProvider = AsyncNotifierProvider<BalanceNotifier, double>(() {
  return BalanceNotifier();
});

class BalanceNotifier extends AsyncNotifier<double> {
  @override
  Future<double> build() async {
    return _fetchBalance();
  }

  Future<double> _fetchBalance() async {
    AppLogger.log('Fetching wallet balance');

    final result = await getIt<GetBalanceUseCase>().call();

    return result.fold(
      (failure) {
        AppLogger.error('Failed to fetch balance', error: failure);
        throw Exception(failure);
      },
      (balance) {
        AppLogger.log('Balance fetched successfully: $balance');
        return balance;
      },
    );
  }

  // Future<void> refresh() async {
  //   state = const AsyncValue.loading();
  //   state = await AsyncValue.guard(() => _fetchBalance());
  // }

  Future<void> addMoney(double amount) async {
    state = const AsyncValue.loading();

    try {
      final result = await getIt<AddMoneyUseCase>().call(params: amount);

      result.fold(
        (failure) => throw Exception(failure),
        (success) async {
          if (success) {
            state = const AsyncValue.loading();
            state = await AsyncValue.guard(() => _fetchBalance());
          }
        },
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
