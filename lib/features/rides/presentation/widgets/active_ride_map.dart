import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:escooter/features/home/presentation/provider/location_provider.dart';
import 'package:escooter/features/rides/presentation/providers/scooter_location_provider.dart';

class ActiveRideMap extends ConsumerStatefulWidget {
  final String scooterId;

  const ActiveRideMap({
    super.key,
    required this.scooterId,
  });

  @override
  ConsumerState<ActiveRideMap> createState() => _ActiveRideMapState();
}

class _ActiveRideMapState extends ConsumerState<ActiveRideMap> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(scooterLocationProvider.notifier)
          .connectToScooter(widget.scooterId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationAsync = ref.watch(userLocationProvider);
    final scooterLocationAsync = ref.watch(scooterLocationProvider);

    return locationAsync.when(
      data: (userLocation) {
        final userLatLng =
            LatLng(userLocation.latitude, userLocation.longitude);
        final userMarker = _buildUserMarker(userLatLng);

        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: userLatLng,
            zoom: 16.0,
            maxZoom: 18,
            minZoom: 3,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.escooter',
            ),
            MarkerLayer(
              markers: [
                userMarker,
                if (scooterLocationAsync.hasValue &&
                    scooterLocationAsync.value != null)
                  _buildScooterMarker(scooterLocationAsync.value!),
              ],
            ),
            if (scooterLocationAsync.hasValue &&
                scooterLocationAsync.value != null)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [
                      userLatLng,
                      LatLng(
                        scooterLocationAsync.value!.latitude,
                        scooterLocationAsync.value!.longitude,
                      ),
                    ],
                    color: Colors.blue,
                    strokeWidth: 3.0,
                  ),
                ],
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text('Error: ${error.toString()}'),
      ),
    );
  }

  Marker _buildUserMarker(LatLng position) {
    return Marker(
      point: position,
      child: const Icon(
        Icons.person_pin_circle,
        color: Colors.blue,
        size: 40,
      ),
    );
  }

  Marker _buildScooterMarker(ScooterLocation location) {
    return Marker(
      point: LatLng(location.latitude, location.longitude),
      child: Stack(
        children: [
          Icon(
            Icons.location_on,
            color: Colors.orange[700],
            size: 40,
            shadows: const [
              Shadow(
                offset: Offset(0, 2),
                blurRadius: 4,
                color: Colors.black26,
              ),
            ],
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Icon(
                  Icons.electric_scooter,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
