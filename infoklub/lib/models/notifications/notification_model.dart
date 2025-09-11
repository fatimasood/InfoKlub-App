import 'package:hive/hive.dart';
part 'notification_model.g.dart';

@HiveType(typeId: 9)
class NotificationModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String message;

  @HiveField(2)
  DateTime time;

  NotificationModel({
    required this.title,
    required this.message,
    required this.time,
  });
}
