import 'package:flutter/material.dart';
import '../../models/goals/goal_model.dart';

class GoalCard extends StatelessWidget {
  final GoalModel goal;
  final VoidCallback onToggle;

  const GoalCard({super.key, required this.goal, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: Text('${goal.streak}d', style: TextStyle(color: Colors.white)),
        ),
        title: Text(goal.title),
        trailing: Checkbox(
          shape: CircleBorder(),
          value: goal.isCompletedToday,
          onChanged: (_) => onToggle(),
        ),
      ),
    );
  }
}
