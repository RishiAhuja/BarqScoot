class OtpResponse {
  final String status;
  final String message;
  final String sid;

  OtpResponse({
    required this.status,
    required this.message,
    required this.sid,
  });

  // Factory constructor to create OtpResponse from JSON
  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      sid: json['sid'] as String,
    );
  }
}
