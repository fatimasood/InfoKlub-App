import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidInit);

    await _notificationsPlugin.initialize(settings);
  }

  /// Single Notification
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminder Notifications',
      channelDescription: 'Notifications for reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      // scheduleMode: ScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Multiple Days Notification
  static Future<void> scheduleForMultipleDays({
    required String title,
    required String body,
    required List<int> days, // 1=Mon, 2=Tue, ... 7=Sun
    required DateTime time, // sirf HH:mm lena hai yaha
  }) async {
    int baseId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    for (var i = 0; i < days.length; i++) {
      int id = baseId + i;

      final now = DateTime.now();
      // pehla occurrence find karna selected weekday ka
      DateTime scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      // agar aaj ka din match nahi karta selected day se, to agla din le lo
      while (scheduledDate.weekday != days[i]) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await scheduleNotification(
        id: id,
        title: title,
        body: body,
        scheduledTime: scheduledDate,
      );
    }
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'goal_channel',
      'Goal Notifications',
      channelDescription: 'Notifications about your goals',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(id, title, body, platformDetails);
  }
}
