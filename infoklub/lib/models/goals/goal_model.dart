class GoalModel {
  final String title;
  final int streak;
  bool isCompletedToday;

  GoalModel({
    required this.title,
    required this.streak,
    this.isCompletedToday = false,
  });
}
