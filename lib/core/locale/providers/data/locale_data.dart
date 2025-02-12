import 'dart:ui';

import 'package:escooter/core/configs/services/storage/storage_service.dart';
import 'package:escooter/core/locale/providers/provider/locale_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(StorageService());
});
