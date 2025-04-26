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
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                "Create a unique resume with your phone!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Image.asset(
                "lib/assets/Images/cv_welcome.png",
                height: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: "Import from LinkedIn",
                onPressed: () => _importFromLinkedIn(context),
              ),
              const SizedBox(height: 15),
              CustomButton(
                text: "Create a new CV",
                onPressed: () => _createNewCV(context),
              ),
              const SizedBox(height: 15),
              CustomButton(
                text: "View Templates",
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TemplateSelectionScreen(),
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
