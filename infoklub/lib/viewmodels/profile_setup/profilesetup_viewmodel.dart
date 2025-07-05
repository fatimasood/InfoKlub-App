import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infoklub/models/user_profile_model.dart';
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
    final box = await Hive.openBox<UserProfileModel>('userProfile');

    final model = UserProfileModel(
      name: _name,
      email: _email,
      phone: '+$_selectedCode $_phone',
      dob: _dob,
      city: _city,
      bio: _bio,
      profileImagePath: _selectedImage?.path ?? '',
      flag: _selectedFlag,
      dialCode: _selectedCode,
    );

    await box.put('localUser', model);
    print('Saved to Hive:');
    print('Name: ${model.name}');
    print('Email: ${model.email}');
    print('Phone: ${model.phone}');
    print('DOB: ${model.dob}');
    print('City: ${model.city}');
    print('Bio: ${model.bio}');
    print('Image Path: ${model.profileImagePath}');
    print('Flag: ${model.flag}');
    print('Dial Code: ${model.dialCode}');
  }

  // Navigate Next
  void navigateToNextScreen(BuildContext context) async {
    final profileProvider =
        Provider.of<FinishprofileViewmodel>(context, listen: false);

    if (_selectedImage != null) {
      profileProvider.setProfileImage(_selectedImage!);
    }

    await saveProfileLocally();

    Navigator.pushNamed(context, AppRoutes.addlinks);
  }
}
// This ViewModel handles the logic for setting up a user profile.
