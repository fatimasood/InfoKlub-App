import 'package:flutter/material.dart';

class Reminder {
  final String id;
  final String title;
  final String? notes;
  final DateTime? date;
  final TimeOfDay? time;
  final bool isCompleted;
  final Color? color;
  final List<int>? repeatDays; // 0=Sunday, 1=Monday,...6=Saturday

  Reminder({
    required this.id,
    required this.title,
    this.notes,
    this.date,
    this.time,
    this.isCompleted = false,
    this.color,
    this.repeatDays,
  });

  Reminder copyWith({
    String? title,
    String? notes,
    DateTime? date,
    TimeOfDay? time,
    bool? isCompleted,
    Color? color,
    List<int>? repeatDays,
  }) {
    return Reminder(
      id: id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      date: date ?? this.date,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
      color: color ?? this.color,
      repeatDays: repeatDays ?? this.repeatDays,
    );
  }
}
