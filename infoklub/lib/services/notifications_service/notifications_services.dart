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

  final FlutterLocalNotificationsPlugin _notifications =
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
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        _notificationStreamController.add(response);

        if (response.payload != null) {
          try {
            final payload = jsonDecode(response.payload!);
            if (payload['type'] == 'goal') {
              final goalId = payload['goalId'];
              final userEmail = payload['userEmail'];
              final isCompletionDay = payload['isCompletionDay'] ?? false;

              // Handle goal notification trigger
              await handleGoalNotificationTrigger(
                  goalId, userEmail, isCompletionDay);
            } else if (payload['type'] == 'reminder') {
              final reminderId = payload['reminderId'];
              final userEmail = payload['userEmail'];

              // Handle reminder notification trigger
              await handleReminderNotificationTrigger(reminderId, userEmail);
            }
          } catch (e) {
            print('Error parsing notification payload: $e');
          }
        }
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

      // Cancel existing notifications for this goal first
      await _cancelGoalNotifications(goal.id);

      // Check if goal is completed or expired
      if (goal.endDate != null && now.isAfter(goal.endDate!)) {
        print('⏰ Goal "${goal.title}" has ended, cancelling notifications');
        return;
      }

      // Schedule only the NEXT notification, not all future ones
      DateTime nextNotificationTime;

      if (goal.endDate != null && now.isAfter(goal.endDate!)) {
        // Goal already ended, no need for daily reminders
        return;
      } else if (goal.endDate != null) {
        // Schedule for completion day
        final completionTime = DateTime(
            goal.endDate!.year, goal.endDate!.month, goal.endDate!.day, 9, 0);
        if (completionTime.isAfter(now)) {
          await _scheduleSingleGoalNotification(
            goal: goal,
            scheduledTime: completionTime,
            userEmail: userEmail,
            isCompletionDay: true,
          );
        }
      }

      // Schedule next daily reminder (tomorrow at 9 AM)
      nextNotificationTime = DateTime(now.year, now.month, now.day + 1, 9, 0);

      // Make sure we're not scheduling past the end date
      if (goal.endDate == null ||
          nextNotificationTime.isBefore(goal.endDate!) ||
          nextNotificationTime.isAtSameMomentAs(goal.endDate!)) {
        await _scheduleSingleGoalNotification(
          goal: goal,
          scheduledTime: nextNotificationTime,
          userEmail: userEmail,
          isCompletionDay: false,
        );
        print(
            '⏰ Scheduled next goal notification for ${nextNotificationTime.toString()}');
      }
    } catch (e) {
      print('❌ Error scheduling daily goal notification: $e');
    }
  }

  Future<void> rescheduleNextDailyNotification(
      Goal goal, String userEmail) async {
    try {
      final now = DateTime.now();

      // Cancel existing daily notifications for this goal
      await _cancelGoalNotifications(goal.id);

      // Schedule next daily reminder (tomorrow at 9 AM)
      final nextNotificationTime =
          DateTime(now.year, now.month, now.day + 1, 9, 0);

      // Check if we need to schedule (goal not ended)
      if (goal.endDate == null ||
          nextNotificationTime.isBefore(goal.endDate!)) {
        await _scheduleSingleGoalNotification(
          goal: goal,
          scheduledTime: nextNotificationTime,
          userEmail: userEmail,
          isCompletionDay: false,
        );
        print('⏰ Rescheduled next daily notification for ${goal.title}');
      }
    } catch (e) {
      print('❌ Error rescheduling daily notification: $e');
    }
  }

  Future<void> _scheduleSingleGoalNotification({
    required Goal goal,
    required DateTime scheduledTime,
    required String userEmail,
    required bool isCompletionDay,
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

      String title;
      String message;

      if (isCompletionDay) {
        // For completion day, we'll check the actual status when the notification triggers
        title = 'Goal Period Ended';
        message =
            'Your goal "${goal.title}" period has ended. Check your progress!';
      } else {
        title = 'Daily Goal Reminder';
        message = 'Don\'t forget to work on "${goal.title}".';
      }

      await _notifications.zonedSchedule(
        _generateGoalNotificationId(goal.id, scheduledTime),
        title,
        message,
        tz.TZDateTime.from(scheduledTime, tz.local),
        platformChannelSpecifics,
        payload: jsonEncode({
          'type': 'goal',
          'goalId': goal.id,
          'userEmail': userEmail,
          'isCompletionDay': isCompletionDay,
          'scheduledTime': scheduledTime.millisecondsSinceEpoch,
        }),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
      );

      // REMOVED: Don't save to history immediately
      // Only save when notification actually triggers

      print('✅ Goal notification scheduled: $title at $scheduledTime');
    } catch (e) {
      print('❌ Error scheduling single goal notification: $e');
    }
  }
