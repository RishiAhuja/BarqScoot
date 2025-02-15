import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String token;

  @HiveField(2)
  final String phoneNumber;

  @HiveField(3)
  final String firstName;

  @HiveField(4)
  final String lastName;

  @HiveField(5)
  final DateTime dateOfBirth;

  @HiveField(6)
  final String gender;

  @HiveField(7)
  final bool isVerified;

  @HiveField(8)
  final String email;

  @HiveField(9)
  final String? location;

  @HiveField(10)
  final double walletBalance;

  @HiveField(11)
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.token,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.isVerified,
    required this.email,
    this.location,
    required this.walletBalance,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      token: json['token'] ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      gender: json['gender'],
      location: json['location'],
      walletBalance: (json['walletBalance'] as num).toDouble(),
      isVerified: json['isVerified'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
