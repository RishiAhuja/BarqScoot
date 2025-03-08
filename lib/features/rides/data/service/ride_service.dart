import 'dart:convert';

import 'package:escooter/core/configs/services/api/base_api.dart';
// import 'package:escooter/features/rides/data/model/ride_model.dart';
import 'package:escooter/features/rides/domain/entities/end_ride_request.dart';
import 'package:escooter/features/rides/domain/entities/start_ride_request.dart';
// import 'package:escooter/main.dart';
import 'package:escooter/utils/logger.dart';
// import 'package:flutter/src/widgets/framework.dart';
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
      AppLogger.error('Failed to start ride: ${response.body}');
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
      AppLogger.log('User token: ${user?.token}');
      if (user == null) throw ApiException('User not authenticated');

      final response = await _client.get(
        Uri.parse('${BaseApi.baseScooterUrl}/v1/rides'),
        headers: {
          'Authorization': 'Bearer ${user.token}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Map<String, dynamic>> rides =
            List<Map<String, dynamic>>.from(data);
        // AppLogger.log('Fetched rides: $rides');
        // Process ongoing rides to fetch scooter details
        final updatedRides = await Future.wait(rides.map((ride) async {
          if (ride['status'] == 'ongoing') {
            try {
              final scooterId = ride['scooterId'] as String;
              final scooterResponse = await getScooterById(scooterId);

              return {
                ...ride,
                'scooter': scooterResponse,
                'isPaid': false,
              };
            } catch (e) {
              AppLogger.error('Failed to fetch scooter for ride: ${ride['id']}',
                  error: e);
              return ride;
            }
          }
          return ride;
        }));

        // AppLogger.log('Updated rides with scooter details: $updatedRides');
        return updatedRides;
      }

      AppLogger.error('Failed to get rides: ${response.body}');
      throw ApiException.fromResponse(response);
    } catch (e) {
      AppLogger.error('Failed to fetch rides', error: e);
      throw ApiException('Failed to fetch rides: $e');
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

  Future<Map<String, dynamic>> endRide(
      String rideId, EndRideRequest request) async {
    try {
      final user = _storageService.getUser();
      if (user == null) throw ApiException('User not authenticated');

      AppLogger.log('Ending ride with ID: $rideId');
      AppLogger.log('hitting: ${BaseApi.baseScooterUrl}/v1/rides/$rideId/end');

      final response = await _client.put(
        Uri.parse('${BaseApi.baseScooterUrl}/v1/rides/$rideId/end'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${user.token}',
        },
        body: jsonEncode(request.toJson()),
      );

      AppLogger.log('End Ride Response Status: ${response.statusCode}');
      AppLogger.log('End Ride Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> rideData = jsonDecode(response.body);
        // Add isPaid field
        rideData['isPaid'] = false;
        return rideData;
      }

      AppLogger.error('Failed to end ride: ${response.body}');
      throw ApiException.fromResponse(response);
    } on ApiException catch (e) {
      AppLogger.error('API Error while ending ride', error: e);
      rethrow;
    } catch (e) {
      final message = 'Failed to end ride: $e';
      AppLogger.error(message);
      throw ApiException(message);
    }
  }
}
