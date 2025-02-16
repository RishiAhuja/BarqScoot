import 'package:escooter/features/home/domain/entity/scooter/scooter.dart';
import 'package:escooter/utils/logger.dart';

class Ride {
  final String id;
  final String userId;
  final String scooterId;
  final DateTime startTime;
  final DateTime? endTime;
  final double distanceCovered;
  final double totalPrice;
  final String status;
  final String startLocation;
  final String? endLocation;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Scooter? scooter; // Make scooter optional

  const Ride({
    required this.id,
    required this.userId,
    required this.scooterId,
    required this.startTime,
    this.endTime,
    required this.distanceCovered,
    required this.totalPrice,
    required this.status,
    required this.startLocation,
    this.endLocation,
    required this.createdAt,
    required this.updatedAt,
    this.scooter, // Make optional in constructor
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    try {
      AppLogger.log('Parsing ride JSON: ${json.toString()}');

      return Ride(
        id: json['id'] as String,
        userId: json['userId'] as String,
        scooterId: json['scooterId'] as String,
        startTime: DateTime.parse(json['startTime']),
        endTime:
            json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
        distanceCovered: (json['distanceCovered'] is int)
            ? (json['distanceCovered'] as int).toDouble()
            : double.tryParse(json['distanceCovered'].toString()) ?? 0.0,
        totalPrice: (json['totalPrice'] is int)
            ? (json['totalPrice'] as int).toDouble()
            : double.tryParse(json['totalPrice'].toString()) ?? 0.0,
        status: json['status'] as String,
        startLocation: json['startLocation'] as String,
        endLocation: json['endLocation'] as String?,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        scooter: json['scooter'] != null
            ? _parseScooter(json['scooter'] as Map<String, dynamic>)
            : null,
      );
    } catch (e, stack) {
      AppLogger.error(
        'Error parsing Ride JSON',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  // Helper method to parse scooter data
  static Scooter? _parseScooter(Map<String, dynamic> json) {
    // Check if all values are empty
    if (json.values.every((value) =>
        value == '' || value == 0 || value == '0001-01-01T00:00:00Z')) {
      return null;
    }
    return Scooter.fromJson(json);
  }
}
