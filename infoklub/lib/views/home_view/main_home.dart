import 'package:flutter/material.dart';
import 'package:infoklub/viewmodels/nav_bar_models/navigation_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:infoklub/app/theme.dart';

import '../../widgets/app_drawer.dart';

class MainHome extends StatelessWidget {
  const MainHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.halfwhite,
      appBar: AppBar(
        backgroundColor: AppTheme.halfwhite,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Consumer<NavigationViewModel>(
          builder: (context, viewModel, child) {
            return Text(
              viewModel.appBarTitles[viewModel.currentIndex],
              style: const TextStyle(color: Colors.black),
            );
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage:
                  NetworkImage('https://avatar.iran.liara.run/public/girl'),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Consumer<NavigationViewModel>(
        builder: (context, viewModel, child) {
          return PageView(
            controller: viewModel.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: viewModel.pages,
            onPageChanged: (index) {
              viewModel.changePage(index);
            },
          );
        },
      ),
      bottomNavigationBar: Consumer<NavigationViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: const EdgeInsets.all(22.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  viewModel.navItems.length,
                  (index) => _NavItem(
                    icon: viewModel.navItems[index]['icon'] as IconData,
                    label: viewModel.navItems[index]['label'] as String,
                    isActive: viewModel.currentIndex == index,
                    onTap: () => viewModel.changePage(index),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.secondaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: isActive
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : Icon(icon, color: const Color(0xff9DB2CE), size: 24),
      ),
    );
  }
}
