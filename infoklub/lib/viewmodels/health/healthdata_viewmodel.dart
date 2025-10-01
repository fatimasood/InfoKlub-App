import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infoklub/models/health/health_model.dart';
import 'package:infoklub/services/firebase_services/splash_services.dart';
import 'package:infoklub/services/local_storage_services/hive_helpers.dart';
import 'package:infoklub/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

class HealthDataViewModel extends ChangeNotifier {
  final TextEditingController symptomController = TextEditingController();
  final List<String> _selectedSymptoms = [];

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

  final List<String> medications = [
    "Aspirin",
    "Ibuprofen",
    "Paracetamol",
    "Vitamin C",
    "Antibiotics",
    "Diclofenac",
    "Ketorolac",
    "Multivitamins",
    "Iron + Folic Acid",
    "Calcium + Vitamin D",
  ];
  List<String> filteredMedications = [];
  List<String> selectedMedications = [];
  List<String> uploadedDocs = [];
  List<String> allergies = [];

  HealthDataViewModel() {
    filteredMedications = List.from(medications);
  }

  void selectBloodType(String type) {
    selectedBloodType = type;
    notifyListeners();
  }

  void filterMedications(String query) {
    filteredMedications = medications
        .where((med) => med.toLowerCase().contains(query.toLowerCase()))
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

  void addDocumentPath(String path) {
    uploadedDocs.add(path);
    notifyListeners();
  }

  Future<void> pickDocument() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      uploadedDocs.add(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> updateHealthData() async {
    await saveHealthData();
  }

  Future<void> captureWithCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      uploadedDocs.add(pickedImage.path);
      notifyListeners();
    }
  }

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
      debugPrint("Saved Symptoms: $_selectedSymptoms");
      // Add your saving logic here (e.g., API call, local storage, etc.)
    } else {
      debugPrint("No symptoms to save.");
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the ViewModel is no longer in use
    symptomController.dispose();
    super.dispose();
  }

  bool hasData() {
    return allergies.isNotEmpty ||
        selectedBloodType != null ||
        selectedMedications.isNotEmpty ||
        uploadedDocs.isNotEmpty;
  }

//fetch health data
  Future<void> loadHealthData() async {
    final box = await HiveHelper.openHealthBox(userMail);

    final healthData = box.get('user_health');

    if (healthData != null) {
      selectedBloodType = healthData.bloodType;
      selectedMedications = List<String>.from(healthData.medications);
      uploadedDocs = List<String>.from(healthData.documentPaths);
      allergies = List<String>.from(healthData.allergies);
      notifyListeners();
    }
  }

//save data
  Future<void> saveHealthData() async {
    final box = await HiveHelper.openHealthBox(userMail);
    final healthData = HealthModel(
      bloodType: selectedBloodType ?? "Unknown",
      medications: List.from(selectedMedications),
      documentPaths: List.from(uploadedDocs),
      allergies: List.from(_selectedSymptoms),
    );
    await box.put('user_health', healthData);

    if (kDebugMode) {
      debugPrint("✅ Saved Health Record:");
    }
    if (kDebugMode) {
      debugPrint("Blood Type: ${healthData.bloodType}");
    }
    if (kDebugMode) {
      debugPrint("Medications: ${healthData.medications}");
    }
    if (kDebugMode) {
      debugPrint("Documents: ${healthData.documentPaths}");
    }
    if (kDebugMode) {
      debugPrint("Allergies: ${healthData.allergies}");
    }
  }

  // download documents

  Future<void> downloadHealthDocs(BuildContext context) async {
    final box = await HiveHelper.openHealthBox(userMail);

    final healthData = box.get('user_health');

    if (healthData == null || healthData.documentPaths.isEmpty) {
      Utils().toastMessage("No health docs found.");
      return;
    }

    final docs = List<String>.from(healthData.documentPaths);

    final dir = await getExternalStorageDirectory();
    final downloadPath = "${dir!.path}/HealthDocs";
    await Directory(downloadPath).create(recursive: true);

    for (final path in docs) {
      final file = File(path);
      if (file.existsSync()) {
        final newFile =
            await file.copy("$downloadPath/${path.split('/').last}");
        debugPrint("Saved to ${newFile.path}");
      }
    }

    Utils().toastMessage("All health docs downloaded in your device.");
  }
}
