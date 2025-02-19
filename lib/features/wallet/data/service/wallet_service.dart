import 'dart:convert';
import 'package:escooter/core/configs/services/api/base_api.dart';
import 'package:escooter/core/configs/services/storage/storage_service.dart';
import 'package:escooter/core/error/api_exceptions.dart';
import 'package:escooter/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@lazySingleton
class WalletService {
  final http.Client _client;
  final StorageService _storageService;

  WalletService(@Named('httpClient') this._client, this._storageService);

  Future<double> getBalance() async {
    try {
      AppLogger.log('Getting user from storage');

      final user = _storageService.getUser();
      if (user == null) throw ApiException('User not authenticated');

      final token = user.token;
      AppLogger.log('Token retrieved successfully');

      final response = await _client.get(
        Uri.parse('${BaseApi.basePaymentUrl}/v1/wallet/balance'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      AppLogger.log(
          'Response received: ${response.statusCode} | ${response.body}');

      if (response.statusCode != 200) {
        throw ApiException(
            'Failed to get balance: ${response.statusCode} | ${response.body}');
      }

      final data = jsonDecode(response.body);
      if (data['balance'] == null) {
        throw ApiException('Invalid response format: balance not found');
      }
      AppLogger.log('Balance retrieved successfully: ${data['balance']}');

      return double.parse(data['balance'].toString());
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to get balance: $e');
    }
  }

  Future<bool> addMoney(double amount) async {
    try {
      AppLogger.log('Getting user from storage');
      final user = _storageService.getUser();
      if (user == null) throw ApiException('User not authenticated');

      final token = user.token;
      AppLogger.log('Token retrieved successfully');

      final response = await _client.post(
        Uri.parse('${BaseApi.basePaymentUrl}/v1/wallet/transactions'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'amount': amount,
          'type': 'credit',
        }),
      );

      AppLogger.log(
          'Response received: ${response.statusCode} | ${response.body}');

      if (response.statusCode != 200) {
        throw ApiException(
            'Failed to add money: ${response.statusCode} | ${response.body}');
      }

      AppLogger.log('Money added successfully');
      return true;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to add money: $e');
    }
  }
}
