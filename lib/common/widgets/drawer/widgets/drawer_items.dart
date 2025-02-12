import 'package:escooter/common/router/app_router.dart';
import 'package:escooter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escooter/core/configs/constants/app_localization_constants.dart';

class AppDrawerItems extends ConsumerWidget {
  const AppDrawerItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translations = ref.watch(appLocalizationsProvider);

    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        ListTile(
          leading: const Icon(Icons.help),
          title: Text(
            translations.translate(AppLocalizationConstants.helpAndSupport),
          ),
          onTap: () {
            // TODO: Implement help & support
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(
            translations.translate(AppLocalizationConstants.settings),
          ),
          onTap: () {
            Navigator.pop(context);
            context.push(AppPaths.profile);
          },
        ),
      ],
    );
  }
}
