import 'package:flutter/material.dart';

class Reminder {
  final String id;
  final String title;
  final DateTime? dateTime;
  final bool isCompleted;
  final Color? color;

  Reminder({
    required this.id,
    required this.title,
    this.dateTime,
    this.isCompleted = false,
    this.color,
  });
}

class RemindersViewModel extends ChangeNotifier {
  List<Reminder> _reminders = [];
  int _todayCount = 0;
  int _scheduledCount = 0;

  List<Reminder> get reminders => _reminders;
  int get todayCount => _todayCount;
  int get scheduledCount => _scheduledCount;
  int get totalCount => _reminders.length;

  RemindersViewModel() {
    // Initialize with dummy data
    _reminders = [
      Reminder(
        id: '1',
        title: 'Team meeting',
        dateTime: DateTime.now(),
        color: Colors.blue,
      ),
      Reminder(
        id: '2',
        title: 'Buy groceries',
        dateTime: DateTime.now().add(Duration(days: 1)),
        color: Colors.green,
      ),
      Reminder(
        id: '3',
        title: 'Call mom',
        isCompleted: true,
      ),
    ];
    _updateCounts();
  }

  void _updateCounts() {
    final now = DateTime.now();
    _todayCount = _reminders
        .where((r) =>
            r.dateTime != null &&
            r.dateTime!.year == now.year &&
            r.dateTime!.month == now.month &&
            r.dateTime!.day == now.day)
        .length;

    _scheduledCount = _reminders.where((r) => r.dateTime != null).length;
    notifyListeners();
  }

  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
    _updateCounts();
  }

  void toggleCompletion(String id) {
    final index = _reminders.indexWhere((r) => r.id == id);
    if (index != -1) {
      _reminders[index] = _reminders[index]
          .copyWith(isCompleted: !_reminders[index].isCompleted);
      notifyListeners();
    }
  }
}

extension on Reminder {
  Reminder copyWith({
    String? title,
    DateTime? dateTime,
    bool? isCompleted,
    Color? color,
  }) {
    return Reminder(
      id: id,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      isCompleted: isCompleted ?? this.isCompleted,
      color: color ?? this.color,
    );
  }
}
