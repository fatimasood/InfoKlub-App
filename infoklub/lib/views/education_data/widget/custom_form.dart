import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../widgets/custom_input.dart';

class ReusableForm extends StatelessWidget {
  final TextEditingController degreeController;
  final TextEditingController institutionController;
  final TextEditingController totalGradeController;
  final TextEditingController scoreGradeController;
  final TextEditingController percentageController;
  final TextEditingController achievementsController;

  const ReusableForm({
    super.key,
    required this.degreeController,
    required this.institutionController,
    required this.totalGradeController,
    required this.scoreGradeController,
    required this.percentageController,
    required this.achievementsController,
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
            onChanged: (val) {},
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
            onChanged: (val) {},
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
            onChanged: (val) {},
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
            onChanged: (val) {},
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
            onChanged: (val) {},
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
