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

  UserModel({
    required this.id,
    required this.token,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.isVerified,
  });
}
