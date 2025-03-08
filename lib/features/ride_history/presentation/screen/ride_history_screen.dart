import 'package:escooter/features/ride_history/presentation/widgets/error_view.dart';
import 'package:escooter/features/ride_history/presentation/widgets/ride_history_card.dart';
import 'package:escooter/features/rides/presentation/providers/ride_provider.dart';
import 'package:escooter/features/theme/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escooter/features/ride_history/presentation/widgets/stats_card.dart';

class RideHistoryScreen extends ConsumerWidget {
  const RideHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDark;
    final theme = Theme.of(context);
    final ridesAsync = ref.watch(ridesProvider);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Ride History',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list_rounded,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ridesAsync.when(
              data: (rides) {
                final completedRides =
                    rides.where((r) => r.status == 'completed').toList();
                final totalTime = completedRides.fold<Duration>(
                  Duration.zero,
                  (prev, ride) =>
                      prev +
                      (ride.endTime?.difference(ride.startTime) ??
                          Duration.zero),
                );

                return StatsCard(
                  totalRides: completedRides.length,
                  totalTime: totalTime,
                  isDarkMode: isDarkMode,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => ErrorView(
                message: error.toString(),
                onRetry: () => ref.refresh(ridesProvider),
              ),
            ),
          ),
          ridesAsync.when(
            data: (rides) {
              final completedRides =
                  rides.where((r) => r.status == 'completed').toList();
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final ride = completedRides[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: RideHistoryCard(
                        date: ride.startTime,
                        startLocation: ride.startLocation,
                        endLocation: ride.endLocation ?? 'Unknown',
                        duration: ride.endTime?.difference(ride.startTime) ??
                            Duration.zero,
                        cost: ride.totalPrice ?? 0,
                        onTap: () {},
                        isDarkMode: isDarkMode,
                      ),
                    );
                  },
                  childCount: completedRides.length,
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => SliverToBoxAdapter(
              child: ErrorView(
                message: error.toString(),
                onRetry: () => ref.refresh(ridesProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
