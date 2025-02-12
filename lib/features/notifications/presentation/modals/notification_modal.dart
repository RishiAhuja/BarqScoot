import 'package:escooter/core/configs/theme/app_colors.dart';
import 'package:escooter/features/notifications/data/models/notifications_model.dart';
import 'package:escooter/features/notifications/presentation/widgets/notification_card.dart';
import 'package:escooter/features/notifications/presentation/widgets/notification_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationModal extends ConsumerWidget {
  const NotificationModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Mark all as read
                  },
                  child: Text('Mark all as read',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: AppColors.primaryTeal)),
                ),
              ],
            ),
          ),

          const NotificationFilter(),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                // Sample data - replace with actual data from your state management
                final isRead = index > 3;
                final timestamp =
                    DateTime.now().subtract(Duration(hours: index * 2));
                final type = NotificationType.values[index % 3];

                return NotificationCard(
                  type: type,
                  timestamp: timestamp,
                  isRead: isRead,
                  title: _getNotificationTitle(type),
                  description: _getNotificationDescription(type),
                  onTap: () {
                    // Handle notification tap
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

String _getNotificationTitle(NotificationType type) {
  switch (type) {
    case NotificationType.ride:
      return 'Ride Completed';
    case NotificationType.payment:
      return 'Payment Successful';
    case NotificationType.promotion:
      return 'Special Offer!';
  }
}

String _getNotificationDescription(NotificationType type) {
  switch (type) {
    case NotificationType.ride:
      return 'Your ride from Main St. to Park Ave has been completed.';
    case NotificationType.payment:
      return 'Payment of €10.50 has been processed successfully.';
    case NotificationType.promotion:
      return 'Get 20% off on your next ride! Valid for 24 hours.';
  }
}
