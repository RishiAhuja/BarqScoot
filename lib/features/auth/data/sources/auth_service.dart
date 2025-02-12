import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:escooter/core/configs/services/api/base_api_config.dart';
import 'package:escooter/core/error/api_exceptions.dart';
import 'package:escooter/features/auth/domain/entities/create_user_request.dart';
import 'package:escooter/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@injectable
@Named('authApiService')
class AuthApiService {
  final http.Client _client;

  @factoryMethod
  AuthApiService(@Named('httpClient') this._client);

  Future<Either<ApiException, Map<String, dynamic>>> sendOtp(
      String phoneNumber) async {
    try {
      final response = await _client.post(
        Uri.parse(AuthApiEndpoints.sendOtpUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phoneNumber': phoneNumber}),
      );

      // Log response for debugging
      AppLogger.log('OTP Response Status: ${response.statusCode}');
      AppLogger.log('OTP Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return Right(responseData);
      }

      return Left(ApiException.fromResponse(response));
    } catch (e) {
      AppLogger.error('Error sending OTP: $e');
      return Left(ApiException.fromError(e));
    }
  }

  Future<Either<ApiException, Map<String, dynamic>>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(AuthApiEndpoints.verifyOtpUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'otp': otp,
        }),
      );

      // Log response for debugging
      AppLogger.log('Verify OTP Response Status: ${response.statusCode}');
      AppLogger.log('Verify OTP Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return Right(responseData);
      }

      return Left(ApiException.fromResponse(response));
    } catch (e) {
      AppLogger.error('Error verifying OTP: $e');
      return Left(ApiException.fromError(e));
    }
  }

  Future<Either<ApiException, Map<String, dynamic>>> registerUser(
      CreateUserRequest createUserRequest) async {
    try {
      final payload = createUserRequest.toJson();
      AppLogger.log('Request payload: ${jsonEncode(payload)}');
      final response = await _client.post(
        Uri.parse(AuthApiEndpoints.signupUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(createUserRequest.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        AppLogger.log('Status code: ${response.statusCode}');
        AppLogger.log('Response body: ${response.body}');
        return Right(jsonDecode(response.body));
      }
      AppLogger.log("From auth service: ${response.statusCode}");
      AppLogger.error(ApiException.fromResponse(response).message);
      return Left(ApiException.fromResponse(response));
    } catch (e) {
      return Left(ApiException.fromError(e));
    }
  }
}
