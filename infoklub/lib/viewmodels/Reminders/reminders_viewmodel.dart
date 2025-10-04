import 'package:flutter/material.dart';
import 'package:infoklub/services/local_storage_services/hive_helpers.dart';
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

    // Schedule notification for the new reminder
    await NotificationService()
        .scheduleReminderNotifications(userEmail, [model]);

    // Show immediate test notification
    // await NotificationService().showTestNotification();
    // Show immediate "reminder set" notification
    await _showReminderSetNotification(reminder);
    notifyListeners();
  }

  Future<void> _showReminderSetNotification(Reminder reminder) async {
    try {
      String message;

      if (reminder.repeatDays != null && reminder.repeatDays!.isNotEmpty) {
        final dayNames =
            reminder.repeatDays!.map((day) => _getWeekdayName(day)).join(', ');
        message =
            'Repeating reminder set for $dayNames at ${_formatTime(reminder.dateTime!)}';
      } else if (reminder.dateTime != null) {
        message = 'Reminder set for ${_formatDateTime(reminder.dateTime!)}';
      } else {
        message = 'Reminder created';
      }

      // Save to notification history immediately for confirmation
      await HiveHelper.saveNotification(
        userEmail,
        'Reminder Set ✅',
        message,
      );

      print('✅ Reminder set notification saved');
    } catch (e) {
      print('❌ Error showing reminder set notification: $e');
    }
  }

  Future<void> updateReminderWithReschedule(String id, Reminder updated) async {
    final idx = _reminders.indexWhere((r) => r.id == id);
    if (idx == -1) return;

    // Cancel existing notifications
    await NotificationService().cancelReminderNotifications(id);

    final toSave = updated.copyWith();
    final model = ReminderMapper.toModel(toSave);
    await _repo.upsert(userEmail, model);

    _reminders[idx] = toSave;

    // Reschedule notifications with updated data
    await NotificationService()
        .scheduleReminderNotifications(userEmail, [model]);

    notifyListeners();
  }

  String _formatDateTime(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm • ${dt.day}/${dt.month}/${dt.year}';
  }

  String _formatTime(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  String _getWeekdayName(int appWeekday) {
    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return weekdays[appWeekday];
  }

  Future<void> updateReminder(String id, Reminder updated) async {
    final idx = _reminders.indexWhere((r) => r.id == id);
    if (idx == -1) return;

    final toSave = updated.copyWith();
    final model = ReminderMapper.toModel(toSave);
    await _repo.upsert(userEmail, model);

    _reminders[idx] = toSave;
    notifyListeners();
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
