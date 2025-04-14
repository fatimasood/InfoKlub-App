import 'package:flutter/material.dart';
import 'package:infoklub/models/reminder/reminder_model.dart';

class RemindersViewModel extends ChangeNotifier {
  List<Reminder> _reminders = [];
  String _searchQuery = '';

  List<Reminder> get reminders => _sortedReminders;
  List<Reminder> get filteredReminders => _searchQuery.isEmpty
      ? _sortedReminders
      : _sortedReminders
          .where((r) =>
              r.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (r.notes?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
                  false))
          .toList();

  int get todayCount => _reminders.where(_isToday).length;
  int get scheduledCount => _reminders.where((r) => r.date != null).length;
  int get totalCount => _reminders.length;

  List<Reminder> get _sortedReminders {
    final list = List<Reminder>.from(_reminders);
    list.sort((a, b) {
      if (a.date == null) return 1;
      if (b.date == null) return -1;
      return a.date!.compareTo(b.date!);
    });
    return list;
  }

  RemindersViewModel() {
    // Initialize with dummy data
    final now = DateTime.now();
    _reminders = [
      Reminder(
        id: '1',
        title: 'Team Meeting',
        notes: 'Weekly sprint planning',
        date: DateTime(now.year, now.month, now.day, 14, 30),
        time: TimeOfDay(hour: 14, minute: 30),
        color: Colors.blue,
        repeatDays: [2], // Every Tuesday
      ),
      Reminder(
        id: '2',
        title: 'Buy Groceries',
        date: DateTime(now.year, now.month, now.day + 1, 18, 0),
        time: TimeOfDay(hour: 18, minute: 0),
        color: Colors.green,
      ),
      Reminder(
        id: '3',
        title: 'Call Mom',
        isCompleted: true,
      ),
    ];
  }

  bool _isToday(Reminder reminder) {
    if (reminder.date == null) return false;
    final now = DateTime.now();
    return reminder.date!.year == now.year &&
        reminder.date!.month == now.month &&
        reminder.date!.day == now.day;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
    notifyListeners();
  }

  void updateReminder(String id, Reminder updated) {
    final index = _reminders.indexWhere((r) => r.id == id);
    if (index != -1) {
      _reminders[index] = updated;
      notifyListeners();
    }
  }

  void deleteReminder(String id) {
    _reminders.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  void toggleCompletion(String id) {
    final index = _reminders.indexWhere((r) => r.id == id);
    if (index != -1) {
      _reminders[index] = _reminders[index].copyWith(
        isCompleted: !_reminders[index].isCompleted,
      );
      notifyListeners();
    }
  }
}
