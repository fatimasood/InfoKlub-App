import 'package:infoklub/services/firebase_services/splash_services.dart';
import 'package:infoklub/services/goals_services/goalservice.dart';
import 'package:infoklub/services/notifications_service/notifications_services.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  Future<void> initializeAppNotifications() async {
    try {
      final userEmail = userMail;
      if (userEmail.isNotEmpty) {
        await GoalService.checkDailyStreaks(userEmail);
        await NotificationService().scheduleGoalNotifications(userEmail);
        print('✅ App notifications initialized');
      }
    } catch (e) {
      print('❌ Error initializing app notifications: $e');
    }
  }

  Future<void> handleAppResumed() async {
    try {
      final userEmail = userMail;
      if (userEmail.isNotEmpty) {
        await GoalService.checkDailyStreaks(userEmail);
        await NotificationService().scheduleGoalNotifications(userEmail);
        print('✅ Notifications refreshed on app resume');
      }
    } catch (e) {
      print('❌ Error handling app resume: $e');
    }
  }
}
