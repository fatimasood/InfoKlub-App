import 'dart:ui';

class Goal {
  final String id;
  final String title;
  final String description;
  final int currentStreak;
  final int longestStreak;
  final bool completedToday;
  final Color color;
  final DateTime startDate;
  final DateTime endDate;

  Goal({
    required this.id,
    required this.title,
    this.description = '',
    required this.currentStreak,
    required this.longestStreak,
    required this.completedToday,
    required this.color,
    required this.startDate,
    required this.endDate,
  });

  Goal copyWith({
    String? id,
    String? title,
    String? description,
    int? currentStreak,
    int? longestStreak,
    bool? completedToday,
    Color? color,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      completedToday: completedToday ?? this.completedToday,
      color: color ?? this.color,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
