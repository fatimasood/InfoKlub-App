import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import '../../app/routes.dart';
import '../../widgets/custom_card.dart';

class ProfileOptions extends StatefulWidget {
  const ProfileOptions({super.key});

  @override
  State<ProfileOptions> createState() => _ProfileOptionsState();
}

class _ProfileOptionsState extends State<ProfileOptions> {
  // check data entry
  bool healthCompleted = false;
  bool educationCompleted = false;
  bool careerCompleted = false;

  // calculate progress
  double get progress {
    int completedCount = 0;
    if (healthCompleted) completedCount++;
    if (educationCompleted) completedCount++;
    if (careerCompleted) completedCount++;
    return completedCount / 3;
  }

// Get progress text
  String get progressText {
    if (progress == 0) return "Complete your Profile";
    if (progress == 1) return "Profile Completed!";
    return "${(progress * 100).toInt()}% Completed";
  }

  // Get progress text color
  Color get progressColor {
    if (progress == 0) return AppTheme.redAccent;
    if (progress == 1) return AppTheme.forestGreen;
    return AppTheme.azureBlue;
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
            // bottom: screenHeight * 0.6,
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
                padding: const EdgeInsets.only(
                    top: 20.0, bottom: 20.0, left: 14.0, right: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your progress",
                      style: TextStyle(
                          fontSize: 13.5,
                          color: AppTheme.greyColor,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      progressText,
                      style: TextStyle(
                          fontSize: 18.5,
                          color: progressColor,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700),
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
                          width: screenWidth * 0.2,
                          decoration: BoxDecoration(
                            color: progressColor,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 25.0),
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
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.health);
                      },
                    ),
                    const SizedBox(height: 15.0),
                    InfoCard(
                      context,
                      icon: Icons.school,
                      iconColor: AppTheme.azureBlue,
                      title: 'Education',
                      description: healthCompleted
                          ? 'Education Data Uploaded'
                          : 'Upload Your Education Records Here',
                      backgroundColor: Colors.blue[50]!,
                      arrowColor: AppTheme.azureBlue,
                      descolor: AppTheme.azureBlue,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.health);
                      },
                    ),
                    const SizedBox(height: 15.0),
                    InfoCard(
                      context,
                      icon: Icons.work,
                      iconColor: AppTheme.purpleAccent,
                      title: 'Career',
                      description: healthCompleted
                          ? 'Career Data Uploaded'
                          : 'Upload Your Career Records Here',
                      backgroundColor: Colors.purple[50]!,
                      arrowColor: AppTheme.purpleAccent,
                      descolor: AppTheme.purpleAccent,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.career);
                      },
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
