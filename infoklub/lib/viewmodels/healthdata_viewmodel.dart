import 'package:flutter/material.dart';

class HealthDataViewModel extends ChangeNotifier {
  // Blood Type Data
  final List<String> bloodTypes = [
    "A+",
    "A-",
    "B+",
    "B-",
    "O+",
    "O-",
    "AB+",
    "AB-"
  ];
  String? selectedBloodType;

  void selectBloodType(String type) {
    selectedBloodType = type;
    notifyListeners();
  }

  // Medications Data
  final List<String> medications = [
    "Aspirin",
    "Ibuprofen",
    "Paracetamol",
    "Vitamin C",
    "Antibiotics"
  ];
  List<String> filteredMedications = [];
  List<String> selectedMedications = [];

  HealthDataViewModel() {
    filteredMedications = List.from(medications);
  }

  void filterMedications(String query) {
    filteredMedications = medications
        .where((medication) =>
            medication.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void toggleMedication(String medication) {
    if (selectedMedications.contains(medication)) {
      selectedMedications.remove(medication);
    } else {
      selectedMedications.add(medication);
    }
    notifyListeners();
  }
}
