class CreateUserRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String password;
  final DateTime dateOfBirth;
  final String gender;

  CreateUserRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.dateOfBirth,
    required this.gender,
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'passwordHash': password,
        'dateOfBirth': dateOfBirth.toIso8601String(),
        'gender': gender,
        'location': 'Saudi Arabia',
      };
}
