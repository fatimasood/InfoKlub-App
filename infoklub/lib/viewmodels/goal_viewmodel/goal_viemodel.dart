import 'package:flutter/foundation.dart';
import 'package:infoklub/models/goals/goal_model.dart';
import 'package:infoklub/services/local_storage_services/hive_helpers.dart';

class HomeViewModel with ChangeNotifier {
  List<Goal> _goals = [];
  String? _selectedGoalId;
  String _searchQuery = '';
  final String userEmail;

  List<Goal> get goals => _goals;
  List<Goal> get filteredGoals => _searchQuery.isEmpty
      ? _goals
      : _goals
          .where((goal) =>
              goal.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();

  String? get selectedGoalId => _selectedGoalId;

  HomeViewModel({required this.userEmail}) {
    loadGoals().then((_) {
      checkAndResetDailyStreaks();
    });
  }

  Future<void> loadGoals() async {
    try {
      _goals = await HiveHelper.getAllGoals(userEmail);

      // Ensure all goals have valid color values
      _goals = _goals.map((goal) {
        // If colorValue is invalid, create a new goal with default color
        // ignore: unnecessary_null_comparison
        if (goal.colorValue == null || goal.colorValue == 0) {
          return Goal.safe(
            id: goal.id,
            title: goal.title,
            description: goal.description,
            currentStreak: goal.currentStreak,
            longestStreak: goal.longestStreak,
            completedToday: goal.completedToday,
            startDate: goal.startDate,
            endDate: goal.endDate,
          );
        }
        return goal;
      }).toList();

      if (_goals.isEmpty) {
        _goals = [];
      } else {
        _goals.sort((a, b) => b.startDate.compareTo(a.startDate));
        _selectedGoalId = _goals.first.id;
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading goals: $e');
      }
      _goals = [];

      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> addNewGoal(Goal goal) async {
    try {
      await HiveHelper.saveGoal(userEmail, goal);
      _goals.add(goal);
      _goals.sort((a, b) => b.startDate.compareTo(a.startDate));

      // Select the new goal
      _selectedGoalId = goal.id;

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding goal: $e');
      }
    }
  }

  Future<void> toggleGoalCompletion(String goalId) async {
    try {
      final index = _goals.indexWhere((goal) => goal.id == goalId);
      if (index != -1) {
        final goal = _goals[index];
        final newCompletedState = !goal.completedToday;

        var updatedGoal = goal.copyWith(
          completedToday: newCompletedState,
          currentStreak: newCompletedState
              ? goal.currentStreak + 1
              : (goal.currentStreak > 0 ? goal.currentStreak - 1 : 0),
          lastUpdated: DateTime.now(), // Update the lastUpdated timestamp
        );

        // Update longest streak if needed
        if (updatedGoal.currentStreak > updatedGoal.longestStreak) {
          updatedGoal = updatedGoal.copyWith(
            longestStreak: updatedGoal.currentStreak,
          );
        }

        await HiveHelper.saveGoal(userEmail, updatedGoal);
        _goals[index] = updatedGoal;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling goal completion: $e');
      }
    }
  }

  Future<void> checkAndResetDailyStreaks() async {
    try {
      final now = DateTime.now();
      bool needsUpdate = false;

      for (int i = 0; i < _goals.length; i++) {
        final goal = _goals[i];
        // Use startDate as fallback if lastUpdated is null
        final lastUpdated = goal.lastUpdated ?? goal.startDate;
        // Check if it's a new day (after midnight)
        if (now.day != lastUpdated.day ||
            now.month != lastUpdated.month ||
            now.year != lastUpdated.year) {
          // Check if goal has ended (use null-aware operator)
          if (goal.endDate != null && now.isAfter(goal.endDate!)) {
            // Goal period has ended, delete it after 1 day
            if (now.isAfter(goal.endDate!.add(const Duration(days: 1)))) {
              await deleteGoal(goal.id);
              continue; // Skip to next goal as this one is deleted
            }
          } else {
            // Reset completedToday for the new day
            final updatedGoal = goal.copyWith(
              completedToday: false,
              lastUpdated: now,
            );

            await HiveHelper.saveGoal(userEmail, updatedGoal);
            _goals[i] = updatedGoal;
            needsUpdate = true;
          }
        }
      }

      if (needsUpdate) {
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error resetting daily streaks: $e');
      }
    }
  }

  Future<void> deleteGoal(String goalId) async {
    try {
      await HiveHelper.deleteGoal(userEmail, goalId);
      _goals.removeWhere((goal) => goal.id == goalId);

      // Update selected goal if needed
      if (_selectedGoalId == goalId) {
        _selectedGoalId = _goals.isNotEmpty ? _goals.first.id : null;
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting goal: $e');
      }
    }
  }

  void selectGoal(String goalId) {
    _selectedGoalId = goalId;
    notifyListeners();
  }

  // Clear all goals (for testing or account deletion)
  Future<void> clearAllGoals() async {
    try {
      await HiveHelper.clearAllGoals(userEmail);
      _goals = [];
      _selectedGoalId = null;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing goals: $e');
      }
    }
  }
}
