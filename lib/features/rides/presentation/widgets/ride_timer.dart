import 'package:flutter/material.dart';

class RideTimer extends StatelessWidget {
  const RideTimer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          '00:15:30',
          style: theme.textTheme.displayLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Current Cost: €2.50',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}
