class OtpResponse {
  final String verificationId;
  final String message;

  OtpResponse({
    required this.verificationId,
    required this.message,
  });

  // Add fromJson factory constructor
  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      verificationId: json['data']['verificationId'] as String,
      message:
          json['message'] as String? ?? 'Verification code sent successfully',
    );
  }
}
