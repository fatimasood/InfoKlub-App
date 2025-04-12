import 'package:flutter/material.dart';

class MdcnDataViewModel extends ChangeNotifier {
  final TextEditingController symptomController = TextEditingController();
  final List<String> _selectedSymptoms = []; // Private list to store symptoms

  // Getter to access the selected symptoms
  List<String> get selectedSymptoms => _selectedSymptoms;

  // Method to add a symptom
  void addSymptom(String symptom) {
    if (symptom.isNotEmpty && _selectedSymptoms.length < 10) {
      _selectedSymptoms.add(symptom);
      symptomController.clear();
      notifyListeners();
    }
  }

  // Method to remove a symptom
  void removeSymptom(String symptom) {
    _selectedSymptoms.remove(symptom);
    notifyListeners();
  }

  // Method to save symptoms (you can add your save logic here)
  void saveSymptoms() {
    if (_selectedSymptoms.isNotEmpty) {
      // Example logic for saving symptoms
      print("Saved Symptoms: $_selectedSymptoms");
      // Add your saving logic here (e.g., API call, local storage, etc.)
    } else {
      print("No symptoms to save.");
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the ViewModel is no longer in use
    symptomController.dispose();
    super.dispose();
  }
}
