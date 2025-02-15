import 'package:escooter/features/home/domain/entity/scooter/scooter.dart';

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
  final Scooter scooter;

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
    required this.scooter,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'],
      userId: json['userId'],
      scooterId: json['scooterId'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      distanceCovered: json['distanceCovered'].toDouble(),
      totalPrice: json['totalPrice'].toDouble(),
      status: json['status'],
      startLocation: json['startLocation'],
      endLocation: json['endLocation'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      scooter: Scooter.fromJson(json['scooter']),
    );
  }
}
