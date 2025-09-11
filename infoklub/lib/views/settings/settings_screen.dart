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
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          "Logout",
          style: TextStyle(
              color: AppTheme.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 22),
        ),
        content: const Text(
          "Do you really want to logout?",
          style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.normal,
              fontSize: 16),
        ),
        actions: [
          TextButton(
            child: const Text(
              "Cancel",
              style: TextStyle(
                  color: AppTheme.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              "Confirm",
              style: TextStyle(
                  color: AppTheme.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
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
        backgroundColor: AppTheme.redAccent,
        title: const Text(
          "Delete Account",
          style: TextStyle(
              color: AppTheme.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 22),
        ),
        content: const Text(
          "This action is permanent. All your documents and data will be deleted.",
          style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.normal,
              fontSize: 16),
        ),
        actions: [
          TextButton(
            child: const Text(
              "Cancel",
              style: TextStyle(
                  color: AppTheme.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              "Confirm",
              style: TextStyle(
                  color: AppTheme.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
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
        'subject': '',
        'body': '',
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Privacy Policy & Terms',
          style: TextStyle(color: AppTheme.primaryColor, fontSize: 20.0),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Privacy Policy Section
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 10),

            _buildSectionTitle('1. Information We Collect'),
            _buildSectionContent(
                'InfoKLub collects and stores your personal information including:\n'
                '• Personal details (name, contact information)\n'
                '• Educational background and qualifications\n'
                '• Career history and professional experience\n'
                '• Medical information (optional, at your discretion)\n'
                '• Documents you choose to upload\n'
                '• Goals and reminders you set within the app'
                '• Developer or owners cant see your info'),

            _buildSectionTitle('2. How We Use Your Information'),
            _buildSectionContent('Your information is used to:\n'
                '• Generate customized CVs based on your profile\n'
                '• Improve our services and user experience\n'
                '• Maintain your account and provide customer support'),

            _buildSectionTitle('3. Data Security'),
            _buildSectionContent('We take your privacy seriously:\n'
                '• All data is encrypted using encryption protocols\n'
                '• Your sensitive information is never shared without your consent\n'
                '• Regular security audits are conducted to maintain data protection standards'),

            _buildSectionTitle('4. Third-Party Services'),
            _buildSectionContent('InfoKLub uses third party libraries. '
                'These services have their own privacy policies governing data use.'),

            const SizedBox(height: 10),

            // Terms & Conditions Section
            const Text(
              'Terms & Conditions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 10),

            _buildSectionTitle('1. Account Responsibility'),
            _buildSectionContent('You are responsible for:\n'
                '• Maintaining the confidentiality of your account credentials\n'
                '• All activities that occur under your account\n'
                '• Information and documents you uploaded\n'
                '• Ensuring the accuracy of the information you provide'),

            _buildSectionTitle('2. Acceptable Use'),
            _buildSectionContent('You agree not to:\n'
                '• Use InfoKLub for any unlawful purpose\n'
                '• Upload sensitive information that violates others\' privacy\n'
                '• Attempt to compromise the security of the application\n'
                '• Use automated systems to access the service excessively'),

            _buildSectionTitle('3. CV Generation'),
            _buildSectionContent(
                'The CVs generated by InfoKLub are based on the information you provide. '
                'You are responsible for verifying the accuracy of generated documents '
                'before using them for official purposes.'),

            _buildSectionTitle('4. Service Modifications'),
            _buildSectionContent(
                'We reserve the right to modify or discontinue features of InfoKLub '
                'at any time without prior notice. We will notify users of significant '
                'changes that might affect their user experience.'),

            const SizedBox(height: 15),

            // Disclaimer Section
            const Text(
              'Important Disclaimer',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.redAccent,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: const Text(
                'While we have implemented robust security measures including encryption '
                'and secure storage practices, the user acknowledges that no system can '
                'be completely immune to breaches. Users utilize InfoKLub at their own risk '
                'and are advised to exercise caution when storing highly sensitive information.\n\n'
                'This application has been developed according to the owner\'s specifications '
                'and requirements. All features, including CV generation, document storage, '
                'and reminder systems, have been implemented as directed by the app owner.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.redAccent,
                  height: 1.4,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 20),

            // Contact Information
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'If you have any questions about our Privacy Policy or Terms & Conditions, '
              'please contact us at:',
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'therimon25@gmail.com',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 30),
            // Last Updated
            const Center(
              child: Text(
                'Last Updated: August, 2025',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(
              height: 2.0,
            ),
            const Center(
              child: Text(
                'Developed with 💙 by Eema.Dev',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 5),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 11,
          height: 1.4,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
