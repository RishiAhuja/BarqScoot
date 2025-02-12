import 'package:escooter/common/router/app_router.dart';
import 'package:escooter/core/configs/constants/app_localization_constants.dart';
import 'package:escooter/core/configs/theme/app_colors.dart';
import 'package:escooter/core/locale/providers/data/locale_data.dart';
import 'package:escooter/features/profile/presentation/provider/user_provider.dart';
import 'package:escooter/features/theme/presentation/providers/theme_provider.dart';
import 'package:escooter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translations = ref.watch(appLocalizationsProvider);
    final isDark = ref.watch(themeProvider).isDark;
    final currentLocale = ref.watch(localeProvider);
    final theme = Theme.of(context);
    final brightness = Theme.of(context).brightness;
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: brightness == ThemeData.dark().brightness
          ? Colors.grey[900] ?? Colors.black
          : AppColors.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        title: Text(
          translations.translate(AppLocalizationConstants.settings),
          style: theme.textTheme.displaySmall,
        ),
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          // Profile Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  user != null
                      ? '${user.firstName} ${user.lastName}'
                      : 'Guest User',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  user?.phoneNumber ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Settings Sections
          _buildSettingsSection(
            context,
            translations.translate(AppLocalizationConstants.appearance),
            [
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: Text(
                    translations.translate(AppLocalizationConstants.darkMode)),
                trailing: Switch.adaptive(
                  value: isDark,
                  onChanged: (_) {
                    ref.read(themeProvider.notifier).toggleTheme();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingsSection(
            context,
            translations.translate(AppLocalizationConstants.langAndRegion),
            [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(
                    translations.translate(AppLocalizationConstants.language)),
                subtitle: Text(
                  currentLocale.languageCode == AppLocalizationConstants.en
                      ? 'English'
                      : translations.translate(AppLocalizationConstants.arabic),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ref.read(localeProvider.notifier).setLocale(
                        currentLocale.languageCode ==
                                AppLocalizationConstants.en
                            ? AppLocalizationConstants.ar
                            : AppLocalizationConstants.en,
                      );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingsSection(
            context,
            translations.translate(AppLocalizationConstants.notifications),
            [
              SwitchListTile.adaptive(
                secondary: const Icon(Icons.notifications),
                title: Text(translations
                    .translate(AppLocalizationConstants.pushNotifications)),
                value: true,
                onChanged: (value) {
                  // Handle push notifications toggle
                },
              ),
              SwitchListTile.adaptive(
                secondary: const Icon(Icons.email),
                title: Text(translations
                    .translate(AppLocalizationConstants.emailNotifications)),
                value: false,
                onChanged: (value) {
                  // Handle email notifications toggle
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingsSection(
            context,
            translations.translate(AppLocalizationConstants.about),
            [
              ListTile(
                leading: const Icon(Icons.info),
                title: Text(translations
                    .translate(AppLocalizationConstants.appVersion)),
                trailing: const Text('1.0.0'),
              ),
              ListTile(
                leading: const Icon(Icons.policy),
                title: Text(translations
                    .translate(AppLocalizationConstants.privacyPolicy)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to privacy policy
                },
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: Text(translations
                    .translate(AppLocalizationConstants.termsOfService)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to terms of service
                },
              ),
            ],
          ),
          // Add Logout button
          const SizedBox(height: 16),
          _buildSettingsSection(
            context,
            translations.translate(AppLocalizationConstants.account),
            [
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: Text(
                  translations.translate(AppLocalizationConstants.logout),
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () => context.logout(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }
}
