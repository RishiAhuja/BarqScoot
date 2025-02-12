// lib/core/di/modules/network_module.dart
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

@module
abstract class NetworkModule {
  @Named('httpClient')
  @singleton
  http.Client get httpClient => http.Client();
}
