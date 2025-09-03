import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:infoklub/models/career/career_model.dart';
import 'package:infoklub/models/goals/goal_model.dart';
import 'package:infoklub/models/reminder/reminder_model.dart';
import 'package:infoklub/services/firebase_services/splash_services.dart';
import 'package:infoklub/viewmodels/Reminders/reminders_viewmodel.dart';
import 'package:infoklub/viewmodels/carrer/career_viewmodel.dart';
import 'package:infoklub/views/splash_view/splash_screens.dart';
import 'package:provider/provider.dart';
import 'package:infoklub/app/routes.dart';
import 'package:infoklub/app/theme.dart';

// Models
import 'package:infoklub/models/user/user_profile_model.dart';
import 'package:infoklub/models/health/health_model.dart';
import 'package:infoklub/models/education/education_model.dart';

// ViewModels
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
import 'package:infoklub/viewmodels/profile_setup/link_add_viewmodel.dart';
import 'package:infoklub/viewmodels/profile_setup/profilesetup_viewmodel.dart';
import 'package:infoklub/viewmodels/rating/rating_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp();

  await Hive.initFlutter();
  await initHive();

  runApp(const MyApp());
}

Future<void> initHive() async {
  const secureStorage = FlutterSecureStorage();
  String? existingKey = await secureStorage.read(key: 'hiveKey');

  if (existingKey == null) {
    final key = Hive.generateSecureKey();
    await secureStorage.write(key: 'hiveKey', value: base64UrlEncode(key));
    existingKey = await secureStorage.read(key: 'hiveKey');
    if (kDebugMode) {
      print('🔐 Hive encryption key created and stored securely.');
    }
  }

  final encryptionKey = base64Url.decode(existingKey!);

  //  Delete the box to reset all stored values
  //await Hive.deleteBoxFromDisk('userBox');

  // Register adapters
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(UserProfileModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(HealthModelAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(EducationInfoAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(CarrerModelAdapter());
  }
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(ReminderModelAdapter());
  }

  if (!Hive.isAdapterRegistered(5)) {
    Hive.registerAdapter(GoalAdapter());
  }

  await Hive.openBox(
    'userBox',
    encryptionCipher: HiveAesCipher(encryptionKey),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashScreenViewModel()),
        ChangeNotifierProvider(create: (_) => AddLinkViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileSetupViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SignupViewmodel()),
        ChangeNotifierProvider(create: (_) => NavigationViewModel()),
        ChangeNotifierProvider(create: (_) => RatingViewModel()),
        ChangeNotifierProvider(create: (_) => PhoneViewmodel()),
        ChangeNotifierProvider(create: (_) => HealthDataViewModel()),
        ChangeNotifierProvider(create: (_) => MdcnDataViewModel()),
        ChangeNotifierProvider(create: (_) => EduinfoViewmodel()),
        ChangeNotifierProvider(create: (_) => FinishprofileViewmodel()),
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(userEmail: userMail),
        ),
        ChangeNotifierProvider(create: (_) => CvViewModel()),
        ChangeNotifierProvider(
            create: (_) => RemindersViewModel(userEmail: userMail)),
        ChangeNotifierProvider(
          create: (_) => CareerViewmodel(),
        ),
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
