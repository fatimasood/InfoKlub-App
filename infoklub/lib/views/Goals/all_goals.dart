// home_screen.dart
import 'package:flutter/material.dart';
import 'package:infoklub/models/goals/goal_model.dart';
import 'package:infoklub/viewmodels/goal_viewmodel/goal_viemodel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HeaderSection(),
                const SizedBox(height: 20),
                const _SearchBar(),
                const SizedBox(height: 20),
                const _StreaksSection(),
                const SizedBox(height: 20),
                const _AddGoalButton(),
                const SizedBox(height: 20),
                const _GoalsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Explore your Goals',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return TextField(
      decoration: InputDecoration(
        hintText: 'Search goals...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      ),
      onChanged: viewModel.setSearchQuery,
    );
  }
}

class _StreaksSection extends StatelessWidget {
  const _StreaksSection();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: viewModel.goals.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final goal = viewModel.goals[index];
          return _StreakCard(goal: goal);
        },
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final Goal goal;

  const _StreakCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: goal.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: goal.color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            goal.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: goal.color,
            ),
          ),
          const Spacer(),
          Text(
            'Current: ${goal.currentStreak} days',
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            'Longest: ${goal.longestStreak} days',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _AddGoalButton extends StatelessWidget {
  const _AddGoalButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Implement add new goal functionality
        _showAddGoalDialog(context);
      },
      icon: const Icon(Icons.add),
      label: const Text('Add New Goal'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Goal'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter goal name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  final newGoal = Goal(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: controller.text,
                    currentStreak: 0,
                    longestStreak: 0,
                    completedToday: false,
                    color: Colors.primaries[
                        viewModel.goals.length % Colors.primaries.length],
                  );
                  viewModel.addNewGoal(newGoal);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class _GoalsList extends StatelessWidget {
  const _GoalsList();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return Expanded(
      child: ListView.separated(
        itemCount: viewModel.filteredGoals.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final goal = viewModel.filteredGoals[index];
          return _GoalItem(goal: goal);
        },
      ),
    );
  }
}

class _GoalItem extends StatelessWidget {
  final Goal goal;

  const _GoalItem({required this.goal});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Current streak: ${goal.currentStreak} days',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => viewModel.toggleGoalCompletion(goal.id),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: goal.completedToday ? goal.color : Colors.transparent,
                border: Border.all(
                  color: goal.completedToday ? goal.color : Colors.grey,
                  width: 2,
                ),
              ),
              child: goal.completedToday
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
