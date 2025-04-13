import 'package:flutter/material.dart';
import 'package:infoklub/models/goals/goal_model.dart';

class HomeViewModel extends ChangeNotifier {
  List<Goal> _goals = [];
  String? _selectedGoalId;
  String _searchQuery = '';

  List<Goal> get goals => _goals;
  List<Goal> get filteredGoals => _searchQuery.isEmpty
      ? _goals
      : _goals
          .where((goal) =>
              goal.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();

  String? get selectedGoalId => _selectedGoalId;

  HomeViewModel() {
    // Initialize with some dummy data
    _goals = [
      Goal(
        id: '1',
        title: 'Morning Run',
        currentStreak: 7,
        longestStreak: 10,
        completedToday: true,
        color: Colors.blue,
      ),
      Goal(
        id: '2',
        title: 'Meditation',
        currentStreak: 3,
        longestStreak: 5,
        completedToday: false,
        color: Colors.green,
      ),
      Goal(
        id: '3',
        title: 'Reading',
        currentStreak: 14,
        longestStreak: 14,
        completedToday: true,
        color: Colors.orange,
      ),
    ];

    // Select first goal by default
    if (_goals.isNotEmpty) {
      _selectedGoalId = _goals.first.id;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addNewGoal(Goal goal) {
    _goals.add(goal);
    notifyListeners();
  }

  void toggleGoalCompletion(String goalId) {
    final index = _goals.indexWhere((goal) => goal.id == goalId);
    if (index != -1) {
      _goals[index] = _goals[index].copyWith(
        completedToday: !_goals[index].completedToday,
        currentStreak: _goals[index].completedToday
            ? _goals[index].currentStreak - 1
            : _goals[index].currentStreak + 1,
      );
      notifyListeners();
    }
  }

  void selectGoal(String goalId) {
    _selectedGoalId = goalId;
    notifyListeners();
  }
}
