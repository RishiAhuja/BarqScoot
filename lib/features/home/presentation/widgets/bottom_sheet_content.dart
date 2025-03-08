import 'package:escooter/common/router/app_router.dart';
import 'package:escooter/core/configs/theme/app_colors.dart';
import 'package:escooter/features/home/domain/entity/scooter/scooter.dart';
import 'package:escooter/features/home/presentation/provider/scooter_provider.dart';
import 'package:escooter/features/rides/presentation/providers/ride_provider.dart';
import 'package:escooter/features/theme/presentation/providers/theme_provider.dart';
import 'package:escooter/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:escooter/features/wallet/presentation/providers/balance_provider.dart';
import 'package:go_router/go_router.dart';

import '../provider/location_provider.dart';

class BottomSheetContent extends ConsumerWidget {
  const BottomSheetContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scootersAsync = ref.watch(scootersNotifierProvider);
    final isDarkMode = ref.watch(themeProvider).isDark;
    final locationAsync = ref.watch(userLocationProvider);
    final balanceAsync = ref.watch(balanceProvider);
    final ridesAsync = ref.watch(ridesProvider);

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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                    title: 'Total Rides',
                    value: ridesAsync.when(
                      data: (rides) {
                        final completedRides = rides
                            .where((r) => r.status == 'completed')
                            .toList();
                        return '${completedRides.length}';
                      },
                      loading: () => '-',
                      error: (_, __) => '-',
                    ),
                    icon: Icons.history,
                    isDark: isDarkMode,
                    onTap: () => context.push(AppPaths.rideHistory),
                  ),
                  _StatItem(
                    title: 'Balance',
                    value: balanceAsync.when(
                      data: (balance) => '﷼${balance.toStringAsFixed(2)}',
                      loading: () => '-',
                      error: (_, __) => '-',
                    ),
                    icon: Icons.account_balance_wallet,
                    isDark: isDarkMode,
                    onTap: () => context.push(AppPaths.wallet),
                  ),
                  _StatItem(
                    title: 'Total Cost',
                    value: ridesAsync.when(
                      data: (rides) {
                        final completedRides =
                            rides.where((r) => r.status == 'completed');
                        final totalCost = completedRides.fold<double>(
                          0,
                          (sum, ride) => sum + (ride.totalPrice ?? 0),
                        );
                        return '﷼${totalCost.toStringAsFixed(2)}';
                      },
                      loading: () => '-',
                      error: (_, __) => '-',
                    ),
                    icon: Icons.payments_outlined,
                    isDark: isDarkMode,
                    onTap: () => context.push(AppPaths.rideHistory),
                  ),
                ],
              ),
            ),
            scootersAsync.when(
              data: (scooters) {
                return locationAsync.when(
                  data: (position) {
                    final availableScooters =
                        scooters.where((s) => s.status == 'available').toList();

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
                    for (final scooter in sortedScooters) {
                      AppLogger.log(
                          'Available scooter: ${scooter.id} : ${scooter.name} : ${scooter.status}');
                    }

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
              loading: () => Center(child: const CircularProgressIndicator()),
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
  final VoidCallback? onTap;

  const _StatItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.27, // Set fixed width
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isDark ? Colors.white : Colors.black,
              size: 24, // Specify icon size
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
