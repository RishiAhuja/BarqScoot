import 'package:escooter/core/configs/theme/app_colors.dart';
import 'package:escooter/features/home/domain/entity/scooter/scooter.dart';
import 'package:escooter/features/home/presentation/provider/scooter_provider.dart';
import 'package:escooter/features/theme/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../provider/user_stats_provider.dart';
import '../provider/location_provider.dart';

class BottomSheetContent extends ConsumerWidget {
  const BottomSheetContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(userStatsNotifierProvider);
    final scootersAsync = ref.watch(scootersNotifierProvider);
    final isDarkMode = ref.watch(themeProvider).isDark;
    final theme = Theme.of(context);
    final locationAsync = ref.watch(userLocationProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : AppColors.backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          controller: scrollController,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            statsAsync.when(
              data: (stats) => Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      title: 'Total Rides',
                      value: '${stats.totalRides}',
                      icon: Icons.history,
                      isDark: isDarkMode,
                    ),
                    _StatItem(
                      title: 'Balance',
                      value: '﷼${stats.walletBalance}',
                      icon: Icons.account_balance_wallet,
                      isDark: isDarkMode,
                    ),
                  ],
                ),
              ),
              loading: () => Center(
                child: CircularProgressIndicator(
                  color: isDarkMode ? Colors.white : theme.primaryColor,
                ),
              ),
              error: (_, __) => Text(
                'Error loading stats',
                style: TextStyle(
                  color: isDarkMode ? Colors.red[300] : Colors.red,
                ),
              ),
            ),
            // Nearby scooters list
            scootersAsync.when(
              data: (scooters) {
                return locationAsync.when(
                  data: (position) {
                    // Filter available scooters first
                    final availableScooters =
                        scooters.where((s) => s.status == 'available').toList();

                    // Sort filtered scooters by distance
                    final sortedScooters = List<Scooter>.from(availableScooters)
                      ..sort((a, b) {
                        final distanceA = Geolocator.distanceBetween(
                          position.latitude,
                          position.longitude,
                          a.latitude,
                          a.longitude,
                        );
                        final distanceB = Geolocator.distanceBetween(
                          position.latitude,
                          position.longitude,
                          b.latitude,
                          b.longitude,
                        );
                        return distanceA.compareTo(distanceB);
                      });

                    // Log available scooter IDs
                    // for (final scooter in sortedScooters) {
                    //   AppLogger.log(
                    //       'Available scooter: ${scooter.id} : ${scooter.name} : ${scooter.status}');
                    // }

                    if (sortedScooters.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'No available scooters nearby',
                            style: TextStyle(
                              color:
                                  isDarkMode ? Colors.white70 : Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sortedScooters.length,
                      itemBuilder: (context, index) => ListTile(
                        onTap: () {},
                        leading: Icon(
                          Icons.electric_scooter,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                        title: Text(
                          sortedScooters[index].name,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          '${_calculateDistance(position, sortedScooters[index])}km away',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.battery_charging_full,
                              color: _getBatteryColor(
                                  sortedScooters[index].batteryLevel),
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${sortedScooters[index].batteryLevel}%',
                              style: TextStyle(
                                color:
                                    isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Text('Unable to get location'),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Error loading scooters'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBatteryColor(int level) {
    if (level > 70) return Colors.green;
    if (level > 30) return Colors.orange;
    return Colors.red;
  }

  String _calculateDistance(Position? userPosition, Scooter scooter) {
    if (userPosition == null) return 'N/A';

    final distanceInMeters = Geolocator.distanceBetween(
      userPosition.latitude,
      userPosition.longitude,
      scooter.latitude,
      scooter.longitude,
    );

    return (distanceInMeters / 1000).toStringAsFixed(1);
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool isDark;

  const _StatItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: isDark ? Colors.white : Colors.black),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.headlineSmall),
        Text(title, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
