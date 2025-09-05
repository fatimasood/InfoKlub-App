import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/viewmodels/carrer/career_viewmodel.dart';
import 'package:infoklub/viewmodels/education/eduinfo_viewmodel.dart';
import 'package:infoklub/viewmodels/health/healthdata_viewmodel.dart';
import 'package:infoklub/views/career_screens/carrer_all_info.dart';
import 'package:infoklub/views/education_data/edu_save.dart';
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
                    print("Medical Edit tapped!");
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
                    print("Medical Download tapped!");
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
                    print("Education Edit tapped!");
                  }
                  //move to education
                  final vm = context.read<EduinfoViewmodel>();
                  vm.enableEditMode();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EduSave(),
                    ),
                  );
                },
                downloadAction: () {
                  // Handle download action
                  if (kDebugMode) {
                    print("Education Download tapped!");
                  }

                  final vm = context.read<EduinfoViewmodel>();
                  vm.downloadEducationDocs(context);
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
                    print("Career Edit tapped!");
                  }
                  //move to career

                  final vm = context.read<CareerViewmodel>();
                  vm.enableEditMode();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CarrerAllInfo(),
                    ),
                  );
                },
                downloadAction: () {
                  // Handle download action
                  if (kDebugMode) {
                    print("Carrer Download tapped!");
                  }

                  final vm = context.read<CareerViewmodel>();
                  vm.downloadCareerDocs(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
