import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infoklub/viewmodels/finishprofile_viewmodel.dart';
import 'package:provider/provider.dart';

import '../app/routes.dart';

class ProfileSetupViewModel with ChangeNotifier {
  File? _selectedImage;
  String _selectedFlag = '🇧🇩';
  String _selectedCode = '880';

  File? get selectedImage => _selectedImage;
  String get selectedFlag => _selectedFlag;
  String get selectedCode => _selectedCode;

  Future<void> pickImage(BuildContext context) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick image: $e")),
      );
    }
  }

  void updateCountry(String flag, String code) {
    _selectedFlag = flag;
    _selectedCode = code;
    notifyListeners();
  }

  void navigateToNextScreen(BuildContext context) {
    // Save to provider if needed
    final profileProvider =
        Provider.of<FinishprofileViewmodel>(context, listen: false);
    if (_selectedImage != null) {
      profileProvider.setProfileImage(_selectedImage!);
    }

    Navigator.pushNamed(context, AppRoutes.addlinks);
  }
}
