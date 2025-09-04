import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/viewmodels/health/healthdata_viewmodel.dart';
import 'package:infoklub/views/health_screens/health_data.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_card.dart';

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.halfwhite,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
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

                  //move on health screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HealthData(isEdit: true),
                    ),
                  );
                },
                downloadAction: () {
                  // Handle download action
                  if (kDebugMode) {
                    print("Download tapped!");
                  }

                  final vm = context.read<HealthDataViewModel>();
                  vm.downloadHealthDocs(context);
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
                  //move to education

                  Navigator.pushReplacementNamed(context, '/eduSave');
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
                  //move to career

                  Navigator.pushReplacementNamed(context, '/careerInfo');
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
