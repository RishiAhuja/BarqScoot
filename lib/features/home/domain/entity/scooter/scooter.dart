class Scooter {
  final String id;
  final double lat;
  final double lng;
  final int batteryLevel;
  final double distance;
  final String status;

  Scooter({
    required this.status,
    required this.id,
    required this.lat,
    required this.lng,
    required this.batteryLevel,
    required this.distance,
  });
}
