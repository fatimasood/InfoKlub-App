import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infoklub/models/health/health_model.dart';
import 'package:infoklub/utils/hive_helpers.dart';

class HealthDataViewModel extends ChangeNotifier {
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
    "Ibuprofen",
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

  Future<void> captureWithCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      uploadedDocs.add(pickedImage.path);
      notifyListeners();
    }
  }

  Future<void> saveHealthData() async {
    final box = await HiveHelper.openHealthBox();
    final healthData = HealthModel(
      bloodType: selectedBloodType ?? "Unknown",
      medications: List.from(selectedMedications),
      documentPaths: List.from(uploadedDocs),
      allergies: allergies,
    );
    await box.put('user_health', healthData);

    if (kDebugMode) {
      print("✅ Saved Health Record:");
    }
    if (kDebugMode) {
      print("Blood Type: ${healthData.bloodType}");
    }
    if (kDebugMode) {
      print("Medications: ${healthData.medications}");
    }
    if (kDebugMode) {
      print("Documents: ${healthData.documentPaths}");
    }
    if (kDebugMode) {
      print("Allergies: ${healthData.allergies}");
    }
  }
}
