import 'package:escooter/common/router/app_router.dart';
import 'package:escooter/core/configs/services/storage/storage_service.dart';
import 'package:escooter/core/configs/theme/app_theme.dart';
import 'package:escooter/core/di/service_locator/service_locator.dart';
import 'package:escooter/core/locale/providers/data/locale_data.dart';
import 'package:escooter/features/theme/presentation/providers/theme_provider.dart';
import 'package:escooter/l10n/app_localizations.dart';
import 'package:escooter/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    AppLogger.log('====================================');
    await configureDependencies();
    final storageService = getIt<StorageService>();
    await storageService.initHive();
    await AppRouter.authNotifier.initializeAuth();

    final user = storageService.getUser();
    if (user != null) {
      AppLogger.log('User Token: ${user.token}');
    } else {
      AppLogger.log('No user token found');
    }
    AppLogger.log('Dependencies configured successfully');
    AppLogger.log('====================================');
  } catch (e) {
    AppLogger.error('Failed to configure dependencies: $e');
  }
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeState = ref.watch(themeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'E Scooter',
      theme: themeState.isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
      builder: (context, child) {
        return Directionality(
          textDirection: locale.languageCode == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: child!,
        );
      },
    );
  }
}
