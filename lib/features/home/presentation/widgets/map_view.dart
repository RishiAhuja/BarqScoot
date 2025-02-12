import 'package:escooter/features/home/presentation/provider/location_provider.dart';
import 'package:escooter/features/home/presentation/provider/scooter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class MapView extends ConsumerStatefulWidget {
  const MapView({super.key});

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  final MapController mapController = MapController();
  List<Marker> scooterMarkers = [];

  @override
  Widget build(BuildContext context) {
    final locationAsync = ref.watch(locationNotifierProvider);
    final scootersAsync = ref.watch(scootersNotifierProvider);

    return locationAsync.when(
      data: (location) {
        final userLatLng = LatLng(location.latitude, location.longitude);

        // Create user location marker
        final userMarker = Marker(
          point: userLatLng,
          width: 40,
          height: 40,
          child: Icon(
            Icons.location_on,
            color: Colors.blue,
            size: 40,
          ),
        );

        // Update scooter markers when scooter data changes
        scootersAsync.whenData((scooters) {
          scooterMarkers = scooters
              .map((scooter) => Marker(
                    child: Tooltip(
                      message: 'Battery: ${scooter.batteryLevel}%',
                      child: const Icon(
                        Icons.electric_scooter,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                    point: LatLng(scooter.lat, scooter.lng),
                    width: 30,
                    height: 30,
                    // builder: (context) =>
                  ))
              .toList();
        });

        return FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: userLatLng,
            zoom: 15.0,
            maxZoom: 18,
            minZoom: 3,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.escooter',
            ),
            MarkerLayer(
              markers: [userMarker], // User location marker
            ),
            MarkerClusterLayerWidget(
              options: MarkerClusterLayerOptions(
                maxClusterRadius: 45,
                size: const Size(40, 40),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(50),
                maxZoom: 15,
                markers: scooterMarkers,
                builder: (context, markers) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue),
                    child: Center(
                      child: Text(
                        markers.length.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading map...'),
          ],
        ),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: 16),
            Text('Error loading map: ${error.toString()}'),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => ref.refresh(locationNotifierProvider),
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
