import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/viewmodels/CV/cv_view_model.dart';
import 'package:infoklub/views/CV/cv_editor_screen.dart';
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
                height: 270,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 75, right: 75),
                child: CustomButton(
                  text: "Import from LinkedIn",
                  color: AppTheme.skyBlue,
                  borderRadius: 9.86,
                  onPressed: () => _importFromLinkedIn(context),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 75, right: 75),
                child: CustomButton(
                  text: "Create a new CV",
                  borderRadius: 9.86,
                  color: AppTheme.tealAccent,
                  onPressed: () => _createNewCV(context),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 75, right: 75),
                child: CustomButton(
                  text: "View Templates",
                  color: AppTheme.coralAccent,
                  borderRadius: 9.86,
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

  void _importFromLinkedIn(BuildContext context) {
    // 1. Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // 2. Call ViewModel method
    context.read<CvViewModel>().importFromLinkedIn().then((_) {
      // 3. Navigate to editor on success
      Navigator.pop(context); // Close loading dialog
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CvEditorScreen()),
      );
    }).catchError((error) {
      // 4. Show error if fails
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to import: $error')),
      );
    });
  }

  void _createNewCV(BuildContext context) {
    // Create with default template
    context.read<CvViewModel>().createNewCV();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CvEditorScreen()),
    );
  }
}
