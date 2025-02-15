import 'dart:convert';

import 'package:escooter/core/configs/services/api/base_api.dart';
import 'package:escooter/features/rides/domain/entities/start_ride_request.dart';
import 'package:escooter/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:escooter/core/error/api_exceptions.dart';
import 'package:escooter/core/configs/services/storage/storage_service.dart';

@injectable
class RideService {
  final http.Client _client;
  final StorageService _storageService;

  RideService(
    @Named('httpClient') this._client,
    this._storageService,
  );

  Future<Map<String, dynamic>> startRide(StartRideRequest request) async {
    try {
      final user = _storageService.getUser();
      if (user == null) throw ApiException('User not authenticated');

      AppLogger.log('Starting ride with coordinates: ${request.startLocation}');
      AppLogger.log('user token: ${user.token}');
      AppLogger.log('hitting: ${BaseApi.baseScooterUrl}/v1/rides/start');

      final response = await _client.post(
        Uri.parse('${BaseApi.baseScooterUrl}/v1/rides/start'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${user.token}',
        },
        body: jsonEncode(request.toJson()),
      );

      // Log the response for debugging
      AppLogger.log('Response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }

      // Use fromResponse to get a properly formatted error message
      throw ApiException.fromResponse(response);
    } on ApiException catch (e) {
      AppLogger.error('API Error: ${e.message}');
      rethrow;
    } catch (e) {
      final message = 'Failed to start ride: ${e.toString()}';
      AppLogger.error(message);
      throw ApiException(message);
    }
  }

  Future<List<Map<String, dynamic>>> getRides() async {
    try {
      final user = _storageService.getUser();
      if (user == null) throw ApiException('User not authenticated');

      final response = await _client.get(
        Uri.parse('${BaseApi.baseScooterUrl}/v1/rides'),
        headers: {
          'Authorization': 'Bearer ${user.token}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        AppLogger.log(response.body);
        return List<Map<String, dynamic>>.from(data);
      }

      throw ApiException.fromResponse(response);
    } catch (e) {
      throw ApiException('Failed to fetch rides: $e');
    }
  }
}
