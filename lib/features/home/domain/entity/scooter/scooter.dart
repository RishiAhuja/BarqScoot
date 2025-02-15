class Scooter {
  final String id;
  final String name;
  final String location;
  final String lastStation;
  final int batteryLevel;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String lastUpdatedBy;
  late final double latitude;
  late final double longitude;

  Scooter({
    required this.id,
    required this.name,
    required this.location,
    required this.lastStation,
    required this.batteryLevel,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.lastUpdatedBy,
  }) {
    final coordinates = location.split(',');
    latitude = double.parse(coordinates[0].trim());
    longitude = double.parse(coordinates[1].trim());
  }

  factory Scooter.fromJson(Map<String, dynamic> json) {
    return Scooter(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      lastStation: json['lastStation'],
      batteryLevel: json['batteryLevel'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      createdBy: json['createdBy'],
      lastUpdatedBy: json['lastUpdatedBy'],
    );
  }
}
