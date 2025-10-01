import 'dart:async';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:infoklub/models/goals/goal_model.dart';
import 'package:infoklub/models/reminder/reminder_model.dart';
import 'package:infoklub/services/local_storage_services/hive_helpers.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  final StreamController<NotificationResponse> _notificationStreamController =
      StreamController<NotificationResponse>.broadcast();

  Stream<NotificationResponse> get notificationStream =>
      _notificationStreamController.stream;

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone database
    tz.initializeTimeZones();

    // Request notification permissions
    await _requestPermissions();

    // Configure notification channels for Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _notificationStreamController.add(response);
      },
    );

    _isInitialized = true;
    print('✅ Notification Service Initialized');
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.notification.request();
    print('🔔 Notification Permission Status: $status');
  }

  // Test notification to check if it's working
  Future<void> showTestNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'Test notification channel',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await _notifications.show(
      999999,
      'Test Notification',
      'If you can see this, notifications are working! 🎉',
      platformChannelSpecifics,
      payload: 'test',
    );

    print('✅ Test notification shown');
  }

  // Goal Notifications
  Future<void> scheduleGoalNotifications(String userEmail) async {
    try {
      final goals = await HiveHelper.getAllGoals(userEmail);
      print('🎯 Scheduling notifications for ${goals.length} goals');

      for (final goal in goals) {
        await _scheduleDailyGoalNotification(goal, userEmail);
      }
    } catch (e) {
      print('❌ Error scheduling goal notifications: $e');
    }
  }

  Future<void> _scheduleDailyGoalNotification(
      Goal goal, String userEmail) async {
    try {
      final now = DateTime.now();

      // Check if goal is completed or expired
      if (goal.endDate != null && now.isAfter(goal.endDate!)) {
        print('⏰ Goal "${goal.title}" has ended, cancelling notifications');
        await _cancelGoalNotifications(goal.id);
        return;
      }

      // Calculate remaining days
      final daysRemaining = goal.endDate != null
          ? goal.endDate!.difference(now).inDays
          : goal.longestStreak - goal.currentStreak;

      print('📅 Goal "${goal.title}" - $daysRemaining days remaining');

      if (daysRemaining <= 0) {
        // Schedule completion notification for tomorrow 9 AM
        final completionTime = DateTime(now.year, now.month, now.day + 1, 9, 0);
        await _scheduleGoalCompletionNotification(
            goal, userEmail, completionTime);
        return;
      }

      // Schedule daily notifications at 9 AM
      for (int i = 0; i <= daysRemaining; i++) {
        final notificationTime =
            DateTime(now.year, now.month, now.day + i, 9, 0);

        if (notificationTime.isAfter(now)) {
          await _scheduleSingleGoalNotification(
            goal: goal,
            scheduledTime: notificationTime,
            userEmail: userEmail,
            isLastDay: i == daysRemaining,
          );
          print(
              '⏰ Scheduled goal notification for ${notificationTime.toString()}');
        }
      }
    } catch (e) {
      print('❌ Error scheduling daily goal notification: $e');
    }
  }

  Future<void> _scheduleSingleGoalNotification({
    required Goal goal,
    required DateTime scheduledTime,
    required String userEmail,
    required bool isLastDay,
  }) async {
    try {
      const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'goal_channel',
        'Goal Reminders',
        channelDescription: 'Notifications for your daily goals',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        autoCancel: true,
        showWhen: true,
      );

      const DarwinNotificationDetails iosPlatformChannelSpecifics =
          DarwinNotificationDetails();

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics,
      );

      await _notifications.zonedSchedule(
        _generateGoalNotificationId(goal.id, scheduledTime),
        isLastDay ? 'Goal Completed! 🎉' : 'Daily Goal Reminder',
        isLastDay
            ? 'Congratulations! You completed "${goal.title}" successfully!'
            : 'Don\'t forget to work on "${goal.title}". ${goal.currentStreak}/${goal.longestStreak} days completed.',
        tz.TZDateTime.from(scheduledTime, tz.local),
        platformChannelSpecifics,
        payload: jsonEncode({
          'type': 'goal',
          'goalId': goal.id,
          'userEmail': userEmail,
          'isLastDay': isLastDay,
        }),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
      );

      // Save to notification history
      await HiveHelper.saveNotification(
        userEmail,
        isLastDay ? 'Goal Completed! 🎉' : 'Daily Goal Reminder',
        isLastDay
            ? 'Congratulations! You completed "${goal.title}" successfully!'
            : 'Don\'t forget to work on "${goal.title}". ${goal.currentStreak}/${goal.longestStreak} days completed.',
      );

      print('✅ Goal notification scheduled: ${goal.title} at $scheduledTime');
    } catch (e) {
      print('❌ Error scheduling single goal notification: $e');
    }
  }

  Future<void> _scheduleGoalCompletionNotification(
      Goal goal, String userEmail, DateTime completionTime) async {
    try {
      const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'goal_channel',
        'Goal Reminders',
        channelDescription: 'Notifications for your daily goals',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );

      const DarwinNotificationDetails iosPlatformChannelSpecifics =
          DarwinNotificationDetails();

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics,
      );

      await _notifications.zonedSchedule(
        _generateGoalNotificationId(goal.id, completionTime),
        'Goal Completed! 🎉',
        'Congratulations! You completed "${goal.title}" successfully!',
        tz.TZDateTime.from(completionTime, tz.local),
        platformChannelSpecifics,
        payload: jsonEncode({
          'type': 'goal_completed',
          'goalId': goal.id,
          'userEmail': userEmail,
        }),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
      );

      await HiveHelper.saveNotification(
        userEmail,
        'Goal Completed! 🎉',
        'Congratulations! You completed "${goal.title}" successfully!',
      );

      print('✅ Goal completion notification scheduled for ${goal.title}');
    } catch (e) {
      print('❌ Error scheduling goal completion notification: $e');
    }
  }

  // Reminder Notifications
  Future<void> scheduleReminderNotifications(
      String userEmail, List<ReminderModel> reminders) async {
    try {
      print('🔔 Scheduling notifications for ${reminders.length} reminders');

      for (final reminder in reminders) {
        await _scheduleReminderNotification(reminder, userEmail);
      }
    } catch (e) {
      print('❌ Error scheduling reminder notifications: $e');
    }
  }

  Future<void> _scheduleReminderNotification(
      ReminderModel reminder, String userEmail) async {
    try {
      if (reminder.dateUtcMs == null || reminder.timeMinutes == null) {
        print('⏰ Reminder "${reminder.title}" has no date/time, skipping');
        return;
      }

      final reminderDate =
          DateTime.fromMillisecondsSinceEpoch(reminder.dateUtcMs!);
      final hour = reminder.timeMinutes! ~/ 60;
      final minute = reminder.timeMinutes! % 60;

      // Handle repeat days
      if (reminder.repeatDays != null && reminder.repeatDays!.isNotEmpty) {
        for (final day in reminder.repeatDays!) {
          await _scheduleRepeatingReminder(
              reminder, day, hour, minute, userEmail);
        }
      } else {
        // One-time reminder
        final reminderDateTime = DateTime(
          reminderDate.year,
          reminderDate.month,
          reminderDate.day,
          hour,
          minute,
        );

        if (reminderDateTime.isAfter(DateTime.now())) {
          await _scheduleSingleReminder(
            reminder: reminder,
            scheduledTime: reminderDateTime,
            userEmail: userEmail,
          );
          print(
              '⏰ Scheduled one-time reminder: ${reminder.title} at $reminderDateTime');
        }
      }
    } catch (e) {
      print('❌ Error scheduling reminder notification: $e');
    }
  }

  Future<void> _scheduleRepeatingReminder(
    ReminderModel reminder,
    int day,
    int hour,
    int minute,
    String userEmail,
  ) async {
    try {
      final nextOccurrence = _getNextWeekday(day, hour, minute);

      if (nextOccurrence.isAfter(DateTime.now())) {
        await _scheduleSingleReminder(
          reminder: reminder,
          scheduledTime: nextOccurrence,
          userEmail: userEmail,
          isRepeating: true,
        );
        print(
            '⏰ Scheduled repeating reminder: ${reminder.title} on day $day at $hour:$minute');
      }
    } catch (e) {
      print('❌ Error scheduling repeating reminder: $e');
    }
  }

  DateTime _getNextWeekday(int weekday, int hour, int minute) {
    final now = DateTime.now();
    var date = DateTime(now.year, now.month, now.day, hour, minute);

    // Adjust to next occurrence of the specified weekday (0=Sunday, 6=Saturday)
    while (date.weekday != _convertToSystemWeekday(weekday) ||
        date.isBefore(now)) {
      date = date.add(const Duration(days: 1));
    }

    return date;
  }

  int _convertToSystemWeekday(int appWeekday) {
    // Convert from app's weekday (0=Sunday, 6=Saturday) to system weekday (1=Monday, 7=Sunday)
    return appWeekday == 6 ? 7 : appWeekday + 1;
  }

  Future<void> _scheduleSingleReminder({
    required ReminderModel reminder,
    required DateTime scheduledTime,
    required String userEmail,
    bool isRepeating = false,
  }) async {
    try {
      const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'reminder_channel',
        'Reminders',
        channelDescription: 'Notifications for your reminders',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        autoCancel: true,
        showWhen: true,
      );

      const DarwinNotificationDetails iosPlatformChannelSpecifics =
          DarwinNotificationDetails();

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics,
      );

      await _notifications.zonedSchedule(
        _generateReminderNotificationId(reminder.id, scheduledTime),
        'Reminder: ${reminder.title}',
        reminder.notes ?? 'Don\'t forget about this!',
        tz.TZDateTime.from(scheduledTime, tz.local),
        platformChannelSpecifics,
        payload: jsonEncode({
          'type': 'reminder',
          'reminderId': reminder.id,
          'userEmail': userEmail,
        }),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
      );

      await HiveHelper.saveNotification(
        userEmail,
        'Reminder: ${reminder.title}',
        reminder.notes ?? 'Don\'t forget about this!',
      );

      print(
          '✅ Reminder notification scheduled: ${reminder.title} at $scheduledTime');
    } catch (e) {
      print('❌ Error scheduling single reminder: $e');
    }
  }

  // Helper methods
  int _generateGoalNotificationId(String goalId, DateTime time) {
    return ('goal_${goalId}_${time.millisecondsSinceEpoch}').hashCode.abs() %
        100000;
  }

  int _generateReminderNotificationId(String reminderId, DateTime time) {
    return ('reminder_${reminderId}_${time.millisecondsSinceEpoch}')
            .hashCode
            .abs() %
        100000;
  }

  Future<void> _cancelGoalNotifications(String goalId) async {
    final pendingNotifications =
        await _notifications.pendingNotificationRequests();

    for (final notification in pendingNotifications) {
      if (notification.payload != null) {
        try {
          final payload = jsonDecode(notification.payload!);
          if (payload['type'] == 'goal' && payload['goalId'] == goalId) {
            await _notifications.cancel(notification.id);
            print('❌ Cancelled goal notification: $goalId');
          }
        } catch (e) {
          print('Error parsing notification payload: $e');
        }
      }
    }
  }

  Future<void> cancelReminderNotifications(String reminderId) async {
    final pendingNotifications =
        await _notifications.pendingNotificationRequests();

    for (final notification in pendingNotifications) {
      if (notification.payload != null) {
        try {
          final payload = jsonDecode(notification.payload!);
          if (payload['type'] == 'reminder' &&
              payload['reminderId'] == reminderId) {
            await _notifications.cancel(notification.id);
            print('❌ Cancelled reminder notification: $reminderId');
          }
        } catch (e) {
          print('Error parsing notification payload: $e');
        }
      }
    }
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    print('❌ All notifications cancelled');
  }

  // Get pending notifications for debugging
  Future<void> printPendingNotifications() async {
    final pending = await _notifications.pendingNotificationRequests();
    print('📋 Pending notifications: ${pending.length}');
    for (final notification in pending) {
      print(
          '  - ID: ${notification.id}, Title: ${notification.title}, Time: ${notification.body}');
    }
  }

  void dispose() {
    _notificationStreamController.close();
  }
}
