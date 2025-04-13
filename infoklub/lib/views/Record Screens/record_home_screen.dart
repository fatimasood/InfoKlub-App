import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import '../../widgets/custom_card.dart';

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    //  final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.halfwhite,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoCard(
                context,
                icon: Icons.health_and_safety,
                iconColor: AppTheme.forestGreen,
                title: 'Health',
                // description: 'Upload Your Medical RecordsPages Here',
                backgroundColor: Colors.green[50]!,
                arrowColor: AppTheme.forestGreen,
                descolor: AppTheme.forestGreen,
                showIcons: true,
                editAction: () {
                  // Handle edit action
                  if (kDebugMode) {
                    print("Edit tapped!");
                  }
                },
                downloadAction: () {
                  // Handle download action
                  if (kDebugMode) {
                    print("Download tapped!");
                  }
                },
              ),
              const SizedBox(height: 15.0),
              InfoCard(
                context,
                icon: Icons.school,
                iconColor: AppTheme.azureBlue,
                title: 'Education',
                // description: 'Upload Your Education RecordsPages Here',
                backgroundColor: Colors.blue[50]!,
                arrowColor: AppTheme.azureBlue,
                descolor: AppTheme.azureBlue,
                showArrow: false,
                showIcons: true,
                editAction: () {
                  // Handle edit action
                  if (kDebugMode) {
                    print("Edit tapped!");
                  }
                },
                downloadAction: () {
                  // Handle download action
                  if (kDebugMode) {
                    print("Download tapped!");
                  }
                },
              ),
              const SizedBox(height: 15.0),
              InfoCard(
                context,
                icon: Icons.work,
                iconColor: AppTheme.purpleAccent,
                title: 'Career',
                // description: 'Upload Your Career RecordsPages Here',
                backgroundColor: Colors.purple[50]!,
                arrowColor: AppTheme.purpleAccent,
                descolor: AppTheme.purpleAccent,
                showArrow: false,
                showIcons: true,
                editAction: () {
                  // Handle edit action
                  if (kDebugMode) {
                    print("Edit tapped!");
                  }
                },
                downloadAction: () {
                  // Handle download action
                  if (kDebugMode) {
                    print("Download tapped!");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
