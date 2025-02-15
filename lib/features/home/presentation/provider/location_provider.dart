import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_provider.g.dart';

@riverpod
class UserLocation extends _$UserLocation {
  Position? _lastKnownPosition;
  @override
  FutureOr<Position> build() async {
    return _getCurrentPosition();
  }

  Future<Position> _getCurrentPosition() async {
    // If we already have a position, return it immediately
    if (_lastKnownPosition != null) return _lastKnownPosition!;

    // Get current position
    final position = await Geolocator.getCurrentPosition();
    _lastKnownPosition = position;
    return position;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _getCurrentPosition());
  }
}
