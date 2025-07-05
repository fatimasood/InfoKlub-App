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

  // for links

  @HiveField(9)
  String? behance;

  @HiveField(10)
  String? dribble;

  @HiveField(11)
  String? github;

  @HiveField(12)
  String? linkedin;

  @HiveField(13)
  String? website;

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
    this.behance,
    this.dribble,
    this.github,
    this.linkedin,
    this.website,
  });
}
// This model is used to store user profile information and links in Hive.
