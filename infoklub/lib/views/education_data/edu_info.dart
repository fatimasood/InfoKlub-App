import 'package:flutter/material.dart';
import 'package:infoklub/widgets/custom_button.dart';
import 'package:infoklub/app/theme.dart';
import '../../app/routes.dart';
import 'widget/custom_form.dart';

class EduInfo extends StatelessWidget {
  const EduInfo({super.key});

  @override
  Widget build(BuildContext context) {
    // final viewModel = Provider.of<EduinfoViewmodel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
          child: Image.asset(
            'lib/assets/Images/backarrow.png',
            color: AppTheme.azureBlue,
            height: 22,
            width: 22,
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
              vertical: screenHeight * 0.02,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight, // Ensures proper layout
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomButton(
                    text: 'Add Education',
                    color: const Color(0xFFFFFFFF),
                    borderColor: Colors.grey,
                    borderRadius: 10.0,
                    textColor: AppTheme.blackColor,
                    icon: const Icon(
                      Icons.add_circle,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      print("Add Education Button Pressed");
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
                    onFileUpload: () {
                      print("File upload clicked");
                    },
                    onScanDocuments: () {
                      print("Scan documents clicked");
                    },
                  ),
                  const SizedBox(height: 100),
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
                  onPressed: () {
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
