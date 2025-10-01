import 'package:flutter/foundation.dart';
import 'package:infoklub/services/local_storage_services/hive_helpers.dart';

class GoalService {
  static Future<void> checkDailyStreaks(String userEmail) async {
    try {
      final goals = await HiveHelper.getAllGoals(userEmail);
      final now = DateTime.now();

      for (final goal in goals) {
        // Use startDate as fallback if lastUpdated is null
        final lastUpdated = goal.lastUpdated ?? goal.startDate;

        // Check if it's a new day (after midnight)
        if (now.day != lastUpdated.day ||
            now.month != lastUpdated.month ||
            now.year != lastUpdated.year) {
          // Check if goal has ended (use null-aware operator)
          if (goal.endDate != null && now.isAfter(goal.endDate!)) {
            // Goal period has ended, delete it after 1 day
            if (now.isAfter(goal.endDate!.add(const Duration(days: 1)))) {
              await HiveHelper.deleteGoal(userEmail, goal.id);
              continue; // Skip to next goal as this one is deleted
            }
          } else {
            // Reset completedToday for the new day
            final updatedGoal = goal.copyWith(
              completedToday: false,
              lastUpdated: now,
            );

            await HiveHelper.saveGoal(userEmail, updatedGoal);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking daily streaks: $e');
      }
    }
  }
}
