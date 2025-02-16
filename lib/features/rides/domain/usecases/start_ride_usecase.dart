import 'package:dartz/dartz.dart';
import 'package:escooter/features/rides/data/service/location_service.dart';
import 'package:escooter/features/rides/domain/repository/ride_repository.dart';
import 'package:escooter/utils/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:escooter/core/usecases/usecase.dart';

class StartRideParams {
  final String scooterId;

  StartRideParams({required this.scooterId});
}

@injectable
class StartRideUseCase implements Usecase<void, StartRideParams> {
  final RideRepository _repository;
  final LocationService _locationService;

  StartRideUseCase(this._repository, this._locationService);

  @override
  Future<Either> call({StartRideParams? params}) async {
    try {
      final position = await _locationService.getCurrentLocation();
      final location = '${position.latitude},${position.longitude}';
      AppLogger.log('${position.latitude},${position.longitude}');
      return _repository.startRide(params!.scooterId, location);
    } catch (e) {
      return Left('Failed to get location: $e');
    }
  }
}
