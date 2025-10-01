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
  }

  Future<void> _requestPermissions() async {
    await Permission.notification.request();
  }

  // Goal Notifications
  Future<void> scheduleGoalNotifications(String userEmail) async {
    final goals = await HiveHelper.getAllGoals(userEmail);

    for (final goal in goals) {
      await _scheduleDailyGoalNotification(goal, userEmail);
    }
  }

  Future<void> _scheduleDailyGoalNotification(
      Goal goal, String userEmail) async {
    final now = DateTime.now();
    final startOfDay =
        DateTime(now.year, now.month, now.day, 9, 0); // 9 AM daily

    // Check if goal is still active
    if (goal.endDate != null && now.isAfter(goal.endDate!)) {
      await _cancelGoalNotifications(goal.id);
      return;
    }

    // Schedule notification for each remaining day
    final daysRemaining = goal.endDate != null
        ? goal.endDate!.difference(now).inDays
        : goal.longestStreak - goal.currentStreak;

    if (daysRemaining <= 0) {
      // Goal completed - schedule congratulations notification
      await _scheduleGoalCompletionNotification(goal, userEmail);
      return;
    }

    // Schedule daily notification
    for (int i = 0; i <= daysRemaining; i++) {
      final notificationTime = startOfDay.add(Duration(days: i));

      if (notificationTime.isAfter(now)) {
        await _scheduleSingleGoalNotification(
          goal: goal,
          scheduledTime: notificationTime,
          userEmail: userEmail,
          isLastDay: i == daysRemaining,
        );
      }
    }
  }

  Future<void> _scheduleSingleGoalNotification({
    required Goal goal,
    required DateTime scheduledTime,
    required String userEmail,
    required bool isLastDay,
  }) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'goal_channel',
      'Goal Reminders',
      channelDescription: 'Notifications for your daily goals',
      importance: Importance.high,
      priority: Priority.high,
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
  }

  Future<void> _scheduleGoalCompletionNotification(
      Goal goal, String userEmail) async {
    final completionTime = DateTime.now().add(const Duration(seconds: 5));

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'goal_channel',
      'Goal Reminders',
      channelDescription: 'Notifications for your daily goals',
      importance: Importance.high,
      priority: Priority.high,
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
  }

  // Reminder Notifications
  Future<void> scheduleReminderNotifications(
      String userEmail, List<ReminderModel> reminders) async {
    for (final reminder in reminders) {
      await _scheduleReminderNotification(reminder, userEmail);
    }
  }

  Future<void> _scheduleReminderNotification(
      ReminderModel reminder, String userEmail) async {
    if (reminder.dateUtcMs == null || reminder.timeMinutes == null) return;

    final reminderDate =
        DateTime.fromMillisecondsSinceEpoch(reminder.dateUtcMs!);
    final hour = reminder.timeMinutes! ~/ 60;
    final minute = reminder.timeMinutes! % 60;

    final reminderDateTime = DateTime(
      reminderDate.year,
      reminderDate.month,
      reminderDate.day,
      hour,
      minute,
    );

    // Handle repeat days
    if (reminder.repeatDays != null && reminder.repeatDays!.isNotEmpty) {
      for (final day in reminder.repeatDays!) {
        await _scheduleRepeatingReminder(
            reminder, day, hour, minute, userEmail);
      }
    } else {
      // One-time reminder
      if (reminderDateTime.isAfter(DateTime.now())) {
        await _scheduleSingleReminder(
          reminder: reminder,
          scheduledTime: reminderDateTime,
          userEmail: userEmail,
        );
      }
    }
  }

  Future<void> _scheduleRepeatingReminder(
    ReminderModel reminder,
    int day,
    int hour,
    int minute,
    String userEmail,
  ) async {
    final now = DateTime.now();
    final nextOccurrence = _getNextWeekday(day, hour, minute);

    if (nextOccurrence.isAfter(now)) {
      await _scheduleSingleReminder(
        reminder: reminder,
        scheduledTime: nextOccurrence,
        userEmail: userEmail,
        isRepeating: true,
      );
    }
  }

  DateTime _getNextWeekday(int weekday, int hour, int minute) {
    final now = DateTime.now();
    var date = DateTime(now.year, now.month, now.day, hour, minute);

    // Adjust to next occurrence of the specified weekday
    while (date.weekday != weekday + 1 || date.isBefore(now)) {
      date = date.add(const Duration(days: 1));
    }

    return date;
  }

  Future<void> _scheduleSingleReminder({
    required ReminderModel reminder,
    required DateTime scheduledTime,
    required String userEmail,
    bool isRepeating = false,
  }) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Notifications for your reminders',
      importance: Importance.high,
      priority: Priority.high,
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
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      payload: jsonEncode({
        'type': 'reminder',
        'reminderId': reminder.id,
        'userEmail': userEmail,
      }),
    );

    await HiveHelper.saveNotification(
      userEmail,
      'Reminder: ${reminder.title}',
      reminder.notes ?? 'Don\'t forget about this!',
    );
  }

  // Helper methods
  int _generateGoalNotificationId(String goalId, DateTime time) {
    return ('goal_${goalId}_${time.millisecondsSinceEpoch}').hashCode;
  }

  int _generateReminderNotificationId(String reminderId, DateTime time) {
    return ('reminder_${reminderId}_${time.millisecondsSinceEpoch}').hashCode;
  }

  Future<void> _cancelGoalNotifications(String goalId) async {
    final pendingNotifications =
        await _notifications.pendingNotificationRequests();

    for (final notification in pendingNotifications) {
      if (notification.payload != null) {
        final payload = jsonDecode(notification.payload!);
        if (payload['type'] == 'goal' && payload['goalId'] == goalId) {
          await _notifications.cancel(notification.id);
        }
      }
    }
  }

  Future<void> cancelReminderNotifications(String reminderId) async {
    final pendingNotifications =
        await _notifications.pendingNotificationRequests();

    for (final notification in pendingNotifications) {
      if (notification.payload != null) {
        final payload = jsonDecode(notification.payload!);
        if (payload['type'] == 'reminder' &&
            payload['reminderId'] == reminderId) {
          await _notifications.cancel(notification.id);
        }
      }
    }
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  void dispose() {
    _notificationStreamController.close();
  }
}
