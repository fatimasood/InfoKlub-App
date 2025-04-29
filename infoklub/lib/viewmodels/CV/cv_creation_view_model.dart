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

  // Activities
  void addActivity({required String name, String description = ''}) {
    _cvData.activities.add(Activity(name: name, description: description));
    notifyListeners();
  }

  void removeActivity(Activity activity) {
    _cvData.activities.remove(activity);
    notifyListeners();
  }

  // Languages
  void addLanguage({required String language, required String level}) {
    _cvData.languages.add(Language(language: language, level: level));
    notifyListeners();
  }

  void removeLanguage(Language language) {
    _cvData.languages.remove(language);
    notifyListeners();
  }

  // Skills
  void addSkills(List<String> skills) {
    _cvData.skills.addAll(skills);
    notifyListeners();
  }

  void removeSkill(String skill) {
    _cvData.skills.remove(skill);
    notifyListeners();
  }

  // Certificates
  void addCertificate({required String name, String url = ''}) {
    _cvData.certificates.add(Certificate(name: name, url: url));
    notifyListeners();
  }

  void removeCertificate(Certificate certificate) {
    _cvData.certificates.remove(certificate);
    notifyListeners();
  }

  // Summary
  void updateSummary(String summary) {
    _cvData.summary = summary;
    notifyListeners();
  }

  void aActivity({required String name, required String description}) {}
}
