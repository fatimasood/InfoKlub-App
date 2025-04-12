import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';

import '../../app/routes.dart';
import '../../widgets/custom_card.dart';

class CareerDashboard extends StatefulWidget {
  const CareerDashboard({super.key});

  @override
  State<CareerDashboard> createState() => _CareerDashboardState();
}

class _CareerDashboardState extends State<CareerDashboard> {
  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    //  final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Add your Information",
                  style: AppTheme.getResponsiveTextTheme(context).labelLarge,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
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
                "Health, Education & Carrer Info Added!",
                style: TextStyle(
                    fontSize: 16.5,
                    color: Colors.green,
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
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.pink,
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
                showIcons: true,
                editAction: () {
                  // Handle edit action
                  print("Edit tapped!");
                },
                downloadAction: () {
                  // Handle download action
                  print("Download tapped!");
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
                showArrow: false,
                showIcons: true,
                editAction: () {
                  // Handle edit action
                  print("Edit tapped!");
                },
                downloadAction: () {
                  // Handle download action
                  print("Download tapped!");
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
                showArrow: false,
                showIcons: true,
                editAction: () {
                  // Handle edit action
                  print("Edit tapped!");
                },
                downloadAction: () {
                  // Handle download action
                  print("Download tapped!");
                },
              ),
              const Spacer(),
              Container(
                color: Colors.white,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.finishScreen);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      "Finish",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
