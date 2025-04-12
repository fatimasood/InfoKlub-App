import 'package:flutter/material.dart';
import 'package:infoklub/widgets/custom_button.dart';
import 'package:infoklub/widgets/drag_dropfile.dart';

import '../../../app/theme.dart';
import '../../../widgets/custom_input.dart';

class ReusableForm extends StatelessWidget {
  final TextEditingController degreeController;
  final TextEditingController institutionController;
  final TextEditingController totalGradeController;
  final TextEditingController scoreGradeController;
  final TextEditingController percentageController;
  final TextEditingController achievementsController;
  final VoidCallback onFileUpload;
  final VoidCallback onScanDocuments;

  const ReusableForm({
    super.key,
    required this.degreeController,
    required this.institutionController,
    required this.totalGradeController,
    required this.scoreGradeController,
    required this.percentageController,
    required this.achievementsController,
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
            "Degree Name*",
            style: AppTheme.getResponsiveTextTheme(context).displaySmall,
          ),
          const SizedBox(
            height: 5.0,
          ),
          CustomInput(
            hintText: "Secondary Education",
            controller: degreeController,
            keyboardType: TextInputType.text,
            backgroundColor: Colors.white,
            textColor: Colors.black,
          ),
          const SizedBox(height: 12.0),
          Text(
            "Institution Name*",
            style: AppTheme.getResponsiveTextTheme(context).displaySmall,
          ),
          const SizedBox(
            height: 5.0,
          ),
          // Institution Name
          CustomInput(
            hintText: "Government High School",
            controller: institutionController,
            keyboardType: TextInputType.text,
            backgroundColor: Colors.white,
            textColor: Colors.black,
          ),
          const SizedBox(height: 12.0),
          Text(
            "Total Grade",
            style: AppTheme.getResponsiveTextTheme(context).displaySmall,
          ),
          const SizedBox(
            height: 5.0,
          ),
          // Total Grade
          CustomInput(
            hintText: "4.0",
            controller: totalGradeController,
            keyboardType: TextInputType.number,
            backgroundColor: Colors.white,
            textColor: Colors.black,
          ),
          const SizedBox(height: 12.0),
          Text(
            "Score Grade",
            style: AppTheme.getResponsiveTextTheme(context).displaySmall,
          ),
          const SizedBox(
            height: 5.0,
          ),
          // Score Grade
          CustomInput(
            hintText: "3.5",
            controller: scoreGradeController,
            keyboardType: TextInputType.number,
            textColor: Colors.black,
          ),
          const SizedBox(height: 12.0),
          Text(
            "Achievements (Optional)",
            style: AppTheme.getResponsiveTextTheme(context).displaySmall,
          ),
          const SizedBox(
            height: 5.0,
          ),

          // Achievements
          CustomInput(
            hintText: "Gold Medal",
            controller: achievementsController,
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
              textColor: AppTheme.primaryColor,
              borderColor: AppTheme.secondaryColor,
              color: AppTheme.whiteColor,
              onPressed: () {
                //scan documents
              })
        ],
      ),
    );
  }
}
