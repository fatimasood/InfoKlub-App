import 'package:flutter/material.dart';
import 'package:infoklub/widgets/custom_button.dart';
import 'package:infoklub/widgets/drag_dropfile.dart';

import '../../../app/theme.dart';
import '../../../widgets/custom_input.dart';

class ReusableFormCareer extends StatelessWidget {
  final TextEditingController companyNameController;
  final TextEditingController jobTitleController;
  final TextEditingController addressController;
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final TextEditingController skillsController;
  final VoidCallback onFileUpload;
  final VoidCallback onScanDocuments;

  const ReusableFormCareer({
    super.key,
    required this.companyNameController,
    required this.jobTitleController,
    required this.addressController,
    required this.startDateController,
    required this.endDateController,
    required this.skillsController,
    required this.onFileUpload,
    required this.onScanDocuments,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Degree Name
          Text(
            "Company Name*",
            style: AppTheme.getResponsiveTextTheme(context).displaySmall,
          ),
          const SizedBox(
            height: 5.0,
          ),
          CustomInput(
            hintText: "Vivasoft",
            controller: companyNameController,
            keyboardType: TextInputType.text,
            backgroundColor: Colors.white,
            textColor: Colors.black,
          ),
          const SizedBox(height: 12.0),
          Text(
            "Job Title*",
            style: AppTheme.getResponsiveTextTheme(context).displaySmall,
          ),
          const SizedBox(
            height: 5.0,
          ),
          // Institution Name
          CustomInput(
            hintText: "Software Developer",
            controller: jobTitleController,
            keyboardType: TextInputType.text,
            backgroundColor: Colors.white,
            textColor: Colors.black,
          ),
          const SizedBox(height: 12.0),
          Text(
            "Location*",
            style: AppTheme.getResponsiveTextTheme(context).displaySmall,
          ),
          const SizedBox(
            height: 5.0,
          ),
          // Total Grade
          CustomInput(
            hintText: "Bangladesh",
            controller: addressController,
            keyboardType: TextInputType.number,
            backgroundColor: Colors.white,
            textColor: Colors.black,
          ),
          const SizedBox(height: 12.0),
          Text(
            "Start Date*",
            style: AppTheme.getResponsiveTextTheme(context).displaySmall,
          ),
          const SizedBox(
            height: 5.0,
          ),
          // Score Grade
          CustomInput(
            hintText: "12 Oct 2024",
            controller: startDateController,
            keyboardType: TextInputType.number,
            textColor: Colors.black,
          ),
          const SizedBox(height: 12.0),
          Text(
            "End Date*",
            style: AppTheme.getResponsiveTextTheme(context).displaySmall,
          ),
          const SizedBox(
            height: 5.0,
          ),
          // Score Grade
          CustomInput(
            hintText: "01 Dec 2024",
            controller: startDateController,
            keyboardType: TextInputType.number,
            textColor: Colors.black,
          ),
          const SizedBox(height: 12.0),
          Text(
            "Skills",
            style: AppTheme.getResponsiveTextTheme(context).displaySmall,
          ),
          const SizedBox(
            height: 5.0,
          ),

          // Achievements
          CustomInput(
            hintText: "Java",
            controller: skillsController,
            keyboardType: TextInputType.text,
            textColor: Colors.black,
          ),
          const SizedBox(height: 16.0),

          // File Upload Section
          dropfiles(),
          const SizedBox(height: 16.0),

          // Scan Documents Button
          CustomButton(
            text: "Use Camera to Scan Documents",
            textColor: AppTheme.purpleAccent,
            borderColor: AppTheme.purpleAccent,
            color: AppTheme.whiteColor,
            onPressed: () {
              //scan documents
            },
          ),
        ],
      ),
    );
  }
}
