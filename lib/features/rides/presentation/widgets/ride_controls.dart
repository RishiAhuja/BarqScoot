import 'package:flutter/material.dart';

class RideControls extends StatelessWidget {
  const RideControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.pause),
            label: const Text('Pause'),
            onPressed: () {
              // TODO: Implement pause
            },
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.stop),
            label: const Text('End Ride'),
            onPressed: () {
              // TODO: Implement end ride
            },
          ),
          IconButton(
            icon: const Icon(Icons.report_problem),
            onPressed: () {
              // TODO: Implement report issue
            },
          ),
        ],
      ),
    );
  }
}
