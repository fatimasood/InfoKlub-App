import 'package:flutter/material.dart';
import 'package:infoklub/views/Rating/rating.dart';
import 'package:infoklub/views/authentecation_view/forgot_password.dart';
import 'package:infoklub/views/authentecation_view/phone_number_screen.dart';
import 'package:infoklub/views/authentecation_view/signup_screen.dart';
import 'package:infoklub/views/career_screens/finish_screen.dart';
import 'package:infoklub/views/create_profile/add_info_dashboard.dart';
import 'package:infoklub/views/create_profile/addlink.dart';
import 'package:infoklub/views/education_data/edu_info.dart';
import 'package:infoklub/views/health_screens/health_dashboard.dart';
import 'package:infoklub/views/health_screens/health_data.dart';
import '../views/career_screens/career_dashboard.dart';
import '../views/career_screens/career_data.dart';
import '../views/career_screens/carrer_all_info.dart';
import '../views/create_profile/profile_setup.dart';
import '../views/authentecation_view/login_screen.dart';
import '../views/education_data/edu_save.dart';
import '../views/education_data/education_dashboard.dart'
    show EducationDashboard;
import '../views/health_screens/mdcn_data.dart';
import '../views/onboarding_screens_view/onboarding_screen_one.dart';
import '../views/splash_view/splash_screens.dart';

class AppRoutes {
  static const String splash = '/';
  static const String profile = '/profile';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String phone = '/phone';

  static const String forgotpsd = '/forgotpsd';
  static const String onboardfirst = '/onboardfirst';
  static const String addlinks = '/addlinks';
  static const String infodashboard = '/infodashboard';
  static const String health = '/health';
  static const String mdcndata = '/mdcndata';
  static const String healthdboard = '/healthdboard';
  static const String eduData = '/eduData';
  static const String career = '/career';
  static const String eduSave = '/eduSave';
  static const String feedback = '/feedback';

  //dashboard
  static const String eduboard = '/eduboard';
  static const String careerdashboard = '/careerdashboard';
  static const String careerInfo = '/careerallinfo';
  static const String finishScreen = '/dataEnter';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreens());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileSetup());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case phone:
        return MaterialPageRoute(builder: (_) => const PhoneNumberScreen());

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
      case mdcndata:
        return MaterialPageRoute(builder: (_) => const MdcnData());
      case healthdboard:
        return MaterialPageRoute(builder: (_) => const HealthDashboard());
      case eduData:
        return MaterialPageRoute(builder: (_) => const EduInfo());

      case eduSave:
        return MaterialPageRoute(builder: (_) => const EduSave());
      case career:
        return MaterialPageRoute(builder: (_) => const CareerData());
      case eduboard:
        return MaterialPageRoute(builder: (_) => const EducationDashboard());
      case careerdashboard:
        return MaterialPageRoute(builder: (_) => const CareerDashboard());
      case careerInfo:
        return MaterialPageRoute(builder: (_) => const CarrerAllInfo());
      case finishScreen:
        return MaterialPageRoute(builder: (_) => const FinishScreen());
      case feedback:
        return MaterialPageRoute(builder: (_) => const RatingScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
