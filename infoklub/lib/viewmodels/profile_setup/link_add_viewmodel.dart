import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/user_profile_model.dart';

class AddLinkViewModel extends ChangeNotifier {
  final TextEditingController behanceController = TextEditingController();
  final TextEditingController dribbbleController = TextEditingController();
  final TextEditingController githubController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();

  bool validateUrls() {
    List<String> links = [
      behanceController.text,
      dribbbleController.text,
      githubController.text,
      linkedinController.text,
      websiteController.text,
    ];

    final urlPattern = RegExp(r'^https?:\/\/[\w\-\.]+\.\w+');

    bool hasAtLeastOne = links.any((link) => link.trim().isNotEmpty);
    bool allValid = links.every(
        (link) => link.trim().isEmpty || urlPattern.hasMatch(link.trim()));

    return hasAtLeastOne && allValid;
  }

  Future<bool> saveLinksToHive() async {
    final box = await Hive.openBox<UserProfileModel>('userProfile');
    final user = box.get('localUser');

    if (user != null) {
      user.behance = behanceController.text.trim();
      user.dribble = dribbbleController.text.trim();
      user.github = githubController.text.trim();
      user.linkedin = linkedinController.text.trim();
      user.website = websiteController.text.trim();
      await user.save();
      debugPrint("✅ Links saved successfully to Hive");
      return true;
    } else {
      debugPrint("❌ User profile not found in Hive.");
      return false;
    }
  }
}
