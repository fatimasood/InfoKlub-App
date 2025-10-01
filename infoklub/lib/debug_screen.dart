// views/debug/notification_debug.dart
import 'package:flutter/material.dart';
import 'package:infoklub/services/notifications_service/notifications_services.dart';

class NotificationDebugScreen extends StatelessWidget {
  const NotificationDebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Debug')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await NotificationService().showTestNotification();
              },
              child: const Text('Show Test Notification'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await NotificationService().printPendingNotifications();
              },
              child: const Text('Print Pending Notifications'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await NotificationService().cancelAllNotifications();
              },
              child: const Text('Cancel All Notifications'),
            ),
          ],
        ),
      ),
    );
  }
}
