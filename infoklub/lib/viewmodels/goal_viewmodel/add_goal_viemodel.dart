import 'package:flutter/material.dart';

class AddGoalViewModel extends ChangeNotifier {
  String _goalName = '';
  int _streakDays = 7;
  String _description = '';
  DateTime? _startDate;
  DateTime? _endDate;

  String get goalName => _goalName;
  int get streakDays => _streakDays;
  String get description => _description;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  void setGoalName(String value) {
    _goalName = value;
    notifyListeners();
  }

  void incrementDays() {
    _streakDays++;
    notifyListeners();
  }

  void decrementDays() {
    if (_streakDays > 1) {
      _streakDays--;
      notifyListeners();
    }
  }

  void setDays(int value) {
    _streakDays = value;
    notifyListeners();
  }

  void setDescription(String value) {
    _description = value;
    notifyListeners();
  }

  void setStartDate(DateTime? date) {
    _startDate = date;
    notifyListeners();
  }

  void setEndDate(DateTime? date) {
    _endDate = date;
    notifyListeners();
  }

  bool validate() {
    return _goalName.isNotEmpty && _streakDays > 0;
  }
}
