import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/viewmodels/splash_viewmodel.dart';
import 'package:provider/provider.dart';

class SplashScreens extends StatefulWidget {
  const SplashScreens({super.key});

  @override
  _SplashScreensState createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens>
    with SingleTickerProviderStateMixin {
  late SplashScreenViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SplashScreenViewModel();
    _viewModel.initializeAnimation(this);
    _viewModel.navigateAfterDelay(context);
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
              child: FadeTransition(
                opacity: viewModel.animation,
                child: Image.asset(
                  'lib/assets/Images/logo.png',
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.6,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
