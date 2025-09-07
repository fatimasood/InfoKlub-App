import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'goal_model.g.dart';

@HiveType(typeId: 5)
class Goal {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int currentStreak;

  @HiveField(4)
  final int longestStreak;

  @HiveField(5)
  final bool completedToday;

  @HiveField(6)
  final int colorValue;

  @HiveField(7)
  final DateTime startDate;

  @HiveField(8)
  final DateTime? endDate;

  @HiveField(9)
  final DateTime? lastUpdated;

  // Hive-compatible constructor
  Goal({
    required this.id,
    required this.title,
    this.description = '',
    required this.currentStreak,
    required this.longestStreak,
    required this.completedToday,
    required this.colorValue, // Use colorValue instead of Color
    required this.startDate,
    this.endDate,
    this.lastUpdated,
  });

  // Factory constructor for easy creation from Color
  factory Goal.fromColor({
    required String id,
    required String title,
    String description = '',
    required int currentStreak,
    required int longestStreak,
    required bool completedToday,
    required Color color,
    required DateTime startDate,
    DateTime? endDate,
    DateTime? lastUpdated,
  }) {
    return Goal(
      id: id,
      title: title,
      description: description,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      completedToday: completedToday,
      colorValue: color.value,
      startDate: startDate,
      endDate: endDate,
      lastUpdated: lastUpdated,
    );
  }

  // Getter to convert colorValue back to Color
  Color get color => Color(colorValue);

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
    DateTime? lastUpdated,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      completedToday: completedToday ?? this.completedToday,
      colorValue: color?.value ?? this.colorValue,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // Safe factory method for migration
  factory Goal.safe({
    String? id,
    required String title,
    String description = '',
    int currentStreak = 0,
    int longestStreak = 0,
    bool completedToday = false,
    Color? color,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? lastUpdated,
  }) {
    return Goal(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      completedToday: completedToday,
      colorValue: color?.value ?? Colors.blue.value,
      startDate: startDate ?? DateTime.now(),
      endDate: endDate ?? DateTime.now().add(const Duration(days: 30)),
      lastUpdated: lastUpdated,
    );
  }
}
