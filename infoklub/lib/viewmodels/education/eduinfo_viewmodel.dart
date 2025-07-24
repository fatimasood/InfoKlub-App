import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:infoklub/models/education/education_model.dart';
import 'package:file_picker/file_picker.dart';

class EduinfoViewmodel extends ChangeNotifier {
  List<String> uploadedDocs = [];

  String degree = '';
  String institution = '';
  String totalGrade = '';
  String scoreGrade = '';
  String achievements = '';

  void degreeName(String val) => degree = val;
  void institutionName(String val) => institution = val;
  void totalGradeName(String val) => totalGrade = val;
  void scoreGradeName(String val) => scoreGrade = val;
  void achievementsName(String val) => achievements = val;

  /// Save new education info to the list associated with the user's email
  Future<void> saveEducationInfo(String email, EducationInfo info) async {
    final box = Hive.box('userBox');

    try {
      final rawList = box.get("eduInfo_$email", defaultValue: []);
      final List<EducationInfo> existingList =
          List<EducationInfo>.from(rawList);
      existingList.add(info);
      await box.put("eduInfo_$email", existingList);
    } catch (e) {
      print("❌ Hive saving error: $e");
      return;
    }

    uploadedDocs.clear();
    notifyListeners();

    final savedList = box.get("eduInfo_$email", defaultValue: []) as List;

    if (savedList.isEmpty) {
      print("📭 No education data found.");
      return;
    }

    for (int i = 0; i < savedList.length; i++) {
      final edu = savedList[i] as EducationInfo;
      print("🔍 Entry #$i:");
      print("🎓 Degree: ${edu.degree}");
      print("🏛️ Institution: ${edu.institution}");
      print("📊 Total Grade: ${edu.totalGrade}");
      print("📈 Score Grade: ${edu.scoreGrade}");
      print("🏆 Achievements: ${edu.achievements}");
      print("📂 Uploaded Docs: ${edu.uploadedDocs.join(', ')}");
      print("──────────────────────────────");
    }
  }

  List<EducationInfo> getAllEducationEntries(String email) {
    final box = Hive.box('userBox');
    final rawList = box.get("eduInfo_$email", defaultValue: []);
    return List<EducationInfo>.from(rawList);
  }

  Future<void> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    );

    if (result != null) {
      uploadedDocs.addAll(result.paths.whereType<String>());
      notifyListeners();
    }
  }

  void clearEduInfo() {
    uploadedDocs = [];
    notifyListeners();
  }
}
