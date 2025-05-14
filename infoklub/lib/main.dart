import 'package:flutter/material.dart';
import 'package:infoklub/app/routes.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/viewmodels/CV/cv_creation_view_model.dart';
import 'package:infoklub/viewmodels/CV/cv_view_model.dart';
import 'package:infoklub/viewmodels/authentication/login_viewmodel.dart';
import 'package:infoklub/viewmodels/authentication/phone_viewmodel.dart';
import 'package:infoklub/viewmodels/authentication/signup_viewmodel.dart';
import 'package:infoklub/viewmodels/education/eduinfo_viewmodel.dart';
import 'package:infoklub/viewmodels/goal_viewmodel/goal_viemodel.dart';
import 'package:infoklub/viewmodels/health/healthdata_viewmodel.dart';
import 'package:infoklub/viewmodels/health/mdcn_viewmodel.dart';
import 'package:infoklub/viewmodels/nav_bar_models/navigation_viewmodel.dart';
import 'package:infoklub/viewmodels/profile_setup/finishprofile_viewmodel.dart';
import 'package:infoklub/viewmodels/rating/rating_viewmodel.dart';
import 'package:infoklub/viewmodels/splash_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

String? userMail;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashScreenViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SignupViewmodel()),
        ChangeNotifierProvider(create: (_) => NavigationViewModel()),
        ChangeNotifierProvider(create: (_) => RatingViewModel()),
        ChangeNotifierProvider(create: (_) => PhoneViewmodel()),
        ChangeNotifierProvider(create: (_) => HealthDataViewModel()),
        ChangeNotifierProvider(create: (_) => MdcnDataViewModel()),
        ChangeNotifierProvider(create: (_) => EduinfoViewmodel()),
        ChangeNotifierProvider(create: (_) => FinishprofileViewmodel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => CvViewModel()),
        ChangeNotifierProvider(create: (_) => CvCreationViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.getThemeData(context),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
