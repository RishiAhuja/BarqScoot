import 'package:escooter/features/rides/domain/repository/ride_repository.dart';
import 'package:escooter/features/rides/domain/usecases/end_ride_usecase.dart';
import 'package:escooter/utils/logger.dart';
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

  Future<void> endRide(String rideId, String scooterId) async {
    try {
      final params = EndRideParams(
        rideId: rideId,
        scooterId: scooterId,
      );

      final result = await getIt<EndRideUseCase>()(params: params);

      return result.fold(
        (failure) => throw Exception(failure),
        (_) => refresh(),
      );
    } catch (e) {
      AppLogger.error('Failed to end ride in provider', error: e);
      rethrow;
    }
  }
}
