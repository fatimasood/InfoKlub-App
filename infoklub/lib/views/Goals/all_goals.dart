import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/models/goals/goal_model.dart';
import 'package:infoklub/viewmodels/goal_viewmodel/goal_viemodel.dart';
import 'package:infoklub/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: Scaffold(
        backgroundColor: AppTheme.halfwhite,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HeaderSection(),
                const SizedBox(height: 20),
                const _SearchBar(),
                const SizedBox(height: 20),
                const _StreaksSection(),
                const SizedBox(height: 20),
                CustomButton(
                  height: 50,
                  text: "Add New Goal",
                  textColor: Colors.white,
                  color: AppTheme.secondaryColor,
                  borderRadius: 10.0,
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: AppTheme.whiteColor,
                  ),
                  onPressed: () {
                    _showAddGoalDialog(context);
                  },
                ),
                const SizedBox(height: 20),
                const _GoalsList(),
              ],
            ),
          ),
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

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Explore your Goals',
      style: TextStyle(
        fontSize: 20,
        color: AppTheme.secondaryColor,
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
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: 'Search goals...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
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
          return GestureDetector(
            onTap: () => viewModel.selectGoal(goal.id),
            child: _StreakCard(
              goal: goal,
              isSelected: viewModel.selectedGoalId == goal.id,
            ),
          );
        },
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final Goal goal;
  final bool isSelected;

  const _StreakCard({required this.goal, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.secondaryColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              isSelected ? AppTheme.whiteColor : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            goal.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: isSelected ? Colors.white : AppTheme.secondaryColor,
            ),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${goal.currentStreak}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : AppTheme.secondaryColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '/ ${goal.longestStreak}',
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected
                      ? Colors.white.withOpacity(0.8)
                      : AppTheme.secondaryColor.withOpacity(0.6),
                ),
              ),
            ],
          ),
          Text(
            'Streak days',
            style: TextStyle(
              fontSize: 12,
              color: isSelected
                  ? Colors.white.withOpacity(0.8)
                  : AppTheme.secondaryColor.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalsList extends StatelessWidget {
  const _GoalsList();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListView.separated(
          padding: const EdgeInsets.all(8.0),
          itemCount: viewModel.filteredGoals.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.withOpacity(0.2),
          ),
          itemBuilder: (context, index) {
            final goal = viewModel.filteredGoals[index];
            return _GoalItem(goal: goal);
          },
        ),
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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
                  style: const TextStyle(
                    color: AppTheme.secondaryColor,
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
