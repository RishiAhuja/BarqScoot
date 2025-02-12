import 'package:escooter/features/home/presentation/widgets/map_view.dart';
import 'package:escooter/features/rides/presentation/widgets/ride_controls.dart';
import 'package:escooter/features/rides/presentation/widgets/ride_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ActiveRideScreen extends ConsumerWidget {
  const ActiveRideScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        title: const Text('Active Ride'),
        actions: [
          IconButton(
            icon: const Icon(Icons.emergency),
            onPressed: () {
              // TODO: Implement emergency contact
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Timer and Cost Section
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.primary,
            child: const RideTimer(),
          ),

          // Map Section
          Expanded(
            child: Stack(
              children: [
                // Map Widget
                const Positioned.fill(
                  child: MapView(),
                ),

                // Stats Overlay
                // Positioned(
                //   top: 16,
                //   right: 16,
                //   child: RideStats(),
                // ),
              ],
            ),
          ),

          // Controls Section
          const RideControls(),
        ],
      ),
    );
  }
}
