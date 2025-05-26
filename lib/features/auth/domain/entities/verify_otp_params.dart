class VerifyOtpParams {
  final String phoneNumber;
  final String verificationId;
  final String otp;

  VerifyOtpParams({
    required this.phoneNumber,
    required this.verificationId,
    required this.otp,
  });
}
