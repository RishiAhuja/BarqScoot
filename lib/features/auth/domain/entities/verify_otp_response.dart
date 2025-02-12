class VerifyOtpResponse {
  final String token;
  final UserData user;
  final String message;
  final String status;

  VerifyOtpResponse({
    required this.token,
    required this.user,
    required this.message,
    required this.status,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return VerifyOtpResponse(
      token: data['token'],
      user: UserData.fromJson(data['user']),
      message: json['message'],
      status: json['status'],
    );
  }
}

class UserData {
  final String id;
  final bool isVerified;
  final String phoneNumber;

  UserData({
    required this.id,
    required this.isVerified,
    required this.phoneNumber,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      isVerified: json['isVerified'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
