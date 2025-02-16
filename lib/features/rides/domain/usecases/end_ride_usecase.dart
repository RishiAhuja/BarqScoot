import 'package:dartz/dartz.dart';
import 'package:escooter/features/rides/data/service/location_service.dart';
import 'package:escooter/features/rides/domain/repository/ride_repository.dart';
import 'package:escooter/features/rides/domain/entities/end_ride_request.dart';
import 'package:escooter/utils/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:escooter/core/usecases/usecase.dart';

class EndRideParams {
  final String rideId;
  final String scooterId;

  EndRideParams({
    required this.rideId,
    required this.scooterId,
  });
}

@injectable
class EndRideUseCase implements Usecase<void, EndRideParams> {
  final RideRepository _repository;
  final LocationService _locationService;

  EndRideUseCase(this._repository, this._locationService);

  @override
  Future<Either<String, void>> call({EndRideParams? params}) async {
    try {
      final position = await _locationService.getCurrentLocation();
      final endLocation = '${position.latitude},${position.longitude}';

      AppLogger.log('Ending ride at location: $endLocation');

      final request = EndRideRequest(
        scooterId: params!.scooterId,
        endLocation: endLocation,
      );

      return _repository.endRide(
        params.rideId,
        request,
      );
    } catch (e) {
      AppLogger.error('Failed to end ride', error: e);
      return Left('Failed to end ride: $e');
    }
  }
}
