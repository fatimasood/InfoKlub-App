import 'package:flutter/material.dart';
import 'package:infoklub/viewmodels/health/healthdata_viewmodel.dart';
import 'package:infoklub/widgets/custom_button.dart';
import 'package:infoklub/widgets/drag_dropfile.dart';
import 'package:provider/provider.dart';
import 'package:infoklub/app/theme.dart';

import '../../app/routes.dart';

class HealthData extends StatelessWidget {
  const HealthData({super.key});

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
          "Add Health Information",
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
                    // TODO: implement camera scan
                  },
                ),
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
                  onPressed: () {
                    if (viewModel.selectedBloodType == null ||
                        viewModel.selectedMedications.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Please select blood type and medications"),
                        ),
                      );
                      return;
                    }
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
