import 'package:dartz/dartz.dart';
import 'package:escooter/features/rides/data/model/ride_model.dart';

abstract class RideRepository {
  Future<Either<String, void>> startRide(String scooterId, String location);
  Future<Either<String, List<Ride>>> getRides();
}
