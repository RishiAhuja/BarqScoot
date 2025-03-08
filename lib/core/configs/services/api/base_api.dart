import 'package:escooter/core/configs/enviroment/environment_config.dart';

class BaseApi {
  static String get baseUrl => EnvConfig.apiBaseUrl;
  static String get baseScooterUrl => EnvConfig.apiBaseScooterUrl;
  static String get basePaymentUrl => EnvConfig.apiPaymentUrl;
  static String get socketScooterUrl => EnvConfig.socketBaseScooterUrl;
  static String get apiPromoService => EnvConfig.apiPromoService;
}
