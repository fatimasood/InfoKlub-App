import 'package:infoklub/models/reminder/reminder_model.dart';
import 'package:infoklub/services/local_storage_services/hive_helpers.dart';

class ReminderRepository {
  Future<List<ReminderModel>> fetchAll(String email) async {
    final box = await HiveHelper.openReminderBox(email);
    return box.values.toList();
  }

  Future<void> upsert(String email, ReminderModel e) async {
    final box = await HiveHelper.openReminderBox(email);
    await box.put(e.id, e);
  }

  Future<void> delete(String email, String id) async {
    final box = await HiveHelper.openReminderBox(email);
    await box.delete(id);
  }

  Future<void> toggleCompleted(String email, String id, bool value) async {
    final box = await HiveHelper.openReminderBox(email);
    final e = box.get(id);
    if (e != null) {
      e.isCompleted = value;
      await e.save();
    }
  }
}
