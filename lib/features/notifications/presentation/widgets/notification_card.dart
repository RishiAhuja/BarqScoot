import 'package:escooter/core/configs/theme/app_colors.dart';
import 'package:escooter/features/notifications/data/models/notifications_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatelessWidget {
  final NotificationType type;
  final String title;
  final String description;
  final DateTime timestamp;
  final bool isRead;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    this.type = NotificationType.ride,
    this.title = 'Ride Completed',
    this.description =
        'Your ride from Main St. to Park Ave has been completed.',
    required this.timestamp,
    this.isRead = false,
    this.onTap,
  });

  Icon _getIcon() {
    switch (type) {
      case NotificationType.ride:
        return const Icon(Icons.electric_scooter, color: Colors.blue);
      case NotificationType.payment:
        return const Icon(Icons.payment, color: Colors.green);
      case NotificationType.promotion:
        return const Icon(Icons.local_offer, color: Colors.orange);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor.withOpacity(0.1),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _getIcon(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: isRead ? FontWeight.normal : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTimestamp(timestamp),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            if (!isRead)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, y').format(timestamp);
    }
  }
}
