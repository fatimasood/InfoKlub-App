import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/viewmodels/CV/cv_creation_view_model.dart';
import 'package:infoklub/viewmodels/CV/cv_view_model.dart';
import 'package:infoklub/views/CV/CV_creation/contact_info_screen.dart';
import 'package:infoklub/views/CV/template_selection_screen.dart';
import 'package:infoklub/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class CVPage extends StatelessWidget {
  const CVPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.halfwhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Create a unique resume\n with your phone!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.normal,
                      color: AppTheme.blackColor,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Image.asset(
                "lib/assets/Images/cvwelcome.png",
                height: 330,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 75, right: 75),
                child: CustomButton(
                  text: "Create a new CV",
                  borderRadius: 9.86,
                  height: 40.0,
                  color: AppTheme.purpleAccent,
                  onPressed: () => _createNewCV(context),
                ),
              ),
              const SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.only(left: 75, right: 75),
                child: CustomButton(
                  text: "View Templates",
                  color: AppTheme.coralAccent,
                  borderRadius: 9.86,
                  height: 40.0,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TemplateSelectionScreen(),
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

  // views/CV/cv_page.dart
  void _createNewCV(BuildContext context) {
    final cvViewModel = context.read<CvViewModel>();
    final cvCreationViewModel = context.read<CvCreationViewModel>();

    // Create new CV and load user data
    cvViewModel.createNewCV();

    // Wait for data to load then navigate
    Future.delayed(const Duration(milliseconds: 100), () {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const ContactInfoScreen()));
    });
  }
}
