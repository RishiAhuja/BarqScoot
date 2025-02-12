import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get apiBaseUrl =>
      dotenv.get('API_BASE_URL', fallback: 'http://10.0.2.2:8091/api');
}
