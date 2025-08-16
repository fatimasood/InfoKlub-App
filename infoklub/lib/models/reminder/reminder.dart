class Reminder {
  final String id;
  final String title;
  final String? notes;
  final DateTime? dateTime; // single DateTime for UI
  final bool isCompleted;
  final int? colorValue; // ARGB int; convert to Color in UI
  final List<int>? repeatDays; // 0=Sun ... 6=Sat
  final String userEmail; // scope by user

  Reminder({
    required this.id,
    required this.title,
    this.notes,
    this.dateTime,
    this.isCompleted = false,
    this.colorValue,
    this.repeatDays,
    required this.userEmail,
  });

  Reminder copyWith({
    String? title,
    String? notes,
    DateTime? dateTime,
    bool? isCompleted,
    int? colorValue,
    List<int>? repeatDays,
  }) {
    return Reminder(
      id: id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      dateTime: dateTime ?? this.dateTime,
      isCompleted: isCompleted ?? this.isCompleted,
      colorValue: colorValue ?? this.colorValue,
      repeatDays: repeatDays ?? this.repeatDays,
      userEmail: userEmail,
    );
  }
}
