import 'package:escooter/features/home/domain/entity/scooter/scooter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scooter_provider.g.dart';

@riverpod
class ScootersNotifier extends _$ScootersNotifier {
  @override
  Future<List<Scooter>> build() async {
    // Initial load of scooters
    return _fetchScooters();
  }

  Future<List<Scooter>> _fetchScooters() async {
    // In a real app, this would be an API call
    return [
      Scooter(
          id: '1',
          lat: 24.7136,
          lng: 46.6753,
          batteryLevel: 85,
          distance: 0.5,
          status: 'Available'),
      // More scooters...
    ];
  }

  Future<void> filterByBattery(int minBattery) async {
    state = const AsyncValue.loading();
    try {
      final scooters = await _fetchScooters();
      final filtered =
          scooters.where((s) => s.batteryLevel >= minBattery).toList();
      state = AsyncValue.data(filtered);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
