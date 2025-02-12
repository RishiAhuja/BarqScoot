class NotificationItem {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });
}

enum NotificationType { ride, payment, promotion }
