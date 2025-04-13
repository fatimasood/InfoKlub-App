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
    final now = DateTime.now();
    _goals = [
      Goal(
        id: '1',
        title: 'Morning Run',
        description: 'Run for at least 30 minutes every morning',
        currentStreak: 7,
        longestStreak: 10,
        completedToday: true,
        color: Colors.blue,
        startDate: now.subtract(const Duration(days: 10)),
        endDate: now.add(const Duration(days: 20)),
      ),
      Goal(
        id: '2',
        title: 'Meditation',
        description: 'Meditate for 15 minutes daily',
        currentStreak: 3,
        longestStreak: 5,
        completedToday: false,
        color: Colors.green,
        startDate: now.subtract(const Duration(days: 5)),
        endDate: now.add(const Duration(days: 30)),
      ),
      Goal(
        id: '3',
        title: 'Reading',
        description: 'Read at least 20 pages every day',
        currentStreak: 14,
        longestStreak: 14,
        completedToday: true,
        color: Colors.orange,
        startDate: now.subtract(const Duration(days: 14)),
        endDate: now.add(const Duration(days: 45)),
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
