import 'package:escooter/core/configs/enviroment/environment_config.dart';

class BaseApi {
  static String get baseUrl => EnvConfig.apiBaseUrl;
  static String get baseScooterUrl => EnvConfig.apiBaseScooterUrl;
}
