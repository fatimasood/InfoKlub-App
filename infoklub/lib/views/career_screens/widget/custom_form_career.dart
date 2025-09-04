import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../widgets/custom_input.dart';

class ReusableFormCareer extends StatelessWidget {
  final TextEditingController companyNameController;
  final TextEditingController jobTitleController;
  final TextEditingController addressController;
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final TextEditingController responsibilitiesController;
  final VoidCallback onFileUpload;

  const ReusableFormCareer({
    super.key,
    required this.companyNameController,
    required this.jobTitleController,
    required this.addressController,
    required this.startDateController,
    required this.endDateController,
    required this.responsibilitiesController,
    required this.onFileUpload,
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
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter company name'
                : null,
            textColor: Colors.black,
            onChanged: (val) {},
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
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter your job title'
                : null,
            onChanged: (val) {},
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
            keyboardType: TextInputType.text,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            validator: (value) =>
                value == null || value.isEmpty ? 'Please enter location' : null,
            onChanged: (val) {},
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
            keyboardType: TextInputType.datetime,
            textColor: Colors.black,
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter start date'
                : null,
            onChanged: (val) {},
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
            controller: endDateController,
            keyboardType: TextInputType.datetime,
            textColor: Colors.black,
            validator: (value) =>
                value == null || value.isEmpty ? 'Please enter end date' : null,
            onChanged: (val) {},
          ),
          const SizedBox(height: 12.0),
          Text(
            "Your Responsibilities*",
            style: AppTheme.getResponsiveTextTheme(context).displaySmall,
          ),
          const SizedBox(
            height: 5.0,
          ),

          // responsibilities
          CustomInput(
            hintText:
                " Develop and execute comprehensive marketing strategies and campaigns that align with the company's goals and objectives",
            controller: responsibilitiesController,
            keyboardType: TextInputType.multiline,
            textColor: Colors.black,
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter your responsibilities'
                : null,
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }
}
