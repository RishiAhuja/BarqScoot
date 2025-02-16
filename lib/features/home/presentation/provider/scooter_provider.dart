import 'package:escooter/core/di/service_locator/service_locator.dart';
import 'package:escooter/features/home/domain/entity/scooter/scooter.dart';
import 'package:escooter/features/home/domain/repository/scooter_repository.dart';
import 'package:escooter/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scooter_provider.g.dart';

@Riverpod(keepAlive: true)
class ScootersNotifier extends _$ScootersNotifier {
  @override
  FutureOr<List<Scooter>> build() async {
    return _loadScooters();
  }

  Future<List<Scooter>> _loadScooters() async {
    final result = await getIt<ScooterRepository>().getScooters();
    return result.fold(
      (failure) {
        AppLogger.error(failure);
        throw Exception(failure);
      },
      (scooters) {
        // scooters.forEach((s) => AppLogger.log(s.id));
        return scooters;
      },
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadScooters());
  }
}
