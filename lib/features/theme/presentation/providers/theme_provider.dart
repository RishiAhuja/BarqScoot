import 'package:escooter/core/configs/constants/shared_prefs_constants.dart';
import 'package:escooter/core/configs/services/storage/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/theme_state.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier(StorageService());
});

class ThemeNotifier extends StateNotifier<ThemeState> {
  final StorageService _storage;

  ThemeNotifier(this._storage) : super(ThemeState.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDark =
        await _storage.getBool(SharedPrefsConstants.themeModeKey) ?? false;
    state = isDark ? ThemeState.dark : ThemeState.light;
  }

  Future<void> toggleTheme() async {
    state = state.isDark ? ThemeState.light : ThemeState.dark;
    await _storage.setBool(SharedPrefsConstants.themeModeKey, state.isDark);
  }
}
