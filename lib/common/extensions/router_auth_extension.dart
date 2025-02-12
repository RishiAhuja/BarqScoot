import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:escooter/common/router/app_router.dart';
import 'package:escooter/core/di/service_locator/service_locator.dart';
import 'package:escooter/core/configs/services/storage/storage_service.dart';

extension RouterExtension on BuildContext {
  void authenticateAndRedirect() async {
    AppRouter.getAuthNotifier.setAuthenticated(true);
    go(AppPaths.home);
  }

  void logout() async {
    AppRouter.getAuthNotifier.setAuthenticated(false);
    final storageService = getIt<StorageService>();
    await storageService.deleteUser();
    go(AppPaths.auth);
  }
}
