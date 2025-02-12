import 'package:escooter/core/configs/services/storage/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  final StorageService _storage;

  LocaleNotifier(this._storage) : super(const Locale('en')) {
    _initializeLocale();
  }

  Future<void> _initializeLocale() async {
    final savedLanguage = await _storage.getLanguage();
    if (savedLanguage != null) {
      state = Locale(savedLanguage);
    }
  }

  Future<void> setLocale(String languageCode) async {
    if (['en', 'ar'].contains(languageCode)) {
      await _storage.setLanguage(languageCode);
      state = Locale(languageCode);
    }
  }
}
