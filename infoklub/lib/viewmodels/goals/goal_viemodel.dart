import 'package:flutter/material.dart';
import '../../models/goals/goal_model.dart';

class GoalViewModel with ChangeNotifier {
  final List<GoalModel> _goals = [
    GoalModel(title: "Read Book", streak: 5),
    GoalModel(title: "Workout", streak: 3),
    GoalModel(title: "Meditation", streak: 7),
  ];

  List<GoalModel> get goals => _goals;

  void toggleGoalCompletion(int index) {
    _goals[index].isCompletedToday = !_goals[index].isCompletedToday;
    notifyListeners();
  }

  void addGoal(String title) {
    _goals.add(GoalModel(title: title, streak: 0));
    notifyListeners();
  }
}
