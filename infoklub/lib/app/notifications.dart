import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/models/notifications/notification_model.dart';
import 'package:infoklub/services/firebase_services/splash_services.dart';
import 'package:infoklub/services/local_storage_services/hive_helpers.dart';
import 'package:infoklub/services/notifications_service/notifications_services.dart';

class NotificationScreen extends StatefulWidget {
  final String userEmail = userMail;

  NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cleanupAndLoadNotifications();

    _setupNotificationListener();
  }

  Future<void> _cleanupAndLoadNotifications() async {
    try {
      // Clean up duplicates first
      await HiveHelper.cleanupDuplicateNotifications(widget.userEmail);
      await _loadNotifications();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadNotifications() async {
    try {
      final notifications =
          await HiveHelper.getAllNotifications(widget.userEmail);
      setState(() {
        _notifications = notifications.reversed.toList(); // Show latest first
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _setupNotificationListener() {
    NotificationService().notificationStream.listen((response) {
      // Refresh notifications when a new one is received
      _loadNotifications();
    });
  }

  Future<void> _deleteNotification(int index) async {
    try {
      await HiveHelper.deleteNotification(widget.userEmail, index);
      await _loadNotifications(); // Reload the list

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting notification')),
      );
    }
  }

  Future<void> _clearAllNotifications() async {
    try {
      await HiveHelper.clearAllNotifications(widget.userEmail);
      await _loadNotifications();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All notifications cleared')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error clearing notifications')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.halfwhite,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppTheme.secondaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (_notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _clearAllNotifications,
              tooltip: 'Clear All',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? const _EmptyNotificationsState()
              : _NotificationsList(
                  notifications: _notifications,
                  onDelete: _deleteNotification,
                ),
    );
  }
}

class _NotificationsList extends StatelessWidget {
  final List<NotificationModel> notifications;
  final Function(int) onDelete;

  const _NotificationsList({
    required this.notifications,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _NotificationItem(
          notification: notification,
          index: index,
          onDelete: onDelete,
        );
      },
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final int index;
  final Function(int) onDelete;

  const _NotificationItem({
    required this.notification,
    required this.index,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppTheme.secondaryColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.notifications,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          notification.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.message,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              _formatTime(notification.time),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => onDelete(index),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}

class _EmptyNotificationsState extends StatelessWidget {
  const _EmptyNotificationsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'You\'ll see your goal and reminder notifications here when they trigger.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
