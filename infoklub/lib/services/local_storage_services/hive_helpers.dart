import 'package:hive/hive.dart';
import 'package:infoklub/models/career/career_model.dart';
import 'package:infoklub/models/goals/goal_model.dart';
import 'package:infoklub/models/health/health_model.dart';
import 'package:infoklub/models/reminder/reminder_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveHelper {
  static Future<void> initHive() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(HealthModelAdapter());
  }

  static String getHealthBoxName(String email) {
    return "health_${email.replaceAll('@', '_').replaceAll('.', '_')}";
  }

  static Future<Box<HealthModel>> openHealthBox(String email) async {
    final boxName = getHealthBoxName(email);
    return await Hive.openBox<HealthModel>(boxName);
  }

  static String getCareerBoxName(String email) {
    return "career_${email.replaceAll('@', '_').replaceAll('.', '_')}";
  }

  static Future<Box<CarrerModel>> openCareerBox(String email) async {
    final boxName = getCareerBoxName(email);
    return await Hive.openBox<CarrerModel>(boxName);
  }

  static String getReminderBoxName(String email) {
    return "reminders_${email.replaceAll('@', '_').replaceAll('.', '_')}";
  }

  static Future<Box<ReminderModel>> openReminderBox(String email) async {
    final boxName = getReminderBoxName(email);

    return Hive.isBoxOpen(boxName)
        ? Hive.box<ReminderModel>(boxName)
        : await Hive.openBox<ReminderModel>(boxName);
  }

  static String getGoalsBoxName(String email) {
    return "goals_${email.replaceAll('@', '_').replaceAll('.', '_')}";
  }

  static Future<Box<Goal>> openGoalsBox(String email) async {
    final boxName = getGoalsBoxName(email);

    return Hive.isBoxOpen(boxName)
        ? Hive.box<Goal>(boxName)
        : await Hive.openBox<Goal>(boxName);
  }

  // goal CURD

  // Add to the switch statement in generic methods
  static Future<void> saveGoal(String email, Goal goal) async {
    final box = await openGoalsBox(email);
    await box.put(goal.id, goal);
  }

  static Future<List<Goal>> getAllGoals(String email) async {
    final box = await openGoalsBox(email);
    return box.values.toList();
  }

  static Future<Goal?> getGoal(String email, String goalId) async {
    final box = await openGoalsBox(email);
    return box.get(goalId);
  }

  static Future<void> deleteGoal(String email, String goalId) async {
    final box = await openGoalsBox(email);
    await box.delete(goalId);
  }

  static Future<void> clearAllGoals(String email) async {
    final box = await openGoalsBox(email);
    await box.clear();
  }
}
