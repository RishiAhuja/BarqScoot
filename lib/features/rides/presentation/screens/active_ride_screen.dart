import 'package:escooter/features/ride_history/presentation/widgets/error_view.dart';
import 'package:escooter/features/rides/data/model/ride_model.dart';
import 'package:escooter/features/rides/presentation/providers/ride_provider.dart';
import 'package:escooter/features/rides/presentation/widgets/ride_bottom_card.dart';
import 'package:escooter/features/rides/presentation/widgets/ride_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/active_ride_map.dart';

class ActiveRideScreen extends ConsumerWidget {
  const ActiveRideScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ridesAsync = ref.watch(ridesProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go('/home'),
        ),
        title: Text('Active Ride', style: theme.textTheme.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.emergency),
            onPressed: () {},
          ),
        ],
      ),
      body: ridesAsync.when(
        data: (rides) {
          final activeRide =
              rides.where((ride) => ride.status == 'ongoing').firstOrNull;
          return activeRide != null
              ? ActiveRideView(ride: activeRide)
              : const NoActiveRideView();
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.refresh(ridesProvider),
        ),
      ),
    );
  }
}

class NoActiveRideView extends StatelessWidget {
  const NoActiveRideView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.electric_scooter_outlined,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Active Rides',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Scan a scooter QR code to start riding',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.push('/scanner'),
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('Scan QR Code'),
          ),
        ],
      ),
    );
  }
}

class ActiveRideView extends ConsumerStatefulWidget {
  final Ride ride;

  const ActiveRideView({
    super.key,
    required this.ride,
  });

  @override
  ConsumerState<ActiveRideView> createState() => _ActiveRideViewState();
}

class _ActiveRideViewState extends ConsumerState<ActiveRideView> {
  @override
  void dispose() {
    // Clean up any map resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: theme.colorScheme.primary,
          child: RideTimer(
            startTime: widget.ride.startTime,
            distanceCovered: widget.ride.distanceCovered,
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              if (widget.ride.status == 'ongoing' &&
                  widget.ride.scooter != null)
                Positioned.fill(
                  child: ActiveRideMap(
                    scooterId: widget.ride.scooter!.id,
                  ),
                ),
              if (widget.ride.scooter != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: RideBottomCard(
                    scooter: widget.ride.scooter!,
                    rideId: widget.ride.id,
                    isDarkMode: isDarkMode,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
