import 'package:escooter/core/di/service_locator/service_locator.dart';
import 'package:escooter/features/home/data/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escooter/core/configs/services/storage/storage_service.dart';

final userProvider = Provider<UserModel?>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return storageService.getUser();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return getIt<StorageService>();
});
