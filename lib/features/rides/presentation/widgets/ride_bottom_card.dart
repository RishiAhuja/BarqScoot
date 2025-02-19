import 'package:escooter/core/configs/constants/app_localization_constants.dart';
import 'package:escooter/features/rides/presentation/providers/ride_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escooter/features/home/domain/entity/scooter/scooter.dart';
import 'package:escooter/utils/logger.dart';
import 'package:go_router/go_router.dart';
import 'package:escooter/l10n/app_localizations.dart';

class RideBottomCard extends ConsumerStatefulWidget {
  final Scooter scooter;
  final String rideId;
  final bool isDarkMode;

  const RideBottomCard({
    super.key,
    required this.scooter,
    required this.rideId,
    required this.isDarkMode,
  });

  @override
  ConsumerState<RideBottomCard> createState() => _RideBottomCardState();
}

class _RideBottomCardState extends ConsumerState<RideBottomCard> {
  bool _isLoading = false;

  Future<void> _handleEndRide() async {
    if (_isLoading) return;

    try {
      setState(() {
        _isLoading = true;
      });

      await ref
          .read(ridesProvider.notifier)
          .endRide(widget.rideId, widget.scooter.id);

      await ref.read(ridesProvider.notifier).refresh();
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      AppLogger.error('Failed to end ride in UI', error: e);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to end ride: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final translations = ref.watch(appLocalizationsProvider);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: widget.isDarkMode ? Colors.grey[850] : Colors.white,
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
                    widget.scooter.name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: widget.isDarkMode ? Colors.white : Colors.black87,
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
                        '${widget.scooter.batteryLevel}%',
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
                  label: widget.scooter.lastStation,
                  theme: theme,
                ),
                const SizedBox(width: 12),
                _buildInfoChip(
                  icon: Icons.info_outline,
                  label: widget.scooter.status,
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isLoading ? null : _handleEndRide,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  disabledBackgroundColor: Colors.red.withOpacity(0.6),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        translations
                            .translate(AppLocalizationConstants.endRide),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
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
        color: widget.isDarkMode ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: widget.isDarkMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
