import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_stats_provider.g.dart';

class UserStats {
  final int totalRides;
  final double balance;

  UserStats({required this.totalRides, required this.balance});
}

@riverpod
class UserStatsNotifier extends _$UserStatsNotifier {
  @override
  Future<UserStats> build() async {
    // TODO: Implement API call
    return UserStats(totalRides: 15, balance: 150.0);
  }
}
