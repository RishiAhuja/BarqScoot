// lib/core/configs/api_config.dart
import 'package:escooter/core/configs/services/api/base_api.dart';

class AuthApiEndpoints {
  static String get _baseUrl => BaseApi.baseUrl;
  static String get signupUrl => '$_baseUrl/auth/signup';
  static String get loginUrl => '$_baseUrl/auth/login';
  static String get sendOtpUrl => '$_baseUrl/auth/send-otp';
  static String get verifyOtpUrl => '$_baseUrl/auth/verify-otp';
}
