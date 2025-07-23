import 'package:flutter/material.dart';
import 'package:infoklub/main.dart';
import 'package:infoklub/models/education/education_model.dart';
import 'package:infoklub/viewmodels/education/eduinfo_viewmodel.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/widgets/custom_button.dart';
import 'package:infoklub/widgets/drag_dropfile.dart';
import 'package:provider/provider.dart';
import '../../app/routes.dart';
import 'widget/custom_form.dart';

class EduInfo extends StatelessWidget {
  const EduInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EduinfoViewmodel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    final TextEditingController degreeController = TextEditingController();
    final TextEditingController institutionController = TextEditingController();
    final TextEditingController totalGradeController = TextEditingController();
    final TextEditingController scoreGradeController = TextEditingController();
    final TextEditingController percentageController = TextEditingController();
    final TextEditingController achievementsController =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppTheme.textColor,
            size: 18,
          ),
        ),
        title: Text(
          "Add Education Information",
          style: AppTheme.getResponsiveTextTheme(context).labelLarge,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              // vertical: screenHeight * 0,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight, // Ensures proper layout
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FileUploadWidget(onUploadTap: () {
                    //viewModel.pickDocument();
                  }),
                  const SizedBox(height: 10.0),
                  CustomButton(
                    text: 'Use Camera to Scan Document',
                    borderColor: AppTheme.azureBlue,
                    height: 45.0,
                    width: double.infinity,
                    textColor: AppTheme.azureBlue,
                    color: AppTheme.whiteColor,
                    borderRadius: 15.0,
                    onPressed: () {
                      // viewModel.captureWithCamera();
                    },
                  ),
                  //take info from user
                  ReusableForm(
                    degreeController: degreeController,
                    institutionController: institutionController,
                    totalGradeController: totalGradeController,
                    scoreGradeController: scoreGradeController,
                    percentageController: percentageController,
                    achievementsController: achievementsController,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(
                  bottom: 20, left: 10, right: 10, top: 0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final viewmodel =
                        Provider.of<EduinfoViewmodel>(context, listen: false);
                    final String email = userMail;

                    final info = EducationInfo(
                      degree: degreeController.text,
                      institution: institutionController.text,
                      totalGrade: totalGradeController.text,
                      scoreGrade: scoreGradeController.text,
                      percentage: percentageController.text,
                      achievements: achievementsController.text,
                    );

                    await viewmodel.saveEducationInfo(email, info);
                    viewmodel.clearEducationInfo();
                    Navigator.pushNamed(context, AppRoutes.eduSave);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Save",
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
