import 'package:escooter/core/configs/constants/app_localization_constants.dart';
import 'package:escooter/features/rides/presentation/providers/ride_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escooter/features/home/domain/entity/scooter/scooter.dart';
import 'package:escooter/utils/logger.dart';
import 'package:go_router/go_router.dart';
import 'package:escooter/l10n/app_localizations.dart';

class RideBottomCard extends ConsumerWidget {
  final Scooter scooter;
  final String rideId;
  final bool isDarkMode;

  const RideBottomCard({
    super.key,
    required this.scooter,
    required this.rideId,
    required this.isDarkMode,
  });

  Future<void> _handleEndRide(BuildContext context, WidgetRef ref) async {
    final translations = ref.watch(appLocalizationsProvider);

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                translations.translate(AppLocalizationConstants.endRide),
                style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87),
              ),
            ],
          ),
        ),
      );

      // End the ride using provider
      await ref.read(ridesProvider.notifier).endRide(rideId, scooter.id);

      if (context.mounted) {
        // Close loading dialog
        Navigator.pop(context);

        // Show success dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text(
                translations.translate(AppLocalizationConstants.rideEnded)),
            content: Text(translations
                .translate(AppLocalizationConstants.rideEndedSuccessfully)),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop(); // Close dialog
                  context.go('/home'); // Navigate to home
                },
                child:
                    Text(translations.translate(AppLocalizationConstants.ok)),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      AppLogger.error('Failed to end ride in UI', error: e);

      if (context.mounted) {
        // Close loading dialog if open
        Navigator.maybeOf(context)?.pop();

        // Show error dialog
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(translations.translate(AppLocalizationConstants.error)),
            content: Text(
              '${translations.translate(AppLocalizationConstants.failedToEndRide)}: ${e.toString()}',
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child:
                    Text(translations.translate(AppLocalizationConstants.ok)),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final translations = ref.watch(appLocalizationsProvider);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.electric_scooter,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    scooter.name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.battery_charging_full,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${scooter.batteryLevel}%',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoChip(
                  icon: Icons.location_on,
                  label: scooter.lastStation,
                  theme: theme,
                ),
                const SizedBox(width: 12),
                _buildInfoChip(
                  icon: Icons.info_outline,
                  label: scooter.status,
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _handleEndRide(context, ref),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  translations.translate(AppLocalizationConstants.endRide),
                  style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
