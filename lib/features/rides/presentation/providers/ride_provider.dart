import 'package:escooter/features/rides/domain/repository/scooter_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:escooter/features/rides/data/model/ride_model.dart';
import 'package:escooter/core/di/service_locator/service_locator.dart';

part 'ride_provider.g.dart';

@riverpod
class Rides extends _$Rides {
  @override
  FutureOr<List<Ride>> build() async {
    return _fetchRides();
  }

  Future<List<Ride>> _fetchRides() async {
    final result = await getIt<RideRepository>().getRides();
    return result.fold(
      (failure) => throw Exception(failure),
      (rides) => rides,
    );
  }

  List<Ride> getCompletedRides() {
    return state.value?.where((ride) => ride.status == 'completed').toList() ??
        [];
  }

  List<Ride> getOngoingRides() {
    return state.value?.where((ride) => ride.status == 'ongoing').toList() ??
        [];
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchRides());
  }
}
