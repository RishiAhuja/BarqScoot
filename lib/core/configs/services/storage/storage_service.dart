import 'package:escooter/core/configs/constants/shared_prefs_constants.dart';
import 'package:escooter/features/home/data/model/user_model.dart';
import 'package:escooter/utils/logger.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

@singleton
class StorageService {
  static const String userBoxName = 'userBox';
  static const String isLoggedInKey = 'isLoggedIn';

  Box<UserModel>? _userBox;
  Box<String>? _settingsBox;

  Future<void> initHive() async {
    if (!Hive.isBoxOpen('userBox')) {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);

      // Register adapters if not registered
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(UserModelAdapter());
      }

      _userBox = await Hive.openBox<UserModel>('userBox');
      _settingsBox = await Hive.openBox<String>('settingsBox');

      AppLogger.log('Hive initialized successfully');
    }
  }

  Box<UserModel> get userBox {
    if (_userBox == null) {
      throw StateError('UserBox not initialized. Call initHive() first.');
    }
    return _userBox!;
  }

  Box<String> get settingsBox {
    if (_settingsBox == null) {
      throw StateError('SettingsBox not initialized. Call initHive() first.');
    }
    return _settingsBox!;
  }

  // User related methods with Hive
  Future<void> saveUser(UserModel user) async {
    await userBox.put('currentUser', user);
    await setBool(isLoggedInKey, true);
  }

  UserModel? getUser() {
    return userBox.get('currentUser');
  }

  Future<void> deleteUser() async {
    await userBox.delete('currentUser');
    await setBool(isLoggedInKey, false);
  }

  // Existing SharedPreferences methods
  Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefsConstants.languageKey);
  }

  Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefsConstants.languageKey, languageCode);
  }

  Future<bool?> getBool(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(key);
  }

  Future<void> setBool(String key, bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key, value);
  }

  // Helper method to check login status
  Future<bool> get isLoggedIn async => await getBool(isLoggedInKey) ?? false;
}
