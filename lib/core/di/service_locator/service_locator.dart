// lib/core/di/service_locator.dart
import 'package:escooter/core/di/service_locator/service_locator.config.dart';
import 'package:escooter/features/auth/data/sources/auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
// import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  await dotenv.load(fileName: ".env");

  await getIt.init();
  assert(getIt.isRegistered<http.Client>(instanceName: 'httpClient'));
  assert(getIt.isRegistered<AuthApiService>(instanceName: 'authApiService'));

  // Any async dependencies
  await _initializeAsyncDependencies();
}

Future<void> _initializeAsyncDependencies() async {}
