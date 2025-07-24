import 'package:hive/hive.dart';
part 'education_model.g.dart';

@HiveType(typeId: 2)
class EducationInfo extends HiveObject {
  @HiveField(0)
  final String degree;

  @HiveField(1)
  final String institution;

  @HiveField(2)
  final String totalGrade;

  @HiveField(3)
  final String scoreGrade;

  @HiveField(4)
  final String achievements;

  @HiveField(5)
  final List<String> uploadedDocs;

  EducationInfo({
    required this.degree,
    required this.institution,
    required this.totalGrade,
    required this.scoreGrade,
    required this.achievements,
    required this.uploadedDocs,
  });
}
