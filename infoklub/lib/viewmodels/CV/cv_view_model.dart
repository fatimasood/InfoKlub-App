import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:infoklub/models/cv/cv_creation_view_model.dart';
import 'package:infoklub/viewmodels/CV/user_data_service.dart';

class CvViewModel extends ChangeNotifier {
  CVModel _cvData = CVModel.empty();
  bool _isLoading = false;
  String? _error;

  CVModel get cvData => _cvData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUserDataForCV() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // First debug what's in Hive
      await UserDataService.debugHiveContents();

      final userData = await UserDataService.getAllUserData();
      _populateCVData(userData);
    } catch (e) {
      _error = 'Failed to load user data: $e';
      if (kDebugMode) {
        print(_error);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _loadProfileImage(String? imagePath) {
    if (imagePath != null && imagePath.isNotEmpty) {
      try {
        _cvData = _cvData.copyWith(profileImage: File(imagePath));
      } catch (e) {
        if (kDebugMode) {
          print('Error loading profile image: $e');
        }
      }
    }
  }

  void _populateCVData(Map<String, dynamic> userData) {
    try {
      if (kDebugMode) {
        print('Populating CV data with: $userData');
      }

      final profile = userData['profile'] ?? {};
      final education = userData['education'] ?? {};
      final career = userData['career'] ?? {};

      if (kDebugMode) {
        print('Profile data: $profile');
      }
      if (kDebugMode) {
        print('Education data: $education');
      }
      if (kDebugMode) {
        print('Career data: $career');
      }

      if (profile.isEmpty) {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          profile['email'] = currentUser.email;
          profile['name'] = currentUser.displayName ??
              currentUser.email?.split('@').first ??
              '';
        }
      }

      // Extract name properly
      final String fullName = profile['name']?.toString() ?? '';
      if (kDebugMode) {
        print('Full name from profile: $fullName');
      }
      // Better name parsing logic
      Map<String, String> parsedName = _parseName(fullName);
      // Extract phone number (remove country code if present)
      String phone = profile['phone']?.toString() ?? '';

      if (kDebugMode) {
        print('Original phone: $phone');
      }

      // Personal Info with null checks
      _cvData = _cvData.copyWith(
        firstName: parsedName['firstName'] ?? '',
        lastName: parsedName['lastName'] ?? '',
        email: profile['email']?.toString() ?? '',
        phone: phone,
        address: profile['city']?.toString() ?? '',
      );

      if (kDebugMode) {
        print(
            'Parsed name - First: "${_cvData.firstName}", Last: "${_cvData.lastName}"');
      }
      if (kDebugMode) {
        print('Phone: "${_cvData.phone}", Address: "${_cvData.address}"');
      }
      // Load profile image
      _loadProfileImage(profile['profileImagePath']?.toString());

      // Education with null checks
      final educationHistory = education['educationHistory'] as List? ?? [];
      if (kDebugMode) {
        print('Education history length: ${educationHistory.length}');
      }

      final eduList = educationHistory.map((edu) {
        return Education(
          institution: edu['institution']?.toString() ?? '',
          degree: edu['degree']?.toString() ?? '',
          year: edu['year']?.toString() ?? '',
          fieldOfStudy: edu['field']?.toString() ?? '',
        );
      }).toList();

      _cvData = _cvData.copyWith(education: eduList);

      // Work Experience with null checks
      final experiences = career['experiences'] as List? ?? [];
      if (kDebugMode) {
        print(
            'Number of career experiences loaded for CV: ${experiences.length}');
      }

      final expList = experiences.map((exp) {
        return WorkExperience(
          company: exp['company']?.toString() ?? '',
          position: exp['position']?.toString() ?? '',
          duration:
              '${exp['startDate'] ?? ''} - ${exp['endDate'] ?? 'Present'}',
          location: exp['location']?.toString(),
          description: exp['description']?.toString(),
        );
      }).toList();

      _cvData = _cvData.copyWith(workExperience: expList);

      // Skills with null checks
      final skills = career['skills'] as List? ?? [];
      if (kDebugMode) {
        print('Skills length: ${skills.length}');
      }

      _cvData = _cvData.copyWith(skills: List<String>.from(skills));

      if (kDebugMode) {
        print('Final CV Data populated successfully');
      }
      notifyListeners();
    } catch (e) {
      _error = 'Error populating CV data: $e';
      if (kDebugMode) {
        print(_error);
      }
    }
  }

  /* String _getFirstName(String fullName) {
    if (fullName.isEmpty) return '';
    return fullName.split(' ').first;
  }

  String _getLastName(String fullName) {
    if (fullName.isEmpty) return '';
    final parts = fullName.split(' ');
    return parts.length > 1 ? parts.sublist(1).join(' ') : '';
  } */

  void updateCVData(CVModel newData) {
    _cvData = newData;
    notifyListeners();
  }

  void createNewCV() {
    _cvData = CVModel.empty();
    loadUserDataForCV();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Map<String, String> _parseName(String fullName) {
    if (fullName.isEmpty) return {'firstName': '', 'lastName': ''};

    final nameParts = fullName.trim().split(' ');

    if (nameParts.length == 1) {
      return {'firstName': nameParts[0], 'lastName': ''};
    }

    // Handle cases like "Zahra Noor" or "ZahraNoor"
    if (nameParts.length >= 2) {
      // Check if it's actually one word (like "ZahraNoor")
      if (nameParts.length == 1 && fullName.contains(RegExp(r'[a-z][A-Z]'))) {
        // CamelCase detection like "ZahraNoor"
        final match = RegExp(r'([a-z])([A-Z])').firstMatch(fullName);
        if (match != null) {
          final index = match.start + 1;
          return {
            'firstName': fullName.substring(0, index),
            'lastName': fullName.substring(index)
          };
        }
      }

      // Regular space-separated names
      return {
        'firstName': nameParts.first,
        'lastName': nameParts.sublist(1).join(' ')
      };
    }

    return {'firstName': fullName, 'lastName': ''};
  }
}
