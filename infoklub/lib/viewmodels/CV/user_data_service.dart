// services/user_data_service.dart
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:infoklub/models/user/user_profile_model.dart';
import 'package:infoklub/models/education/education_model.dart';
import 'package:infoklub/models/career/career_model.dart';
import 'package:infoklub/services/firebase_services/auth_service.dart';
import 'package:infoklub/services/local_storage_services/hive_helpers.dart';

class UserDataService {
  // Get user profile data for currently logged-in user
  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final box = Hive.box('userBox');
      final String userKey = 'localUser_${AuthService.getCurrentUserKey()}';

      if (kDebugMode) {
        print('Looking for user profile with key: $userKey');
      }

      final dynamic userData = box.get(userKey);

      if (userData is UserProfileModel) {
        final jsonData = userData.toJson();
        if (kDebugMode) {
          print('User profile found: $jsonData');
        }
        return jsonData;
      } else if (userData is Map) {
        if (kDebugMode) {
          print('User data is in Map format, converting...');
        }
        return Map<String, dynamic>.from(userData);
      } else {
        if (kDebugMode) {
          print('User profile data not found for key: $userKey');

          final String altKey = 'localUser${AuthService.getCurrentUserKey()}';
          final dynamic altUserData = box.get(altKey);

          if (altUserData != null) {
            print('Found user data with alternative key: $altKey');
            if (altUserData is UserProfileModel) {
              return altUserData.toJson();
            } else if (altUserData is Map) {
              return Map<String, dynamic>.from(altUserData);
            }
          }
        }
        return {};
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error getting user profile: $e");
      }
      return {};
    }
  }

  // Get education data for currently logged-in user
  static Future<Map<String, dynamic>> getEducationInfo() async {
    try {
      final box = Hive.box('userBox');
      final String eduKey =
          'eduInfo_${AuthService.getCurrentUserEmail() ?? 'unknown'}';

      if (kDebugMode) {
        print('Looking for education data with key: $eduKey');
      }

      final dynamic educationData = box.get(eduKey);

      if (educationData == null) {
        print('No education data found for key: $eduKey');
        return {'educationHistory': []};
      }

      if (educationData is EducationInfo) {
        return educationData.toJson();
      } else if (educationData is List &&
          educationData.isNotEmpty &&
          educationData.first is EducationInfo) {
        // Handle case where it's stored as List<EducationInfo>
        final eduList = educationData as List<EducationInfo>;
        return {'educationHistory': eduList.map((e) => e.toJson()).toList()};
      } else if (educationData is Map) {
        return Map<String, dynamic>.from(educationData);
      } else {
        if (kDebugMode) {
          print('Education data not found for key: $eduKey');
        }
        return {'educationHistory': []};
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting education info: $e');
      }
      return {'educationHistory': []};
    }
  }

  // Get career data for currently logged-in user
  // Get career data for currently logged-in user
  static Future<Map<String, dynamic>> getCareerInfo() async {
    try {
      final String? userEmail = AuthService.getCurrentUserEmail();
      if (userEmail == null) {
        if (kDebugMode) {
          print('No user email found for career data');
        }
        return {'experiences': [], 'skills': []};
      }

      if (kDebugMode) {
        print('Looking for career data for email: $userEmail');
      }

      // Use HiveHelper to get the data from the correct box
      final List<CarrerModel> careerEntries =
          await HiveHelper.getAllCareerEntries(userEmail);

      if (kDebugMode) {
        print('Found ${careerEntries.length} career entries from HiveHelper');
      }

      // Convert the list of CarrerModel objects into a list of maps for the CV template
      List<Map<String, dynamic>> experiences = careerEntries.map((career) {
        return {
          'company': career.companyName,
          'position': career.jobTitle,
          'startDate': career.startDate,
          'endDate': career.endDate,
          'location': career.location,
          'description': career
              .skills, // Note: You are using 'skills' as description. Consider if you need a separate field.
        };
      }).toList();

      // Extract skills. This logic might need refinement.
      // Currently, it takes the 'skills' string from the most recent entry and splits by comma.
      // You might want to aggregate skills from all entries or manage them separately.
      List<String> allSkills = [];
      if (careerEntries.isNotEmpty) {
        // Example: Split the skills string from the latest entry
        String latestSkills = careerEntries.last.skills;
        allSkills =
            latestSkills.split(',').map((skill) => skill.trim()).toList();
      }

      return {
        'experiences': experiences,
        'skills': allSkills,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error getting career info from HiveHelper: $e');
      }
      return {'experiences': [], 'skills': []};
    }
  }

  // Get all user data for CV
  static Future<Map<String, dynamic>> getAllUserData() async {
    try {
      final userProfile = await getUserProfile();
      final educationInfo = await getEducationInfo();
      final careerInfo = await getCareerInfo();

      if (kDebugMode) {
        print('Loaded user profile: ${userProfile.isNotEmpty ? "YES" : "NO"}');
      }
      if (kDebugMode) {
        print(
            'Loaded education info: ${educationInfo["educationHistory"].length} items');
      }
      if (kDebugMode) {
        print(
            'Loaded career info: ${careerInfo["experiences"].length} experiences, ${careerInfo["skills"].length} skills');
      }

      return {
        'profile': userProfile,
        'education': educationInfo,
        'career': careerInfo,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error getting all user data: $e');
      }
      return {
        'profile': {},
        'education': {'educationHistory': []},
        'career': {'experiences': [], 'skills': []},
      };
    }
  }

  // Debug function
  static Future<void> debugHiveContents() async {
    try {
      final box = Hive.box('userBox');
      final allKeys = box.keys.toList();

      if (kDebugMode) {
        print('=== HIVE DEBUG INFO ===');
      }
      if (kDebugMode) {
        print('Current user: ${AuthService.getCurrentUserEmail()}');
      }
      if (kDebugMode) {
        print('Current user key: ${AuthService.getCurrentUserKey()}');
      }
      if (kDebugMode) {
        print('All keys in userBox: $allKeys');
      }

      for (var key in allKeys) {
        final value = box.get(key);
        if (kDebugMode) {
          print('Key: $key, Type: ${value.runtimeType}');
        }
      }
      if (kDebugMode) {
        print('=======================');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error debugging Hive: $e');
      }
    }
  }
}
