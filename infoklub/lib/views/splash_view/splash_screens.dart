import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/services/firebase_services/splash_services.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final SplashScreenViewModel _viewModel;
  SplashServices splashScreen = SplashServices();
  @override
  void initState() {
    super.initState();
    _viewModel = SplashScreenViewModel();
    _viewModel.initializeAnimation(this);
    splashScreen.isLogin(context);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<SplashScreenViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: AppTheme.whiteColor,
            body: Center(
              child: AnimatedBuilder(
                animation: viewModel.animation,
                builder: (context, child) {
                  return Opacity(
                    opacity: viewModel.animation.value,
                    child: Image.asset(
                      'lib/assets/Images/logo.png',
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.6,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class SplashScreenViewModel extends ChangeNotifier {
  late final AnimationController controller;
  late final Animation<double> animation;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  void initializeAnimation(TickerProvider vsync) {
    if (_isInitialized) return;

    controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: vsync,
    );

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ),
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
        } else {
          // If animation isn't completed, wait for it to complete
          controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              Navigator.pushReplacementNamed(context, '/login');
            }
          });
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
