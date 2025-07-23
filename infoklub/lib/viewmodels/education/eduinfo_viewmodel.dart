import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:infoklub/models/education/education_model.dart';

class EduinfoViewmodel extends ChangeNotifier {
  EducationInfo? _eduInfo;

  EducationInfo? get eduInfo => _eduInfo;

  Future<void> saveEducationInfo(String email, EducationInfo info) async {
    final box = Hive.box('userBox');
    await box.put("eduInfo_$email", info);
    _eduInfo = info;
    notifyListeners();
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
}
