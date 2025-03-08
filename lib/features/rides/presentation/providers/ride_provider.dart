import 'package:escooter/features/rides/domain/repository/ride_repository.dart';
import 'package:escooter/features/rides/domain/usecases/end_ride_usecase.dart';
// import 'package:escooter/features/rides/presentation/screens/ride_payment_screen.dart';
import 'package:escooter/utils/logger.dart';
// import 'package:flutter/material.dart';
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

  Future<Ride?> endRide(String rideId, String scooterId) async {
    try {
      final params = EndRideParams(
        rideId: rideId,
        scooterId: scooterId,
      );

      final result = await getIt<EndRideUseCase>()(params: params);

      return result.fold(
        (failure) => throw Exception(failure),
        (_) async {
          await refresh();
          final ride = state.value?.firstWhere(
            (ride) => ride.id == rideId,
            orElse: () => throw Exception('Ride not found'),
          );

          if (ride != null) {
            const double minuteRate = 0.15;
            const double distanceRate = 0.5;

            final duration = ride.endTime!.difference(ride.startTime);
            final timeBasedCost = duration.inMinutes * minuteRate;
            final distanceBasedCost = ride.distanceCovered * distanceRate;
            final totalPrice = timeBasedCost + distanceBasedCost;

            final completedRide = ride.copyWith(totalPrice: totalPrice);

            // context.go('/ride-payment', arguments: completedRide);
            // context.goNamed('/ride-payment', arguments: completedRide);
            AppLogger.log(
              'Completed ride: $completedRide : cost: ${completedRide.totalPrice}',
            );
            return completedRide;
          }
          return null;
        },
      );
    } catch (e) {
      AppLogger.error('Failed to end ride in provider', error: e);
      rethrow;
    }
  }
}
