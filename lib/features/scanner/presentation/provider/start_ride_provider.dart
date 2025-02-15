import 'package:escooter/core/di/service_locator/service_locator.dart';
import 'package:escooter/features/rides/domain/usecases/start_ride_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final startRideUseCaseProvider = Provider<StartRideUseCase>((ref) {
  return getIt<StartRideUseCase>();
});
