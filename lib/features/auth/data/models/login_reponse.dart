class LoginResponse {
  final String token;
  final String? refreshToken;
  final bool isNewUser;

  LoginResponse({
    required this.token,
    this.refreshToken,
    this.isNewUser = false,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['data']?['token'] ?? json['token'] ?? '',
      refreshToken: json['data']?['refreshToken'] ?? json['refreshToken'],
      isNewUser: json['data']?['isNewUser'] ?? json['isNewUser'] ?? false,
    );
  }
}