// handle notification trigger time

  Future<void> handleGoalNotificationTrigger(
      String goalId, String userEmail, bool isCompletionDay) async {
    try {
      final goal = await HiveHelper.getGoal(userEmail, goalId);
      if (goal == null) {
        print('❌ Goal not found for notification: $goalId');
        return;
      }

      String title;
      String message;

      if (isCompletionDay) {
        // Check actual completion status when notification triggers
        final isCompleted = goal.currentStreak >= goal.longestStreak;

        if (isCompleted) {
          title = 'Goal Completed! 🎉';
          message =
              'Congratulations! You successfully completed "${goal.title}"! ${goal.currentStreak}/${goal.longestStreak} days achieved!';
        } else {
          title = 'Goal Challenge Ended';
          message =
              'You may challenge yourself again for "${goal.title}". ${goal.currentStreak}/${goal.longestStreak} days completed.';
        }
      } else {
        title = 'Daily Goal Reminder';
        message =
            'Don\'t forget to work on "${goal.title}". ${goal.currentStreak}/${goal.longestStreak} days completed.';
      }

      // Save to notification history ONLY when actually triggered
      await HiveHelper.saveNotification(userEmail, title, message);

      print('✅ Goal notification triggered and saved: $title');
    } catch (e) {
      print('❌ Error handling goal notification: $e');
    }
  }

  Future<void> showGoalStartedNotification(Goal goal, String userEmail) async {
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

      await _notifications.show(
        _generateGoalNotificationId(goal.id, DateTime.now()),
        'Goal Started! 🚀',
        'You started "${goal.title}" goal. Good luck!',
        platformChannelSpecifics,
      );

      // Save to notification history
      await HiveHelper.saveNotification(
        userEmail,
        'Goal Started! 🚀',
        'You started "${goal.title}" goal. Good luck!',
      );

      print('✅ Goal started notification shown');
    } catch (e) {
      print('❌ Error showing goal started notification: $e');
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

      // Cancel existing notifications for this reminder first
      await cancelReminderNotifications(reminder.id);

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
      // Schedule for the next 4 occurrences to avoid bulk scheduling
      for (int i = 0; i < 4; i++) {
        final nextOccurrence = _getNextWeekdayOccurrence(day, hour, minute, i);

        if (nextOccurrence.isAfter(DateTime.now())) {
          await _scheduleSingleReminder(
            reminder: reminder,
            scheduledTime: nextOccurrence,
            userEmail: userEmail,
            isRepeating: true,
          );
          print(
              '⏰ Scheduled repeating reminder: ${reminder.title} on ${_getWeekdayName(day)} at $hour:$minute');
        }
      }
    } catch (e) {
      print('❌ Error scheduling repeating reminder: $e');
    }
  }

  DateTime _getNextWeekdayOccurrence(
      int weekday, int hour, int minute, int occurrenceIndex) {
    final now = DateTime.now();
    var date = DateTime(now.year, now.month, now.day, hour, minute);

    // Find the next occurrence
    int daysToAdd = 0;
    while (date.weekday != _convertToSystemWeekday(weekday) ||
        date.isBefore(now)) {
      daysToAdd++;
      date = DateTime(now.year, now.month, now.day + daysToAdd, hour, minute);
    }

    // Add weeks for subsequent occurrences
    if (occurrenceIndex > 0) {
      date = date.add(Duration(days: occurrenceIndex * 7));
    }

    return date;
  }

  String _getWeekdayName(int appWeekday) {
    const weekdays = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
    return weekdays[appWeekday];
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
          'scheduledTime': scheduledTime.millisecondsSinceEpoch,
        }),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
      );

      // REMOVED: Don't save to history immediately when scheduling
      // Only save when notification actually triggers

      print(
          '✅ Reminder notification scheduled: ${reminder.title} at $scheduledTime');
    } catch (e) {
      print('❌ Error scheduling single reminder: $e');
    }
  }

  int _convertToSystemWeekday(int appWeekday) {
    // Convert from app's weekday (0=Sunday, 6=Saturday) to system weekday (1=Monday, 7=Sunday)
    // Your app uses: 0=Sunday, 1=Monday, 2=Tuesday, 3=Wednesday, 4=Thursday, 5=Friday, 6=Saturday
    // System uses: 1=Monday, 2=Tuesday, 3=Wednesday, 4=Thursday, 5=Friday, 6=Saturday, 7=Sunday

    switch (appWeekday) {
      case 0:
        return 7; // Sunday
      case 1:
        return 1; // Monday
      case 2:
        return 2; // Tuesday
      case 3:
        return 3; // Wednesday
      case 4:
        return 4; // Thursday
      case 5:
        return 5; // Friday
      case 6:
        return 6; // Saturday
      default:
        return 1; // Default to Monday
    }
  }

  Future<void> handleReminderNotificationTrigger(
      String reminderId, String userEmail) async {
    try {
      final reminders = await HiveHelper.openReminderBox(userEmail);
      final reminder = reminders.get(reminderId);

      if (reminder == null) {
        print('❌ Reminder not found for notification: $reminderId');
        return;
      }

      // Save to notification history ONLY when actually triggered
      await HiveHelper.saveNotification(
        userEmail,
        'Reminder: ${reminder.title}',
        reminder.notes ?? 'Don\'t forget about this!',
      );

      print('✅ Reminder notification triggered and saved: ${reminder.title}');
    } catch (e) {
      print('❌ Error handling reminder notification: $e');
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
