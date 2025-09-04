import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/models/user/user_profile_model.dart';
import 'package:infoklub/services/firebase_services/auth_service.dart';
import 'package:infoklub/utils/utils.dart';
import 'package:infoklub/views/authentecation_view/login_screen.dart';
import 'package:provider/provider.dart';
import '../viewmodels/nav_bar_models/navigation_viewmodel.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  //logout
  Future<void> logoutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Logout successful - navigate to login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (kDebugMode) {
        print("Logout error: $e");
      }
      // Handle error if needed
      Utils().toastMessage("Logout failed. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NavigationViewModel>(context, listen: false);
    final screenWidth = MediaQuery.of(context).size.width;

    final userBox = Hive.box('userBox');
    final String userKey = 'localUser_${AuthService.getCurrentUserKey()}';
    final UserProfileModel? user = userBox.get(userKey);

    return SizedBox(
      width: screenWidth * 0.65, // Reduced width to 65% of screen
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        child: Drawer(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF03314B),
                  Color(0xFF021B29),
                ],
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 20.0),
                    children: [
                      DrawerHeader(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: user
                                          ?.profileImagePath.isNotEmpty ==
                                      true
                                  ? FileImage(File(user!.profileImagePath))
                                  : const NetworkImage(
                                          'https://avatar.iran.liara.run/public/girl')
                                      as ImageProvider,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              user?.name ?? 'Guest User',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user?.bio ?? 'No bio added',
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildDrawerItem(
                        icon: Icons.home_outlined,
                        title: 'Home',
                        isSelected: viewModel.currentIndex == 0,
                        onTap: () {
                          viewModel.changePage(0);
                          Navigator.pop(context);
                        },
                      ),
                      _buildDrawerItem(
                        icon: Icons.assignment_outlined,
                        title: 'Records',
                        isSelected: viewModel.currentIndex == 1,
                        onTap: () {
                          viewModel.changePage(1);
                          Navigator.pop(context);
                        },
                      ),
                      _buildDrawerItem(
                        icon: Icons.description_outlined,
                        title: 'CV',
                        isSelected: viewModel.currentIndex == 2,
                        onTap: () {
                          viewModel.changePage(2);
                          Navigator.pop(context);
                        },
                      ),
                      _buildDrawerItem(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        isSelected: viewModel.currentIndex == 3,
                        onTap: () {
                          viewModel.changePage(3);
                          Navigator.pop(context);
                        },
                      ),
                      _buildDrawerItem(
                        icon: Icons.feedback_outlined,
                        title: 'Feedback',
                        onTap: () {
                          //feedback
                          Navigator.pushNamed(context, '/feedback');
                        },
                      ),
                      _buildDrawerItem(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        onTap: () {
                          //move to settings screen
                        },
                      ),
                      _buildDrawerItem(
                        icon: Icons.logout_outlined,
                        title: 'Logout',
                        onTap: () {
                          logoutUser();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading:
          Icon(icon, color: isSelected ? Colors.white : AppTheme.halfwhite),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : AppTheme.halfwhite,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.white.withOpacity(0.1),
      onTap: onTap,
    );
  }
}
