// home_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:infoklub/models/goals/goal_model.dart';

class HomeViewModel extends ChangeNotifier {
  final List<Goal> _goals = [
    Goal(
      id: '1',
      title: 'Morning Run',
      currentStreak: 7,
      longestStreak: 12,
      completedToday: false,
      color: Colors.blue,
    ),
    Goal(
      id: '2',
      title: 'Read Book',
      currentStreak: 14,
      longestStreak: 14,
      completedToday: true,
      color: Colors.green,
    ),
    Goal(
      id: '3',
      title: 'Meditation',
      currentStreak: 3,
      longestStreak: 5,
      completedToday: false,
      color: Colors.orange,
    ),
  ];

  String _searchQuery = '';

  List<Goal> get goals => _goals;
  String get searchQuery => _searchQuery;

  List<Goal> get filteredGoals {
    if (_searchQuery.isEmpty) return _goals;
    return _goals
        .where((goal) =>
            goal.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleGoalCompletion(String goalId) {
    final index = _goals.indexWhere((goal) => goal.id == goalId);
    if (index != -1) {
      final goal = _goals[index];
      _goals[index] = goal.copyWith(
        completedToday: !goal.completedToday,
        currentStreak:
            goal.completedToday ? goal.currentStreak : goal.currentStreak + 1,
        longestStreak: goal.completedToday
            ? goal.longestStreak
            : (goal.currentStreak + 1 > goal.longestStreak
                ? goal.currentStreak + 1
                : goal.longestStreak),
      );
      notifyListeners();
    }
  }

  void addNewGoal(Goal goal) {
    _goals.add(goal);
    notifyListeners();
  }
}
