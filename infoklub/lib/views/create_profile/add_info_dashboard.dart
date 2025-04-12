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
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: screenHeight * 0.09,
          bottom: screenHeight * 0.6,
          left: screenWidth * 0.03,
          right: screenWidth * 0.03,
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
                  top: 20.0, bottom: 20.0, left: 16.0, right: 16.0),
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
                  const Text(
                    "Complete your Profile",
                    style: TextStyle(
                        fontSize: 18.5,
                        color: AppTheme.redAccent,
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
                          color: AppTheme.redAccent,
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
                    description: 'Upload Your Medical Records Here',
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
                    description: 'Upload Your Education Records Here',
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
                    description: 'Upload Your Career Records Here',
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
    );
  }
}
