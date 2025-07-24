import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:infoklub/models/education/education_model.dart';
import 'package:file_picker/file_picker.dart';

class EduinfoViewmodel extends ChangeNotifier {
  List<String> uploadedDocs = [];
  EducationInfo? _eduInfo;

  EducationInfo? get eduInfo => _eduInfo;

  /// Save new education info to the list associated with the user's email
  Future<void> saveEducationInfo(String email, EducationInfo info) async {
    final box = Hive.box('userBox');

    final existingList = box.get("eduInfo_$email",
            defaultValue: <EducationInfo>[])?.cast<EducationInfo>() ??
        [];

    existingList.add(info);

    await box.put("eduInfo_$email", existingList);
    _eduInfo = null; // Clear after save
    uploadedDocs.clear();
    notifyListeners();
  }

  /// Get all education info entries for the user
  List<EducationInfo> getAllEducationEntries(String email) {
    final box = Hive.box('userBox');
    return box.get("eduInfo_$email",
            defaultValue: <EducationInfo>[])?.cast<EducationInfo>() ??
        [];
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

  /// Delete a specific entry at the given index
  Future<void> deleteEducationInfoAt(String email, int index) async {
    final box = Hive.box('userBox');
    final existingList = box.get("eduInfo_$email",
            defaultValue: <EducationInfo>[])?.cast<EducationInfo>() ??
        [];

    if (index < existingList.length) {
      existingList.removeAt(index);
      await box.put("eduInfo_$email", existingList);
      notifyListeners();
    }
  }

  /// For testing or UI resets
  void clearEduInfo() {
    _eduInfo = null;
    uploadedDocs.clear();
    notifyListeners();
  }
}
