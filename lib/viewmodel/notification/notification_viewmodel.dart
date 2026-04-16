import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// ENUMS & MODELS
// ─────────────────────────────────────────────

enum NotificationType {
  task,
  message,
  target,
  reminder,
  alert,
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final NotificationType type;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });
}

// ─────────────────────────────────────────────
// NOTIFICATION VIEW MODEL
// ─────────────────────────────────────────────

class NotificationViewModel extends ChangeNotifier {
  List<AppNotification> _items = [];
  List<AppNotification> get items => _items;

  NotificationViewModel() {
    _loadMockNotifications();
  }

  void markAsRead(String id) {
    final idx = _items.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _items[idx].isRead = true;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var n in _items) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void _loadMockNotifications() {
    _items = [
      AppNotification(
        id: '1',
        title: 'New Task Assigned',
        body: 'Visit Balaji Supermarket and collect pending order of ₹15,000.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        type: NotificationType.task,
      ),
      AppNotification(
        id: '2',
        title: 'Manager Message',
        body: 'Please ensure all store coordinates are captured accurately today.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.message,
      ),
      AppNotification(
        id: '3',
        title: 'Monthly Target Update',
        body: 'You are at 85% of your sales target. Keep it up!',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        type: NotificationType.target,
        isRead: true,
      ),
      AppNotification(
        id: '4',
        title: 'Follow-up Alert',
        body: 'Follow-up visit with "Green Grocery" is scheduled for tomorrow.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.alert,
      ),
      AppNotification(
        id: '5',
        title: 'System Reminder',
        body: 'Don\'t forget to upload your visit proofs before the end of the day.',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        type: NotificationType.reminder,
        isRead: true,
      ),
    ];
    notifyListeners();
  }
}
