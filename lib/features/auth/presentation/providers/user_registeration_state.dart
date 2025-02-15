import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRegistrationState {
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String gender;
  final String phoneNumber;
  final String email;

  UserRegistrationState(
      {required this.firstName,
      required this.lastName,
      required this.dateOfBirth,
      required this.gender,
      required this.phoneNumber,
      required this.email});

  UserRegistrationState copyWith({
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? gender,
    String? phoneNumber,
  }) {
    return UserRegistrationState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email,
    );
  }
}

final userRegistrationProvider =
    StateNotifierProvider<UserRegistrationNotifier, UserRegistrationState?>(
        (ref) {
  return UserRegistrationNotifier();
});

class UserRegistrationNotifier extends StateNotifier<UserRegistrationState?> {
  UserRegistrationNotifier() : super(null);

  void saveRegistrationData(UserRegistrationState data) {
    state = data;
  }

  void clear() {
    state = null;
  }
}
