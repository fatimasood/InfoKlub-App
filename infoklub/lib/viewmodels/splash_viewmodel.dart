import 'package:flutter/material.dart';

class SplashScreenViewModel extends ChangeNotifier {
  late AnimationController controller;
  late Animation<double> animation;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  void initializeAnimation(TickerProvider vsync) {
    if (_isInitialized) return;

    controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: vsync,
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );

    controller.forward();
    _isInitialized = true;
  }

  void navigateAfterDelay(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 7),
      () {
        if (controller.isCompleted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
