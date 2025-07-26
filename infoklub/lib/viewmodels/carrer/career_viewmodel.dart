import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infoklub/models/career/career_model.dart';
import 'package:infoklub/services/local_storage_services/hive_helpers.dart';

class CareerViewmodel extends ChangeNotifier {
  List<String> uploadedDocs = [];
  late String userEmail;

  String jobTitle = '';
  String companyName = '';
  String startDate = '';
  String endDate = '';
  String skills = '';
  String location = '';

  void initialize(String email) {
    userEmail = email;
  }

  void jobTitleName(String val) => jobTitle = val;
  void company(String val) => companyName = val;
  void startDateName(String val) => startDate = val;
  void endDateName(String val) => endDate = val;
  void skillsName(String val) => skills = val;
  void locationName(String val) => location = val;

  //for document upload

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

  // check if career data exists
  bool hasData() {
    return jobTitle.isNotEmpty ||
        companyName.isNotEmpty ||
        startDate.isNotEmpty ||
        endDate.isNotEmpty ||
        skills.isNotEmpty ||
        uploadedDocs.isNotEmpty;
  }

  //save career data to Hive
  Future<void> saveCareerData() async {
    final box = await HiveHelper.openCareerBox(userEmail);
    final careerData = CarrerModel(
      jobTitle: jobTitle,
      companyName: companyName,
      startDate: startDate,
      endDate: endDate,
      skills: skills,
      location: location,
      documentPaths: List.from(uploadedDocs),
    );
    await box.put('user_career', careerData);

    if (kDebugMode) {
      print("✅ Saved Career Record:");
    }
    if (kDebugMode) {
      print("──────────────────────────────");
      print("Job Title: $jobTitle");
      print("Company Name: $companyName");
      print("Start Date: $startDate");
      print("End Date: $endDate");
      print("Skills: $skills");
      print("Location: $location");
      print("Documents: ${careerData.documentPaths}");
      print("──────────────────────────────");
    }
  }
}
