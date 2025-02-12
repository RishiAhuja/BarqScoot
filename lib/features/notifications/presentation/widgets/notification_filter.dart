import 'package:flutter/material.dart';

class NotificationFilter extends StatelessWidget {
  const NotificationFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          FilterChip(
            backgroundColor: Colors.white,
            selected: true,
            label: Text('All', style: theme.textTheme.bodyMedium),
            onSelected: (value) {
              // TODO: Filter notifications
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            backgroundColor: Colors.white,
            selected: false,
            label: Text('Rides', style: theme.textTheme.bodyMedium),
            avatar: const Icon(Icons.electric_scooter, size: 16),
            onSelected: (value) {
              // TODO: Filter notifications
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            backgroundColor: Colors.white,
            selected: false,
            label: Text('Payments', style: theme.textTheme.bodyMedium),
            avatar: const Icon(Icons.payment, size: 16),
            onSelected: (value) {
              // TODO: Filter notifications
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            backgroundColor: Colors.white,
            selected: false,
            label: Text('Promotions', style: theme.textTheme.bodyMedium),
            avatar: const Icon(Icons.local_offer, size: 16),
            onSelected: (value) {
              // TODO: Filter notifications
            },
          ),
        ],
      ),
    );
  }
}
