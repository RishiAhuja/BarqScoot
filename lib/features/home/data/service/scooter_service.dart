import 'dart:convert';

import 'package:escooter/core/configs/services/api/base_api.dart';
import 'package:escooter/core/configs/services/storage/storage_service.dart';
import 'package:escooter/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:escooter/core/error/api_exceptions.dart';

@injectable
class ScooterService {
  final http.Client _client;
  final StorageService _storageService;

  ScooterService(
    @Named('httpClient') this._client,
    this._storageService,
  );

  Future<List<Map<String, dynamic>>> getScooters() async {
    try {
      final user = _storageService.getUser();
      if (user == null) throw ApiException('User not authenticated');

      final response = await _client.get(
        Uri.parse('${BaseApi.baseScooterUrl}/v1/scooters'),
        headers: {
          'Authorization': 'Bearer ${user.token}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      }

      AppLogger.error(
        'Failed to fetch scooters',
        error: 'Status: ${response.statusCode}, Body: ${response.body}',
      );
      throw ApiException.fromResponse(response);
    } catch (e) {
      if (e is http.ClientException) {
        AppLogger.error(
          'Network error while fetching scooters',
          error: e.message,
        );
      } else {
        AppLogger.error(
          'Error fetching scooters',
          error: e.toString(),
        );
      }
      throw ApiException('Failed to fetch scooters: $e');
    }
  }

  Future<Map<String, dynamic>> getScooterById(String scooterId) async {
    try {
      final user = _storageService.getUser();
      if (user == null) throw ApiException('User not authenticated');

      final response = await _client.get(
        Uri.parse('${BaseApi.baseScooterUrl}/v1/scooters/$scooterId'),
        headers: {
          'Authorization': 'Bearer ${user.token}',
        },
      );

      // AppLogger.log('Scooter Response Status: ${response.statusCode}');
      // AppLogger.log('Scooter Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      throw ApiException.fromResponse(response);
    } catch (e) {
      AppLogger.error('Failed to fetch scooter', error: e);
      throw ApiException('Failed to fetch scooter: $e');
    }
  }
}
