import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:provider/provider.dart';
import '../viewmodels/nav_bar_models/navigation_viewmodel.dart';

class AppDrawer extends StatelessWidget {
  //final NavigationViewModel viewModel;

  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NavigationViewModel>(context, listen: false);
    final screenWidth = MediaQuery.of(context).size.width;

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
                      const DrawerHeader(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  'https://avatar.iran.liara.run/public/girl'),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Sophia Rose',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'UX/UI Designer',
                              style: TextStyle(
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
                          Navigator.pop(context);
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
