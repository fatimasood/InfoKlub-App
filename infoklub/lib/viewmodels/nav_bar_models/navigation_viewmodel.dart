import 'package:flutter/material.dart';
import 'package:infoklub/views/CV/cv_main_screen.dart';
import 'package:infoklub/views/Reminders/reminders_home.dart';
import '../../views/Goals/all_goals.dart';
import '../../views/Record Screens/record_home_screen.dart';

class NavigationViewModel with ChangeNotifier {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  int get currentIndex => _currentIndex;
  PageController get pageController => _pageController;

  final List<Widget> pages = const [
    HomeScreen(),
    RecordsPage(),
    CVPage(),
    RemindersHome(),
  ];

  final List<String> appBarTitles = const [
    "Home",
    "Record",
    "Create CV",
    "Reminder"
  ];

  final List<Map<String, dynamic>> navItems = const [
    {'icon': Icons.home_outlined, 'label': 'Home'},
    {'icon': Icons.assignment_outlined, 'label': 'Record'},
    {'icon': Icons.description_outlined, 'label': 'CV Builder'},
    {'icon': Icons.alarm_outlined, 'label': 'Reminder'},
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
