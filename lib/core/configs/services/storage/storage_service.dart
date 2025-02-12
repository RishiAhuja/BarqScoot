import 'package:escooter/core/configs/constants/shared_prefs_constants.dart';
import 'package:escooter/features/home/data/model/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';

@singleton
class StorageService {
  static const String userBoxName = 'userBox';
  static const String isLoggedInKey = 'isLoggedIn';

  late Box<UserModel> _userBox;

  // Initialize Hive
  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    _userBox = await Hive.openBox<UserModel>(userBoxName);
  }

  // User related methods with Hive
  Future<void> saveUser(UserModel user) async {
    await _userBox.put('currentUser', user);
    await setBool(isLoggedInKey, true);
  }

  UserModel? getUser() {
    return _userBox.get('currentUser');
  }

  Future<void> deleteUser() async {
    await _userBox.delete('currentUser');
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
