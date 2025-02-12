import 'package:escooter/core/configs/services/storage/storage_service.dart';
import 'package:escooter/utils/logger.dart';
import 'package:flutter/material.dart';

class AuthNotifier extends ChangeNotifier {
  final StorageService _storageService;
  bool _isAuthenticated = false;

  AuthNotifier(this._storageService);

  bool get isAuthenticated => _isAuthenticated;

  Future<void> initializeAuth() async {
    _isAuthenticated = await _storageService.getBool('isLoggedIn') ?? false;
    AppLogger.log('Auth State Initialized: $_isAuthenticated');
    notifyListeners();
  }

  void setAuthenticated(bool value) {
    _isAuthenticated = value;
    _storageService.setBool('isLoggedIn', value);
    notifyListeners();
  }
}

class AuthenticatedShell extends StatelessWidget {
  final Widget child;

  const AuthenticatedShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }
}
