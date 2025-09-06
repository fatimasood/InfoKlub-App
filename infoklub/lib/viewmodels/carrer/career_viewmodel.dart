import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:infoklub/models/career/career_model.dart';
import 'package:infoklub/services/firebase_services/splash_services.dart';
import 'package:infoklub/services/local_storage_services/hive_helpers.dart';
import 'package:infoklub/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

class CareerViewmodel extends ChangeNotifier {
  bool isEditMode = false;

  void enableEditMode() {
    isEditMode = true;
    notifyListeners();
  }

  void disableEditMode() {
    isEditMode = false;
    notifyListeners();
  }

  List<String> uploadedDocs = [];

  void initialize(String email) {
    print("CareerViewmodel initialized for: $userMail");
  }

  String jobTitle = '';
  String companyName = '';
  String startDate = '';
  String endDate = '';
  String responsibilities = '';
  String location = '';

  // 🔥 Career entries list
  List<CarrerModel> careerList = [];

  // 👇 Add/Setters
  void jobTitleName(String val) => jobTitle = val;
  void company(String val) => companyName = val;
  void startDateName(String val) => startDate = val;
  void endDateName(String val) => endDate = val;
  void responsibilitiesName(String val) => responsibilities = val;
  void locationName(String val) => location = val;

  // 📂 Pick files
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

  // 📥 Save data
  Future<void> saveCareerInfo(String email, CarrerModel info) async {
    final box = await HiveHelper.openCareerBox(email);
    final existing = box.values.toList();

    try {
      await box.put(existing.length, info);
    } catch (e) {
      print("Error saving career info: $e");
      return;
    }

    await loadCareerList(); // 🔄 Refresh local list after save
    notifyListeners();

    print("✅ Career entry saved:");
    print("──────────────────────────────");
    print("Job Title: ${info.jobTitle}");
    print("Company: ${info.companyName}");
    print("Start: ${info.startDate}");
    print("End: ${info.endDate}");
    print("responsibilities: ${info.responsibilities}");
    print("Location: ${info.location}");
    print("Docs: ${info.documentPaths}");
    print("──────────────────────────────");
  }

  // 🔍 Return all entries (on demand)
  Future<List<CarrerModel>> getAllCareerEntries(String email) async {
    final box = await HiveHelper.openCareerBox(email);
    return box.values.toList();
  }

  // 🔥 Load & assign to internal list
  Future<void> loadCareerList() async {
    final box = await HiveHelper.openCareerBox(userMail);
    careerList = box.values.toList();
    notifyListeners();
    print("🔁 Loaded ${careerList.length} career entries for $userMail");
  }

  // ❌ Delete
  Future<void> deleteCareerInfoAt(String email, int index) async {
    final box = await HiveHelper.openCareerBox(email);

    try {
      if (index >= 0 && index < box.length) {
        await box.deleteAt(index);
        await loadCareerList(); // Refresh list after delete
        notifyListeners();
        print("Deleted career entry at index $index");
      } else {
        print("Invalid index: $index");
      }
    } catch (e) {
      print("Error deleting career info: $e");
    }
  }

  // 🔃 Load most recent for form prefill
  Future<void> loadCareerData(String email) async {
    final box = await HiveHelper.openCareerBox(email);
    final entries = box.values.toList();

    if (entries.isEmpty) {
      print("No career data found for $email");
      return;
    }

    try {
      final latest = entries.last;

      uploadedDocs = List<String>.from(latest.documentPaths);
      jobTitle = latest.jobTitle;
      companyName = latest.companyName;
      startDate = latest.startDate;
      endDate = latest.endDate;
      responsibilities = latest.responsibilities;
      location = latest.location;

      notifyListeners();
    } catch (e) {
      print("❌ Error loading career data: $e");
    }
  }

  bool hasData() {
    return jobTitle.isNotEmpty ||
        companyName.isNotEmpty ||
        startDate.isNotEmpty ||
        endDate.isNotEmpty ||
        responsibilities.isNotEmpty ||
        uploadedDocs.isNotEmpty;
  }

  // 🧹 Clear fields
  void clearCareerData() {
    jobTitle = '';
    companyName = '';
    startDate = '';
    endDate = '';
    responsibilities = '';
    location = '';
    uploadedDocs.clear();
    notifyListeners();
  }

  // download all career documents

  Future<void> downloadCareerDocs(BuildContext context) async {
    final box = await HiveHelper.openCareerBox(userMail);
    final entries = box.values.toList();

    if (entries.isEmpty) {
      Utils().toastMessage("No career docs found.");
      return;
    }

    final dir = await getExternalStorageDirectory();
    final downloadPath = "${dir!.path}/CareerDocs";
    await Directory(downloadPath).create(recursive: true);

    for (final entry in entries) {
      for (final path in entry.documentPaths) {
        final file = File(path);
        if (file.existsSync()) {
          final newFile =
              await file.copy("$downloadPath/${path.split('/').last}");
          debugPrint("Saved to ${newFile.path}");
        }
      }
    }

    Utils().toastMessage("All career docs downloaded in your device ");
  }

  void preloadDocsForEdit(int index) {
    if (index < careerList.length) {
      uploadedDocs = List<String>.from(careerList[index].documentPaths);
      notifyListeners();
    }
  }

  // update at index
  Future<void> loadCareerDataAt(String email, int index) async {
    final box = await HiveHelper.openCareerBox(email);
    final list = box.values.toList();

    if (list.isEmpty || index < 0 || index >= list.length) {
      print("⚠️ No career data found at index $index for $email");
      return;
    }

    try {
      final entry = list[index];
      uploadedDocs = List<String>.from(entry.documentPaths);
      companyName = entry.companyName;
      startDate = entry.startDate;
      endDate = entry.endDate;
      jobTitle = entry.jobTitle;
      responsibilities = entry.responsibilities;
      location = entry.location;
      notifyListeners();
    } catch (e) {
      print("❌ Error loading career data at index $index: $e");
    }
  }

  Future<void> updateCareerInfoAt(
      String email, int index, CarrerModel updatedInfo) async {
    final box = await HiveHelper.openCareerBox(email);
    try {
      if (index >= 0 && index < box.length) {
        await box.putAt(index, updatedInfo);
        await loadCareerList(); // refresh internal list

        notifyListeners();

        print("✅ Updated career entry at index $index");
      } else {
        print("⚠️ Invalid index: $index");
      }
    } catch (e) {
      print("❌ Error updating career info: $e");
    }
  }
}
