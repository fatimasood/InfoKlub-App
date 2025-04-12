import 'package:flutter/material.dart';
import 'package:infoklub/widgets/custom_button.dart';
import 'package:infoklub/widgets/drag_dropfile.dart';
import 'package:provider/provider.dart';
import 'package:infoklub/app/theme.dart';

import '../../app/routes.dart';
import '../../viewmodels/healthdata_viewmodel.dart';

class HealthData extends StatelessWidget {
  const HealthData({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HealthDataViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            'lib/assets/Images/backarrow.png',
            color: AppTheme.tealAccent,
            height: 22,
            width: 22,
          ),
        ),
        title: Text(
          "Add Health Information",
          style: AppTheme.getResponsiveTextTheme(context).labelLarge,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Main scrolling content
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag and Drop Section
                dropfiles(),
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
                    //scan document
                  },
                ),
                const SizedBox(height: 15),
                // Blood Type Section
                const Text(
                  "Personal Health Information",
                  style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.blackColor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.backgreen,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Blood Type",
                          style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.blackColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
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
                ),
                const SizedBox(height: 20),

                // Medications Section
                const Text(
                  "What medications do you take?",
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      color: AppTheme.blackColor),
                ),
                const SizedBox(height: 10),

                // Updated Search Bar
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
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Inter',
                        fontSize: 18.0),
                    onChanged: (query) {
                      viewModel.filterMedications(query);
                    },
                    decoration: const InputDecoration(
                      hintText: "Search medications...",
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black38,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Medication List
                Column(
                  children: viewModel.filteredMedications.map((medication) {
                    final isSelected =
                        viewModel.selectedMedications.contains(medication);
                    return CheckboxListTile(
                      value: isSelected,

                      //tileColor: isSelected ? AppTheme.tealAccent : Colors.white,
                      activeColor: Colors.white,
                      checkColor: AppTheme.tealAccent,
                      onChanged: (bool? value) =>
                          viewModel.toggleMedication(medication),
                      title: Text(
                        medication,
                        style: TextStyle(
                            color:
                                isSelected ? AppTheme.tealAccent : Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter'),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 15),

                // Selected Medications
                if (viewModel.selectedMedications.isNotEmpty)
                  Wrap(
                    spacing: 8.0,
                    children: viewModel.selectedMedications
                        .map((medication) => Chip(
                              label: Text(
                                medication,
                                style: const TextStyle(
                                    color: AppTheme.greyblacktext,
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.normal),
                              ),
                              backgroundColor: Colors.grey[100],
                              deleteIcon: const Icon(
                                Icons.close,
                                size: 16,
                                color: AppTheme.greyblacktext,
                              ),
                              onDeleted: () =>
                                  viewModel.toggleMedication(medication),
                            ))
                        .toList(),
                  ),

                const SizedBox(
                    height: 100), // Extra padding for the fixed button
              ],
            ),
          ),
          // Fixed Button at the Bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white, // Add background if needed
              padding: const EdgeInsets.only(
                  bottom: 20, left: 10, right: 10, top: 0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    //medicines
                    Navigator.pushNamed(context, AppRoutes.mdcndata);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.tealAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
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
