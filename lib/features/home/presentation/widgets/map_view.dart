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
    final locationAsync = ref.watch(userLocationProvider);
    final scootersAsync = ref.watch(scootersNotifierProvider);

    return locationAsync.when(
      data: (location) {
        final userLatLng = LatLng(location.latitude, location.longitude);
        final userMarker = Marker(
          point: userLatLng,
          width: 40,
          height: 40,
          child: Icon(
            Icons.location_on,
            color: Colors.teal[700],
            size: 40,
          ),
        );
        scootersAsync.whenData((scooters) {
          scooterMarkers = scooters.map((scooter) {
            final scooterLatLng = LatLng(scooter.latitude, scooter.longitude);

            return Marker(
              point: scooterLatLng,
              width: 40, // Increased size
              height: 40,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scooter.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.battery_charging_full,
                                color: _getBatteryColor(scooter.batteryLevel),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text('${scooter.batteryLevel}%'),
                              const SizedBox(width: 16),
                              Icon(
                                scooter.status == 'available'
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: scooter.status == 'available'
                                    ? Colors.green
                                    : Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(scooter.status),
                            ],
                          ),
                        ],
                      ),
                      backgroundColor: Colors.black87,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.all(16),
                      duration: const Duration(seconds: 3),
                      action: SnackBarAction(
                        label: 'SCAN',
                        onPressed: () {
                          // Navigate to scanner with scooter id
                          // context.push('/scanner/${scooter.id}');
                        },
                        textColor: Colors.orangeAccent,
                      ),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.orange[700],
                      size: 40, // Increased size
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
                            size: 20, // Increased size
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList();
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
              markers: [userMarker, ...scooterMarkers], // Combined markers
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
                      color: Colors.orange[700],
                    ),
                    child: Center(
                      child: Text(
                        markers.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ),
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
              onPressed: () => ref.refresh(userLocationProvider),
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

  // Add this helper method to the class
  Color _getBatteryColor(int level) {
    if (level > 70) return Colors.green;
    if (level > 30) return Colors.orange;
    return Colors.red;
  }
}
