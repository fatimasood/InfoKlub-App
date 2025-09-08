import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/utils/utils.dart';
import 'package:infoklub/views/authentecation_view/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: AppTheme.primaryColor, fontSize: 23.0),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: AppTheme.primaryColor),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // --- GENERAL ---
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text("General",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),

          ListTile(
            leading:
                const Icon(Icons.notifications, color: AppTheme.tealAccent),
            title: const Text(
              "Notifications",
              style: TextStyle(color: AppTheme.blackColor, fontSize: 17.0),
            ),
            trailing: Transform.scale(
              scale: 0.7,
              child: Switch(
                value: notificationsEnabled,
                activeColor: AppTheme.secondaryColor,
                onChanged: (value) {
                  setState(() => notificationsEnabled = value);
                  // TODO: Save preference in local storage
                },
              ),
            ),
          ),

          const Divider(),

          // --- SUPPORT ---
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text("Support",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),

          ListTile(
            leading: const Icon(Icons.privacy_tip, color: AppTheme.coralAccent),
            title: const Text(
              "Privacy & Terms",
              style: TextStyle(color: AppTheme.blackColor, fontSize: 17.0),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen()),
              );
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.help, color: AppTheme.forestGreen),
            title: const Text(
              "Help & Support",
              style: TextStyle(color: AppTheme.blackColor, fontSize: 17.0),
            ),
            onTap: () => _contactSupport(),
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.star_rate, color: Colors.amber),
            title: const Text(
              "Rate Us",
              style: TextStyle(color: AppTheme.blackColor, fontSize: 17.0),
            ),
            subtitle: const Text("Help us improve the app"),
            onTap: () => _rateUs(),
          ),
          const Divider(),

          // --- ACCOUNT ---
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text("Account",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),

          ListTile(
            leading: const Icon(Icons.logout, color: AppTheme.secondaryColor),
            title: const Text(
              "Logout",
              style: TextStyle(color: AppTheme.blackColor, fontSize: 17.0),
            ),
            onTap: () => _showLogoutDialog(),
          ),
          const Divider(),

          ListTile(
            leading:
                const Icon(Icons.delete_forever, color: AppTheme.redAccent),
            title: const Text(
              "Delete Account",
              style: TextStyle(color: AppTheme.blackColor, fontSize: 17.0),
            ),
            subtitle: const Text("Permanently delete your account data"),
            onTap: () => _showDeleteDialog(),
          ),
        ],
      ),
    );
  }

  // ------------------ DIALOGS ------------------ //
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Do you really want to logout?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Confirm"),
            onPressed: () {
              Navigator.pop(context);
              logoutUser();
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
            "This action is permanent. All your documents and data will be deleted."),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Confirm"),
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
          ),
        ],
      ),
    );
  }

  // ------------------ FUNCTIONS ------------------ //
  Future<void> _deleteAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Clear local Hive data
        await Hive.deleteFromDisk();

        // Delete Firebase account
        await user.delete();

        // Sign out
        await FirebaseAuth.instance.signOut();

        Utils().toastMessage("Account deleted successfully.");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (kDebugMode) print("Error deleting account: $e");
      Utils().toastMessage("Error deleting your account.");
    }
  }

  Future<void> _contactSupport() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'thejuniordeve@gmail.com',
      queryParameters: {
        'subject': 'InfoKlub App Support Request',
        'body': 'Hello, I need help with...',
      },
    );

    if (!await launchUrl(emailUri, mode: LaunchMode.externalApplication)) {
      Utils().toastMessage("No email app found on this device.");
    }
  }

  Future<void> _rateUs() async {
    final Uri url = Uri.parse(
        "https://play.google.com/store/apps/details?id=com.example.infoklub"); // replace with real ID
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Utils().toastMessage("Could not open store.");
    }
  }

  Future<void> logoutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (kDebugMode) print("Logout error: $e");
      Utils().toastMessage("Logout failed. Please try again.");
    }
  }
}

// ------------------ PRIVACY POLICY SCREEN ------------------ //
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy & Terms"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            "Privacy Policy goes here...\n\n"
            "You can paste your policy draft here and style it later.",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
