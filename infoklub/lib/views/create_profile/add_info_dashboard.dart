import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/main.dart';
import 'package:infoklub/viewmodels/health/healthdata_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../app/routes.dart';
import '../../widgets/custom_card.dart';

class ProfileOptions extends StatefulWidget {
  const ProfileOptions({super.key});

  @override
  State<ProfileOptions> createState() => _ProfileOptionsState();
}

class _ProfileOptionsState extends State<ProfileOptions> {
  // Flags to track data completion
  bool healthCompleted = false;
  bool educationCompleted = false;
  bool careerCompleted = false;

  @override
  void initState() {
    super.initState();
    _checkCompletionStatus(userMail);
  }

  Future<void> _checkCompletionStatus(String email) async {
    final healthVM = Provider.of<HealthDataViewModel>(context,
        listen:
            false); //final eduVM = Provider.of<Education>(context, listen: false);
    //final careerVM = Provider.of<CareerViewModel>(context, listen: false);
    healthVM.initialize(email);
    await healthVM.loadHealthData(); //load from HIve

    setState(() {
      healthCompleted = healthVM.hasData(); // true if data exists
    });
  }

  double get progress {
    int completed = 0;
    if (healthCompleted) completed++;
    if (educationCompleted) completed++;
    if (careerCompleted) completed++;
    return completed / 3;
  }

  String get progressText {
    if (progress == 0) return "Complete your Profile";
    if (progress == 1) return "Profile Completed!";
    return "${(progress * 100).toInt()}% Completed";
  }

  Color get progressColor {
    if (progress == 0) return AppTheme.redAccent;
    if (progress == 1) return AppTheme.forestGreen;
    return AppTheme.azureBlue;
  }

  Future<void> _navigateAndUpdate(String route) async {
    final result = await Navigator.pushNamed(context, route);
    if (result == true) {
      await _checkCompletionStatus(userMail);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.halfwhite,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.06,
            left: screenWidth * 0.01,
            right: screenWidth * 0.01,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Add your Information",
                  style: AppTheme.getResponsiveTextTheme(context).labelLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your progress",
                      style: TextStyle(
                        fontSize: 13.5,
                        color: AppTheme.greyColor,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      progressText,
                      style: TextStyle(
                        fontSize: 18.5,
                        color: progressColor,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Stack(
                      children: [
                        Container(
                          height: 8.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        Container(
                          height: 8.0,
                          width: screenWidth * progress,
                          decoration: BoxDecoration(
                            color: progressColor,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25.0),

                    /// HEALTH CARD
                    InfoCard(
                      context,
                      icon: Icons.health_and_safety,
                      iconColor: AppTheme.forestGreen,
                      title: 'Health',
                      description: healthCompleted
                          ? 'Health Data Uploaded'
                          : 'Upload Your Medical Records Here',
                      backgroundColor: Colors.green[50]!,
                      arrowColor: AppTheme.forestGreen,
                      descolor: AppTheme.forestGreen,
                      onTap: () => _navigateAndUpdate(AppRoutes.health),
                    ),
                    const SizedBox(height: 15.0),

                    /// EDUCATION CARD
                    InfoCard(
                      context,
                      icon: Icons.school,
                      iconColor: AppTheme.azureBlue,
                      title: 'Education',
                      description: educationCompleted
                          ? 'Education Data Uploaded'
                          : 'Upload Your Education Records Here',
                      backgroundColor: Colors.blue[50]!,
                      arrowColor: AppTheme.azureBlue,
                      descolor: AppTheme.azureBlue,
                      onTap: () => _navigateAndUpdate(AppRoutes.eduData),
                    ),
                    const SizedBox(height: 15.0),

                    /// CAREER CARD
                    InfoCard(
                      context,
                      icon: Icons.work,
                      iconColor: AppTheme.purpleAccent,
                      title: 'Career',
                      description: careerCompleted
                          ? 'Career Data Uploaded'
                          : 'Upload Your Career Records Here',
                      backgroundColor: Colors.purple[50]!,
                      arrowColor: AppTheme.purpleAccent,
                      descolor: AppTheme.purpleAccent,
                      onTap: () => _navigateAndUpdate(AppRoutes.career),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
