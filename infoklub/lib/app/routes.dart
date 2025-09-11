import 'package:flutter/material.dart';
import 'package:infoklub/views/authentecation_view/forgot_password.dart';
import 'package:infoklub/views/authentecation_view/signup_screen.dart';
import 'package:infoklub/views/career_screens/finish_screen.dart';
import 'package:infoklub/views/create_profile/add_info_dashboard.dart';
import 'package:infoklub/views/create_profile/addlink.dart';
import 'package:infoklub/views/education_data/edu_info.dart';
import 'package:infoklub/views/health_screens/health_data.dart';
import 'package:infoklub/views/settings/settings_screen.dart';
import '../views/career_screens/career_data.dart';
import '../views/career_screens/carrer_all_info.dart';
import '../views/create_profile/profile_setup.dart';
import '../views/authentecation_view/login_screen.dart';
import '../views/education_data/edu_save.dart';
import '../views/onboarding_screens_view/onboarding_screen_one.dart';
import '../views/splash_view/splash_screens.dart';

class AppRoutes {
  static const String splash = '/';
  static const String profile = '/profile';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotpsd = '/forgotpsd';
  static const String onboardfirst = '/onboardfirst';
  static const String addlinks = '/addlinks';
  static const String infodashboard = '/infodashboard';
  static const String health = '/health';
  static const String eduData = '/eduData';
  static const String career = '/career';
  static const String eduSave = '/eduSave';
  static const String careerInfo = '/careerallinfo';
  static const String finishScreen = '/dataEnter';
  static const String settingsApp = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case profile:
        return MaterialPageRoute(
            builder: (_) => const ProfileSetup(
                  initialName: '',
                  initialCode: '',
                  initialDob: '',
                  initialEmail: '',
                  initialFlag: '',
                  initialPhone: '',
                  initialLastName: '',
                ));
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case forgotpsd:
        return MaterialPageRoute(builder: (_) => const ForgotPassword());
      case onboardfirst:
        return MaterialPageRoute(builder: (_) => const OnboardOne());
      case addlinks:
        return MaterialPageRoute(builder: (_) => const Addlink());
      case infodashboard:
        return MaterialPageRoute(builder: (_) => const ProfileOptions());
      case health:
        return MaterialPageRoute(builder: (_) => const HealthData());

      case settingsApp:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case eduData:
        return MaterialPageRoute(
          builder: (_) => const EduInfo(
            degreeName: '',
            institutionName: '',
            totalGrade: '',
            scoreGrade: '',
            achievements: '',
            startYear: '',
            endYear: '',
          ),
        );

      case eduSave:
        return MaterialPageRoute(builder: (_) => const EduSave());
      case career:
        return MaterialPageRoute(builder: (_) => const CareerData());

      case careerInfo:
        return MaterialPageRoute(builder: (_) => const CarrerAllInfo());
      case finishScreen:
        return MaterialPageRoute(builder: (_) => const FinishScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
