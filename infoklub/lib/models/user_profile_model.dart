import 'package:hive/hive.dart';

part 'user_profile_model.g.dart';

@HiveType(typeId: 0)
class UserProfileModel extends HiveObject {
  @HiveField(0)
  String email;

  @HiveField(1)
  String phone;

  @HiveField(2)
  String dob;

  @HiveField(3)
  String city;

  @HiveField(4)
  String bio;

  @HiveField(5)
  String profileImagePath;

  @HiveField(6)
  String flag;

  @HiveField(7)
  String dialCode;

  @HiveField(8)
  String name;

  UserProfileModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.dob,
    required this.city,
    required this.bio,
    required this.profileImagePath,
    required this.flag,
    required this.dialCode,
  });
}
// This model is used to store user profile information in Hive.
// It includes fields for email, phone number, date of birth, city, bio, profile
