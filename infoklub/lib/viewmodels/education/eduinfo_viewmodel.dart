import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infoklub/models/education/education_model.dart';

class EduinfoViewmodel extends ChangeNotifier {
  EducationInfo? _eduInfo;

  EducationInfo? get eduInfo => _eduInfo;

  late String userEmail;
  List<String> uploadedDocs = [];

  void initialize(String email) {
    userEmail = email;
  }

  void addDocumentPath(String path) {
    uploadedDocs.add(path);
    notifyListeners();
  }

  Future<void> pickDocument() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      uploadedDocs.add(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> captureWithCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      uploadedDocs.add(pickedImage.path);
      notifyListeners();
    }
  }

  Future<void> saveEducationInfo(String email, EducationInfo info) async {
    final box = Hive.box('userBox');
    await box.put("eduInfo_$email", info);
    _eduInfo = info;
    notifyListeners();
    printAllUserBoxData(); // just for debugging
  }

  Future<void> loadEducationInfo(String email) async {
    final box = Hive.box('userBox');
    _eduInfo = box.get("eduInfo_$email");
    notifyListeners();
  }

  void clearEducationInfo() {
    _eduInfo = null;
    notifyListeners();
  }

  void printAllUserBoxData() {
    final box = Hive.box('userBox');
    print("📚 Hive Box Data:");
    for (var key in box.keys) {
      print("🔑 $key => ${box.get(key)}");
    }
  }
}
