// lib/core/error/exceptions.dart
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  factory ApiException.fromResponse(http.Response response) {
    return ApiException(
      'API Error: ${response.body}',
      statusCode: response.statusCode,
    );
  }

  factory ApiException.fromError(dynamic error) {
    return ApiException('Network Error: $error');
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);
}
