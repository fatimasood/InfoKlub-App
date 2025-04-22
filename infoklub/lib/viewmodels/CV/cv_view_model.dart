import 'package:flutter/material.dart';
import 'package:infoklub/models/cv/cv_models.dart';
import 'package:infoklub/models/cv/template_model.dart';

class CvViewModel extends ChangeNotifier {
  CVModel? _currentCV;
  Template? _selectedTemplate;

  CVModel? get currentCV => _currentCV;
  Template? get selectedTemplate => _selectedTemplate;

  Future<void> importFromLinkedIn() async {
    try {
      // Show loading state
      notifyListeners();

      // TODO: Implement actual LinkedIn import logic
      // 1. Authenticate with LinkedIn API
      // 2. Fetch profile data
      // 3. Convert to CVModel format

      // Mock implementation (replace with real API calls)
      await Future.delayed(
          const Duration(seconds: 2)); // Simulate network delay

      _currentCV = CVModel(
        name: "Imported from LinkedIn",
        // Add other fields from LinkedIn
      );

      notifyListeners();
    } catch (e) {
      rethrow; // Let the calling function handle the error
    }
  }

  void createNewCV() {
    // Create a blank CV with default template
    _currentCV = CVModel(
      name: "New CV",
      // Initialize other default fields
    );
    notifyListeners();
  }

  void selectTemplate(Template template) {
    _selectedTemplate = template;
    if (_currentCV != null) {
      _currentCV!.templateId = template.id;
    }
    notifyListeners();
  }

  // Add other CV manipulation methods as needed
}
