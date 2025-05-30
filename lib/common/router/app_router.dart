import 'package:escooter/core/configs/services/storage/storage_service.dart';
import 'package:escooter/core/di/service_locator/service_locator.dart';
import 'package:escooter/features/auth/presentation/providers/auth_shell_check.dart';
// import 'package:escooter/main.dart';
import 'package:escooter/features/auth/presentation/screens/auth_screen.dart';
import 'package:escooter/features/auth/presentation/screens/login_otp_verification_screen.dart';
import 'package:escooter/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:escooter/features/home/presentation/screens/home_screen.dart';
// import 'package:escooter/presentation/auth/signup.dart';
import 'package:escooter/features/onboarding/presentation/welcome_screen.dart';
import 'package:escooter/features/profile/presentation/screens/profile_screen.dart';
import 'package:escooter/features/ride_history/presentation/screen/ride_history_screen.dart';
import 'package:escooter/features/rides/data/model/ride_model.dart';
import 'package:escooter/features/rides/presentation/screens/active_ride_screen.dart';
import 'package:escooter/features/payment/presentation/screen/ride_payment_screen.dart';
import 'package:escooter/features/scanner/presentation/screens/qr_scanner.dart';
import 'package:escooter/features/wallet/presentation/screens/wallet_screen.dart';
import 'package:escooter/main.dart';
import 'package:escooter/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppPaths {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String authOtp = 'otp';
  static const String profileSetup = '/auth/profile-setup';
  static const String home = '/home';
  static const String scanner = '/scanner';

  static const String activeRide = '/active-ride';
  static const String rideHistory = '/ride-history';
  static const String wallet = '/wallet';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String ridePayment = '/ride-payment';
}

class AppRouter {
  static final authNotifier = AuthNotifier(getIt<StorageService>());

  static final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppPaths.splash,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isLoggedIn = authNotifier.isAuthenticated;
      final isSplashRoute = state.matchedLocation == AppPaths.splash;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      // Initial app load
      if (isSplashRoute) {
        return isLoggedIn ? AppPaths.home : AppPaths.auth;
      }

      // Auth flow protection
      if (isLoggedIn && isAuthRoute) return AppPaths.home;
      if (!isLoggedIn && !isAuthRoute) return AppPaths.auth;

      return null;
    },
    routes: [
      GoRoute(
        path: AppPaths.splash,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppPaths.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppPaths.scanner,
        builder: (context, state) => const QRScannerScreen(),
      ),
      GoRoute(
        path: AppPaths.auth,
        builder: (context, state) => const AuthScreen(),
        routes: [
          GoRoute(
            path: 'otp',
            builder: (context, state) {
              final params = state.extra;
              AppLogger.log(
                  'OTP Route Params: ${params?.runtimeType}, value: $params');

              // Add null check
              if (params == null) {
                // Handle the case when no params are provided
                return const Scaffold(
                  body: Center(
                    child: Text('Missing verification parameters'),
                  ),
                );
              }

              // Then cast and continue...
              try {
                final paramsMap = params as Map<String, dynamic>;
                final phoneNumber = paramsMap['phoneNumber']?.toString() ?? '';
                final verificationId = paramsMap['verificationId']?.toString();

                if (phoneNumber.isEmpty) {
                  return const Scaffold(
                    body: Center(
                      child: Text('Invalid verification parameters'),
                    ),
                  );
                }

                return OtpVerificationScreen(
                  phoneNumber: phoneNumber,
                  verificationId: verificationId!,
                );
              } catch (e) {
                AppLogger.error('Error parsing OTP route parameters: $e');
                return Scaffold(
                  body: Center(
                    child: Text('Error: $e'),
                  ),
                );
              }
            },
          ),
          GoRoute(
            path: 'login-otp',
            builder: (context, state) {
              final params = state.extra as Map<String, dynamic>;
              return LoginOtpVerificationScreen(
                phoneNumber: params['phoneNumber'].toString(),
                verificationId: params['verificationId'].toString(),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: AppPaths.activeRide,
        builder: (context, state) => const ActiveRideScreen(),
      ),
      GoRoute(
        path: AppPaths.rideHistory,
        builder: (context, state) => const RideHistoryScreen(),
      ),
      GoRoute(
        path: AppPaths.wallet,
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: AppPaths.profile,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/ride-payment',
        builder: (context, state) {
          AppLogger.log('Building RidePaymentScreen');
          final ride = state.extra as Ride;
          return RidePaymentScreen(ride: ride);
        },
      ),
    ],
  );

  // Make authNotifier accessible
  static AuthNotifier get getAuthNotifier => authNotifier;
}

extension RouterExtension on BuildContext {
  void authenticateAndRedirect() {
    AppRouter.authNotifier.setAuthenticated(true);
    go(AppPaths.home);
  }

  void logout() {
    AppRouter.authNotifier.setAuthenticated(false);
    go(AppPaths.auth);
  }
}
