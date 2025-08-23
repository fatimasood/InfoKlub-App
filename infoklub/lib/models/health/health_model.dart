import 'package:hive/hive.dart';

part 'health_model.g.dart';

@HiveType(typeId: 1)
class HealthModel extends HiveObject {
  @HiveField(0)
  String bloodType;

  @HiveField(1)
  List<String> medications;

  @HiveField(2)
  List<String> documentPaths;

  @HiveField(3)
  List<String> allergies;

  HealthModel({
    required this.bloodType,
    required this.medications,
    required this.documentPaths,
    required this.allergies,
  });
  Map<String, dynamic> toJson() {
    return {
      'bloodType': bloodType,
      'medications': medications,
      'documentPaths': documentPaths,
      'allergies': allergies,
    };
  }
}
