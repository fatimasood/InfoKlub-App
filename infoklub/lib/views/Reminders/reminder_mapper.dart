import 'package:infoklub/models/reminder/reminder.dart';
import 'package:infoklub/models/reminder/reminder_model.dart';

class ReminderMapper {
  static ReminderModel toModel(Reminder r) {
    int? dateUtcMs;
    int? timeMinutes;

    if (r.dateTime != null) {
      // store the DATE in UTC millis + store the time as minutes since midnight
      final local = r.dateTime!;
      dateUtcMs = DateTime(local.year, local.month, local.day)
          .toUtc()
          .millisecondsSinceEpoch;
      timeMinutes = local.hour * 60 + local.minute;
    }

    return ReminderModel(
      id: r.id,
      title: r.title,
      notes: r.notes,
      dateUtcMs: dateUtcMs,
      timeMinutes: timeMinutes,
      isCompleted: r.isCompleted,
      colorValue: r.colorValue,
      repeatDays: r.repeatDays,
    );
  }

  static Reminder fromModel(ReminderModel m, String userEmail) {
    DateTime? dateTime;
    if (m.dateUtcMs != null) {
      final baseDateUtc =
          DateTime.fromMillisecondsSinceEpoch(m.dateUtcMs!, isUtc: true);
      final baseLocal = baseDateUtc.toLocal();

      final hh = (m.timeMinutes ?? 0) ~/ 60;
      final mm = (m.timeMinutes ?? 0) % 60;

      dateTime = DateTime(
        baseLocal.year,
        baseLocal.month,
        baseLocal.day,
        hh,
        mm,
      );
    }

    return Reminder(
      id: m.id,
      title: m.title,
      notes: m.notes,
      dateTime: dateTime,
      isCompleted: m.isCompleted,
      colorValue: m.colorValue,
      repeatDays: m.repeatDays,
      userEmail: userEmail,
    );
  }
}
