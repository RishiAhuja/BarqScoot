import 'dart:convert';
import 'package:escooter/core/configs/services/storage/storage_service.dart';
import 'package:escooter/core/error/api_exceptions.dart';
import 'package:escooter/utils/logger.dart';
import 'package:http/http.dart' as http;

import '../../../../core/configs/services/api/base_api.dart';

class PromoService {
  final StorageService _storageService;

  PromoService(this._storageService);

  Future<Map<String, dynamic>> validatePromoCode(String promoCode) async {
    try {
      final user = _storageService.getUser();
      if (user == null) throw ApiException('User not authenticated');

      AppLogger.log('Validating promo code: $promoCode');
      final client = http.Client();
      final response = await client.get(
        Uri.parse('${BaseApi.apiPromoService}/v1/promos/validate/$promoCode'),
        headers: {
          'Authorization': 'Bearer ${user.token}',
        },
      );

      AppLogger.log('Promo validation response: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      throw ApiException.fromResponse(response);
    } catch (e) {
      AppLogger.error('Failed to validate promo code', error: e);
      throw ApiException('Failed to validate promo code: $e');
    }
  }
}
