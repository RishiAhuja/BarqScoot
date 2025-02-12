import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_provider.g.dart';

@riverpod
class LocationNotifier extends _$LocationNotifier {
  @override
  Future<Position> build() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle case where user denies permission
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle case where user has previously denied permissions permanently
      throw Exception(
          'Location permissions are permanently denied, please enable them in settings');
    }

    // If we got here, permissions are granted
    return await Geolocator.getCurrentPosition();
  }

  Future<void> refreshLocation() async {
    // Using state = makes the provider notify listeners
    state = const AsyncValue.loading();
    try {
      final position = await Geolocator.getCurrentPosition();
      state = AsyncValue.data(position);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> requestPermission() async {
    final permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever) {
      // Refresh the state to get location
      ref.invalidateSelf();
    }
  }
}
