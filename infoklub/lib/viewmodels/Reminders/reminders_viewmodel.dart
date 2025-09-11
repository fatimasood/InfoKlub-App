import 'package:flutter/material.dart';
import 'package:infoklub/services/notifications_service/notifications_services.dart';
import 'package:infoklub/views/Reminders/reminder_mapper.dart';
import 'package:infoklub/views/Reminders/reminder_repository.dart';
import 'package:uuid/uuid.dart';

import 'package:infoklub/models/reminder/reminder.dart';

class RemindersViewModel extends ChangeNotifier {
  final ReminderRepository _repo = ReminderRepository();
  final String userEmail;

  RemindersViewModel({required this.userEmail});

  List<Reminder> _reminders = [];
  String _searchQuery = '';

  List<Reminder> get reminders => _filtered(_sorted(_reminders));
  int get todayCount => _reminders.where(_isToday).length;
  int get scheduledCount => _reminders.where(_isScheduled).length;
  int get totalCount => _reminders.length;
  String get currentUserEmail => userEmail;

  Future<void> load() async {
    final models = await _repo.fetchAll(userEmail);
    _reminders =
        models.map((m) => ReminderMapper.fromModel(m, userEmail)).toList();
    notifyListeners();
  }

  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  Future<void> addReminder(Reminder reminder) async {
    // ensure id
    final id = (reminder.id.isEmpty) ? const Uuid().v4() : reminder.id;
    // ignore: unused_local_variable
    final withId = reminder.copyWith()..id; // ignore; copy keeps same id

    final toSave = Reminder(
      id: id,
      title: reminder.title,
      notes: reminder.notes,
      dateTime: reminder.dateTime,
      isCompleted: reminder.isCompleted,
      colorValue: reminder.colorValue,
      repeatDays: reminder.repeatDays,
      userEmail: userEmail,
    );

    final model = ReminderMapper.toModel(toSave);
    await _repo.upsert(userEmail, model);

    _reminders.add(toSave);
    notifyListeners();

    // Notification schedule
    if (toSave.repeatDays != null && toSave.repeatDays!.isNotEmpty) {
      await NotificationService.scheduleForMultipleDays(
        title: toSave.title,
        body: toSave.notes ?? "Reminder",
        days: toSave.repeatDays!, // List<int> = [1,3,5] type
        time: toSave.dateTime ?? DateTime.now(),
      );
    } else if (toSave.dateTime != null) {
      await NotificationService.scheduleNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: toSave.title,
        body: toSave.notes ?? "Reminder",
        scheduledTime: toSave.dateTime!,
      );
    }
  }

  Future<void> updateReminder(String id, Reminder updated) async {
    final idx = _reminders.indexWhere((r) => r.id == id);
    if (idx == -1) return;

    final toSave = updated.copyWith();
    final model = ReminderMapper.toModel(toSave);
    await _repo.upsert(userEmail, model);

    _reminders[idx] = toSave;
    notifyListeners();

    // ✅ Pehle purana cancel karo (future: cancelNotification(id))
    // Fir naya schedule karo
    if (toSave.repeatDays != null && toSave.repeatDays!.isNotEmpty) {
      await NotificationService.scheduleForMultipleDays(
        title: toSave.title,
        body: toSave.notes ?? "Reminder",
        days: toSave.repeatDays!,
        time: toSave.dateTime ?? DateTime.now(),
      );
    } else if (toSave.dateTime != null) {
      await NotificationService.scheduleNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: toSave.title,
        body: toSave.notes ?? "Reminder",
        scheduledTime: toSave.dateTime!,
      );
    }
  }

  Future<void> deleteReminder(String id) async {
    await _repo.delete(userEmail, id);
    _reminders.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  Future<void> toggleCompletion(String id) async {
    final idx = _reminders.indexWhere((r) => r.id == id);
    if (idx == -1) return;

    final newVal = !_reminders[idx].isCompleted;
    _reminders[idx] = _reminders[idx].copyWith(isCompleted: newVal);
    notifyListeners();

    await _repo.toggleCompleted(userEmail, id, newVal);
  }

  // helpers
  List<Reminder> _sorted(List<Reminder> list) {
    final l = List<Reminder>.from(list);
    l.sort((a, b) {
      if (a.dateTime == null) return 1;
      if (b.dateTime == null) return -1;
      return a.dateTime!.compareTo(b.dateTime!);
    });
    return l;
  }

  List<Reminder> _filtered(List<Reminder> list) {
    if (_searchQuery.isEmpty) return list;
    final q = _searchQuery.toLowerCase();
    return list
        .where((r) =>
            r.title.toLowerCase().contains(q) ||
            (r.notes?.toLowerCase().contains(q) ?? false))
        .toList();
  }

  bool _isToday(Reminder r) {
    if (r.dateTime == null) return false;

    final now = DateTime.now();
    final reminderDate = r.dateTime!;

    // Convert both to date-only strings for comparison
    final nowDateStr = '${now.year}-${now.month}-${now.day}';
    final reminderDateStr =
        '${reminderDate.year}-${reminderDate.month}-${reminderDate.day}';

    return nowDateStr == reminderDateStr;
  }

  bool _isScheduled(Reminder r) {
    if (r.dateTime == null) return false;

    final now = DateTime.now();
    final reminderDate = r.dateTime!;

    return reminderDate.isAfter(now);
  }
}
