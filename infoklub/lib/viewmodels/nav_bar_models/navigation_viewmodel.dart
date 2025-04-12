import 'package:flutter/material.dart';

import '../../views/Record Screens/record_home_screen.dart';
import '../../views/homedata.dart';

class NavigationViewModel with ChangeNotifier {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  int get currentIndex => _currentIndex;
  PageController get pageController => _pageController;

  final List<Widget> pages = const [
    HomeContent(),
    RecordsPage(),
    CVPage(),
    SettingsPage(),
  ];

  final List<String> appBarTitles = const [
    "Home",
    "Record",
    "CV Builder",
    "Reminders"
  ];

  final List<Map<String, dynamic>> navItems = const [
    {'icon': Icons.home_outlined, 'label': 'Home'},
    {'icon': Icons.assignment_outlined, 'label': 'Record'},
    {'icon': Icons.description_outlined, 'label': 'CV Builder'},
    {'icon': Icons.notifications_outlined, 'label': 'Reminders'},
  ];

  void changePage(int index) {
    _currentIndex = index;
    _pageController.jumpToPage(index);
    notifyListeners();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
