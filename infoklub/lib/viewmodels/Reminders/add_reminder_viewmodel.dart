import 'package:flutter/material.dart';
import 'package:infoklub/models/reminder/reminder_model.dart';

class ReminderViewModel extends ChangeNotifier {
  List<Reminder> _reminders = [];
  String _searchQuery = '';

  List<Reminder> get reminders => _reminders;
  List<Reminder> get filteredReminders => _searchQuery.isEmpty
      ? _reminders
      : _reminders
          .where((reminder) =>
              reminder.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();

  ReminderViewModel() {
    // Initialize with dummy data
    _reminders = [
      Reminder(
        id: '1',
        title: 'Morning Meditation',
        notes: '15 minutes of mindfulness',
        date: DateTime.now().add(Duration(days: 1)),
        time: TimeOfDay(hour: 7, minute: 30),
        repeatDays: [1, 2, 3, 4, 5], // Weekdays
      ),
      Reminder(
        id: '2',
        title: 'Weekly Review',
        notes: 'Plan for next week',
        date: DateTime.now().add(Duration(days: 7)),
        time: TimeOfDay(hour: 18, minute: 0),
        repeatDays: [6], // Saturday
      ),
    ];
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addNewReminder(Reminder reminder) {
    _reminders.add(reminder);
    notifyListeners();
  }

  void toggleReminderCompletion(String reminderId) {
    // Implement if needed
    notifyListeners();
  }
}
