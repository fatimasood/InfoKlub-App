import 'dart:io';
import 'package:flutter/foundation.dart';

class FinishprofileViewmodel with ChangeNotifier {
  File? _profileImage;
  String _name = 'Your Name';

  File? get profileImage => _profileImage;
  String get name => _name;

  void setProfileImage(File image) {
    _profileImage = image;
    notifyListeners();
  }

  void setName(String newName) {
    _name = newName;
    notifyListeners();
  }
}
