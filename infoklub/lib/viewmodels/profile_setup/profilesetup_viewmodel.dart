import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infoklub/models/user/user_profile_model.dart';
import 'package:infoklub/services/firebase_services/auth_service.dart';
import 'package:infoklub/utils/utils.dart';
import 'package:infoklub/viewmodels/profile_setup/finishprofile_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../app/routes.dart';

class ProfileSetupViewModel with ChangeNotifier {
  // Image + Country Code
  File? _selectedImage;
  String _selectedFlag = '🇧🇩';
  String _selectedCode = '880';

  // Profile Fields
  String _name = '';
  bool _isEditingName = false;
  String _email = '';
  String _phone = '';
  String _dob = '';
  String _city = '';
  String _bio = '';

  // Getters
  File? get selectedImage => _selectedImage;
  String get selectedFlag => _selectedFlag;
  String get selectedCode => _selectedCode;
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get dob => _dob;
  bool get isEditingName => _isEditingName;

  // Setters
  void updateName(String newName, String initialLastName) {
    _name = newName;
    notifyListeners();
  }

  void toggleNameEdit() {
    _isEditingName = !_isEditingName;
    notifyListeners();
  }

  void updateEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void updatePhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  void updateDob(String dob) {
    _dob = dob;
    notifyListeners();
  }

  void updateCountry(String flag, String code) {
    _selectedFlag = flag;
    _selectedCode = code;
    notifyListeners();
  }

  void updateCity(String city) {
    _city = city;
    notifyListeners();
  }

  void updateBio(String bio) {
    _bio = bio;
    notifyListeners();
  }

  // Image Picker
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

  // Save Profile to Hive

  Future<void> saveProfileLocally() async {
    try {
      final box = Hive.box('userBox');
      final String userKey = 'localUser_${AuthService.getCurrentUserKey()}';

      final model = UserProfileModel(
        name: _name.trim(),
        email: _email.trim(),
        phone: '$_selectedCode $_phone'.trim(),
        dob: _dob.trim(),
        city: _city.trim(),
        bio: _bio.trim(),
        profileImagePath: _selectedImage?.path ?? '',
        flag: _selectedFlag,
        dialCode: _selectedCode,
      );

      await box.put(userKey, model);

      if (kDebugMode) {
        print('✅ Saved user profile with key: $userKey');
        print('✅ User data: ${model.toJson()}');
      }
    } catch (e) {
      print('❌ Error saving profile to Hive: $e');
    }
  }
  // validation check

  bool isProfileComplete() {
    return _name.trim().isNotEmpty &&
        _email.trim().isNotEmpty &&
        _phone.trim().isNotEmpty &&
        _dob.trim().isNotEmpty &&
        _city.trim().isNotEmpty &&
        _bio.trim().isNotEmpty &&
        _selectedImage != null;
  }

  // Navigate Next
  void navigateToNextScreen(BuildContext context) async {
    if (!isProfileComplete()) {
      Utils().toastMessage('All Fields are required');
      return;
    }
    final profileProvider =
        Provider.of<FinishprofileViewmodel>(context, listen: false);

    if (_selectedImage != null) {
      profileProvider.setProfileImage(_selectedImage!);
    }

    await saveProfileLocally();

    Navigator.pushNamed(context, AppRoutes.addlinks);
  }
}
