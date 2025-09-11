import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/models/notifications/notification_model.dart';
import 'package:infoklub/services/local_storage_services/hive_helpers.dart';
import 'package:infoklub/services/firebase_services/splash_services.dart'; // for userMail

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late String boxName;

  @override
  void initState() {
    super.initState();
    boxName = HiveHelper.getNotificationBoxName(userMail);
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    await HiveHelper.openNotificationBox(userMail);
    setState(() {}); // trigger rebuild once box is ready
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Notifications',
            style: TextStyle(color: AppTheme.primaryColor, fontSize: 20.0)),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<NotificationModel>(boxName).listenable(),
        builder: (context, Box<NotificationModel> box, _) {
          if (box.isEmpty) {
            return const Center(
                child: Text(
              "No notifications yet ",
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ));
          }
          return ListView.separated(
            itemCount: box.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final notif = box.getAt(index);
              if (notif == null) return const SizedBox();
              return ListTile(
                leading: const Icon(Icons.notifications,
                    color: AppTheme.primaryColor),
                title: Text(
                  notif.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(notif.message),
                trailing: Text(
                  notif.time.toLocal().toString().substring(0, 16),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
