import 'package:flutter/material.dart';
import 'package:infoklub/viewmodels/goals/goal_viemodel.dart';
import 'package:infoklub/views/Goals/goal_card_widget.dart';
import 'package:infoklub/widgets/search_bar.dart';
import 'package:provider/provider.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore your Goals"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchBarWidget(),

            // Scrollable Streak Summary (horizontal)
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 12),
                itemCount: goalProvider.goals.length,
                itemBuilder: (context, index) {
                  final goal = goalProvider.goals[index];
                  return Container(
                    width: 120,
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(goal.title,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('🔥 ${goal.streak} day streak'),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 10),

            // Goals List with Check option
            Expanded(
              child: ListView.builder(
                itemCount: goalProvider.goals.length,
                itemBuilder: (context, index) {
                  final goal = goalProvider.goals[index];
                  return GoalCard(
                    goal: goal,
                    onToggle: () => goalProvider.toggleGoalCompletion(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Add New Goal Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddGoalDialog(context, goalProvider);
        },
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context, GoalViewModel provider) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add New Goal"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter goal title"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              provider.addGoal(controller.text);
              Navigator.pop(context);
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }
}
