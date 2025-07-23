import 'dart:io';

import 'package:flutter/material.dart';
import 'package:infoklub/main.dart';
import 'package:infoklub/models/education/education_model.dart';
import 'package:infoklub/viewmodels/education/eduinfo_viewmodel.dart';
import 'package:infoklub/app/theme.dart';
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
              // vertical: screenHeight * 0.02,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FileUploadWidget(onUploadTap: () {
                    viewModel.pickDocument();
                  }),
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
                                      color: AppTheme.secondaryColor,
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
                                  viewModel
                                      .notifyListeners(); // To update the UI
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 10.0),

                  //take info from user
                  ReusableForm(
                    degreeController: degreeController,
                    institutionController: institutionController,
                    totalGradeController: totalGradeController,
                    scoreGradeController: scoreGradeController,
                    percentageController: percentageController,
                    achievementsController: achievementsController,
                    uploadedDocs: viewModel.uploadedDocs,
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
                      uploadedDocs: viewmodel.uploadedDocs,
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
