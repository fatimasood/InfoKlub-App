import 'package:hive/hive.dart';

part 'reminder_model.g.dart';

@HiveType(typeId: 4)
class ReminderModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? notes;

  // Store date as UTC milliseconds since epoch, nullable
  @HiveField(3)
  int? dateUtcMs;

  // Store time as minutes since midnight, nullable
  @HiveField(4)
  int? timeMinutes;

  // isCompleted flag
  @HiveField(5)
  bool isCompleted;

  // Color stored as ARGB int, nullable
  @HiveField(6)
  int? colorValue;

  // repeat days as list of ints (0..6), nullable
  @HiveField(7)
  List<int>? repeatDays;

  ReminderModel({
    required this.id,
    required this.title,
    this.notes,
    this.dateUtcMs,
    this.timeMinutes,
    this.isCompleted = false,
    this.colorValue,
    this.repeatDays,
  });
}
