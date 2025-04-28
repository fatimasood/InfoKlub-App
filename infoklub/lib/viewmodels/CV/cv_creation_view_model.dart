import 'package:flutter/material.dart';
import 'package:infoklub/models/cv/cv_creation_view_model.dart';

class CvCreationViewModel extends ChangeNotifier {
  int _currentStep = 0;
  final CVModel _cvData = CVModel.empty();

  int get currentStep => _currentStep;
  CVModel get cvData => _cvData;

  void nextStep() {
    if (_currentStep < 4) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  // Contact Info
  void updateContactInfo({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
  }) {
    _cvData.firstName = firstName ?? _cvData.firstName;
    _cvData.lastName = lastName ?? _cvData.lastName;
    _cvData.email = email ?? _cvData.email;
    _cvData.phone = phone ?? _cvData.phone;
    _cvData.address = address ?? _cvData.address;
    notifyListeners();
  }

  // Work Experience
  void addWorkExperience({
    required String company,
    required String position,
    required String duration,
    String? location,
    String? description,
  }) {
    _cvData.workExperience.add(WorkExperience(
      company: company,
      position: position,
      duration: duration,
    ));
    notifyListeners();
  }

  // Education
  void addEducation({
    required String institution,
    required String degree,
    required String year,
  }) {
    _cvData.education.add(Education(
      institution: institution,
      degree: degree,
      year: year,
    ));
    notifyListeners();
  }
}
