class LoginResponse {
  final String status;
  final String token;

  LoginResponse({
    required this.status,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] as String,
      token: json['token'] as String,
    );
  }
}
