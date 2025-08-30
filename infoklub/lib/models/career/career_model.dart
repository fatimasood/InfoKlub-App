//user career model
import 'package:hive/hive.dart';
part 'career_model.g.dart';

@HiveType(typeId: 3)
class CarrerModel extends HiveObject {
  @HiveField(0)
  final String jobTitle;

  @HiveField(1)
  final String companyName;

  @HiveField(2)
  final String startDate;

  @HiveField(3)
  final String endDate;

  @HiveField(4)
  final String responsibilities;

  @HiveField(5)
  final String location;

  @HiveField(6)
  List<String> documentPaths;

  CarrerModel({
    required this.jobTitle,
    required this.companyName,
    required this.startDate,
    required this.endDate,
    required this.responsibilities,
    required this.location,
    required this.documentPaths,
  });
  Map<String, dynamic> toJson() {
    return {
      'jobTitle': jobTitle,
      'companyName': companyName,
      'startDate': startDate,
      'endDate': endDate,
      'responsibilities': responsibilities,
      'location': location,
      'documentPaths': documentPaths,
    };
  }
}
