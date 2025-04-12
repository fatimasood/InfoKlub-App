import 'package:flutter/material.dart';

class Goal {
  final String id;
  final String title;
  final int currentStreak;
  final int longestStreak;
  final bool completedToday;
  final Color color;

  Goal({
    required this.id,
    required this.title,
    required this.currentStreak,
    required this.longestStreak,
    required this.completedToday,
    required this.color,
  });

  Goal copyWith({
    String? id,
    String? title,
    int? currentStreak,
    int? longestStreak,
    bool? completedToday,
    Color? color,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      completedToday: completedToday ?? this.completedToday,
      color: color ?? this.color,
    );
  }
}
