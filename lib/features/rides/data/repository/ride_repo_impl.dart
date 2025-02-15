import 'package:dartz/dartz.dart';
import 'package:escooter/features/rides/data/model/ride_model.dart';
import 'package:escooter/features/rides/data/service/location_service.dart';
import 'package:escooter/features/rides/data/service/ride_service.dart';
import 'package:escooter/features/rides/domain/entities/start_ride_request.dart';
import 'package:escooter/features/rides/domain/repository/scooter_repository.dart';
import 'package:escooter/utils/logger.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RideRepository)
class RideRepositoryImpl implements RideRepository {
  final RideService _rideService;
  // ignore: unused_field
  final LocationService _locationService;

  RideRepositoryImpl(this._rideService, this._locationService);

  @override
  Future<Either<String, void>> startRide(
      String scooterId, String location) async {
    try {
      final request = StartRideRequest(
        scooterId: scooterId,
        startLocation: location,
      );

      await _rideService.startRide(request);
      AppLogger.log('ride started successfully');

      return const Right(null);
    } catch (e) {
      AppLogger.log('Failed to start ride: $e');
      return Left('Failed to start ride: $e');
    }
  }

  @override
  Future<Either<String, List<Ride>>> getRides() async {
    try {
      final result = await _rideService.getRides();
      final rides = result.map((json) => Ride.fromJson(json)).toList();
      return Right(rides);
    } catch (e) {
      return Left('Failed to get rides: $e');
    }
  }
}
