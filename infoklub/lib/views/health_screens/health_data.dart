// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:infoklub/services/firebase_services/splash_services.dart';
import 'package:infoklub/utils/utils.dart';
import 'package:infoklub/viewmodels/health/healthdata_viewmodel.dart';
import 'package:infoklub/widgets/custom_button.dart';
import 'package:infoklub/widgets/drag_dropfile.dart';
import 'package:provider/provider.dart';
import 'package:infoklub/app/theme.dart';
import '../../app/routes.dart';

class HealthData extends StatefulWidget {
  final bool isEdit;
  const HealthData({super.key, this.isEdit = false});

  @override
  State<HealthData> createState() => _HealthDataState();
}

class _HealthDataState extends State<HealthData> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<HealthDataViewModel>();
      vm.initialize(userEmail);
      if (widget.isEdit) {
        vm.loadHealthData().then((_) {
          setState(() {
            _enteredSymptoms.clear();
            _enteredSymptoms.addAll(vm.selectedSymptoms);
          });
        });
      }
    });
  }

  //sympotoms medicines

  final TextEditingController _textController = TextEditingController();
  final List<String> _enteredSymptoms = [];
  bool _showHintText = true;

  String get userEmail => userMail;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HealthDataViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context, false),
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppTheme.textColor,
            size: 18,
          ),
        ),
        title: Text(
          widget.isEdit ? "Edit Health Info" : "Add Health Info",
          style: AppTheme.getResponsiveTextTheme(context).labelLarge,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FileUploadWidget(onUploadTap: () {
                  viewModel.pickDocument();
                }),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Use Camera to Scan Document',
                  borderColor: AppTheme.tealAccent,
                  height: 45.0,
                  width: double.infinity,
                  textColor: AppTheme.tealAccent,
                  color: AppTheme.whiteColor,
                  borderRadius: 15.0,
                  onPressed: () {
                    viewModel.captureWithCamera();
                  },
                ),
                const SizedBox(height: 15),
                if (viewModel.uploadedDocs.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    "Uploaded Documents",
                    style: TextStyle(
                      fontSize: isTablet ? 20.0 : 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      color: AppTheme.blackColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: viewModel.uploadedDocs.length,
                    itemBuilder: (context, index) {
                      final path = viewModel.uploadedDocs[index];
                      final isImage = path.endsWith('.jpg') ||
                          path.endsWith('.jpeg') ||
                          path.endsWith('.png');

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6.0),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            isImage
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(path),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(
                                    Icons.insert_drive_file,
                                    color: AppTheme.tealAccent,
                                    size: 40,
                                  ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                path.split('/').last,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.greyblacktext,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent),
                              onPressed: () {
                                viewModel.uploadedDocs.removeAt(index);

                                // ignore: invalid_use_of_protected_member
                                viewModel.notifyListeners(); // To update the UI
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 15),
                const Text(
                  "Personal Health Information",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.backgreen,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Blood Type",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Wrap(
                        spacing: 7,
                        runSpacing: 6,
                        children: viewModel.bloodTypes.map((type) {
                          final isSelected =
                              viewModel.selectedBloodType == type;
                          return GestureDetector(
                            onTap: () => viewModel.selectBloodType(type),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 9.0),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.tealAccent
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(3.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2.0,
                                    offset: Offset(0, 1),
                                  )
                                ],
                              ),
                              child: Text(
                                type,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppTheme.whiteColor
                                      : AppTheme.forestGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "What medications do you take?",
                  style: TextStyle(
                    fontSize: isTablet ? 26.0 : 22.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                    color: AppTheme.blackColor,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.whiteColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1.0,
                    ),
                  ),
                  child: TextField(
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter',
                      fontSize: isTablet ? 18.0 : 16.0,
                    ),
                    onChanged: viewModel.filterMedications,
                    decoration: const InputDecoration(
                      hintText: "Search medications...",
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(Icons.search, color: Colors.black38),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: viewModel.filteredMedications.map((med) {
                    final isSelected =
                        viewModel.selectedMedications.contains(med);
                    return CheckboxListTile(
                      value: isSelected,
                      activeColor: Colors.white,
                      checkColor: AppTheme.tealAccent,
                      onChanged: (_) => viewModel.toggleMedication(med),
                      title: Text(
                        med,
                        style: TextStyle(
                          color:
                              isSelected ? AppTheme.tealAccent : Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 15),
                if (viewModel.selectedMedications.isNotEmpty)
                  Wrap(
                    spacing: 8.0,
                    children: viewModel.selectedMedications
                        .map((med) => Chip(
                              label: Text(
                                med,
                                style: const TextStyle(
                                  color: AppTheme.greyblacktext,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              backgroundColor: Colors.grey[100],
                              deleteIcon: const Icon(
                                Icons.close,
                                size: 16,
                                color: AppTheme.greyblacktext,
                              ),
                              onDeleted: () => viewModel.toggleMedication(med),
                            ))
                        .toList(),
                  ),
                const SizedBox(height: 30),

                // for sympotoms

                const Text(
                  "Do you have any symptoms/allergy?",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.tealAccent, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Wrap(
                    spacing: 4.0,
                    children: [
                      // Display the entered symptoms as chips
                      ..._enteredSymptoms.map((symptom) {
                        return Chip(
                          label: Text(
                            symptom,
                            style: const TextStyle(
                                color: AppTheme.tealAccent,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700),
                          ),
                          backgroundColor: AppTheme.backgreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: AppTheme.backgreen),
                          ),
                          deleteIcon: const Icon(Icons.close,
                              size: 18, color: AppTheme.tealAccent),
                          onDeleted: () {
                            setState(() {
                              _enteredSymptoms.remove(symptom);
                              if (_enteredSymptoms.isEmpty) {
                                _showHintText = true;
                              }
                            });
                          },
                        );
                      }),
                      // Input field for adding symptoms
                      SizedBox(
                        width: 150,
                        child: TextField(
                          controller: _textController,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _showHintText = false; // Hide hint when typing
                            });
                          },
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                final symptomVM =
                                    Provider.of<HealthDataViewModel>(context,
                                        listen: false);
                                symptomVM.addSymptom(value);
                                _enteredSymptoms.add(value);
                                _textController.clear();
                              });
                            }
                          },
                          decoration: InputDecoration(
                            hintText: _showHintText
                                ? "Add symptom or medicines"
                                : null,
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (viewModel.selectedBloodType == null ||
                        viewModel.selectedMedications.isEmpty) {
                      Utils().toastMessage(
                        "Please select blood type and medications",
                      );
                      return;
                    }

                    if (widget.isEdit) {
                      // 🔹 Update existing
                      await viewModel.updateHealthData();
                      Utils()
                          .toastMessage("Health record updated successfully!");
                      Navigator.pop(context, true); // return back after editing
                    } else {
                      // 🔹 Save new
                      await viewModel.saveHealthData();
                      Utils().toastMessage(
                          "Your health record saved successfully...");
                      await Future.delayed(const Duration(milliseconds: 500));

                      if (!mounted) return;
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.infodashboard,
                        arguments: viewModel.userEmail,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.tealAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Save Information",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
