import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:escooter/core/di/service_locator/service_locator.dart';
import 'package:escooter/core/configs/services/storage/storage_service.dart';

part 'user_stats_provider.g.dart';

class UserStats {
  final int totalRides;
  final double walletBalance;

  const UserStats({
    required this.totalRides,
    required this.walletBalance,
  });
}

@Riverpod(keepAlive: true)
class UserStatsNotifier extends _$UserStatsNotifier {
  @override
  FutureOr<UserStats> build() async {
    return _loadStats();
  }

  Future<UserStats> _loadStats() async {
    try {
      final user = getIt<StorageService>().getUser();
      if (user == null) {
        throw Exception('User not found');
      }

      return UserStats(
        totalRides: 0, // TODO: Implement total rides count
        walletBalance: user.walletBalance,
      );
    } catch (e) {
      throw Exception('Failed to load stats: $e');
    }
  }

  Future<void> refresh(AsyncValue state) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadStats());
  }
}
