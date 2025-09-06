// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infoklub/models/education/education_model.dart';
import 'package:infoklub/services/firebase_services/splash_services.dart';
import 'package:infoklub/utils/utils.dart';
import 'package:infoklub/viewmodels/education/eduinfo_viewmodel.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/views/education_data/custom_form.dart';
import 'package:infoklub/widgets/drag_dropfile.dart';
import 'package:provider/provider.dart';
import '../../app/routes.dart';

class EduInfo extends StatefulWidget {
  final String degreeName;
  final String institutionName;
  final String totalGrade;
  final String scoreGrade;
  final String achievements;
  final String startYear;
  final String endYear;
  final String document;
  final int? editIndex;
  const EduInfo(
      {super.key,
      required this.degreeName,
      required this.institutionName,
      required this.totalGrade,
      required this.scoreGrade,
      required this.startYear,
      required this.endYear,
      this.document = '',
      this.editIndex,
      required this.achievements});

  @override
  State<EduInfo> createState() => _EduInfoState();
}

class _EduInfoState extends State<EduInfo> {
  final String email = userMail;
  late EduinfoViewmodel viewModel;
  late TextEditingController degreeController;
  late TextEditingController institutionController;
  late TextEditingController totalGradeController;
  late TextEditingController scoreGradeController;
  late TextEditingController achievementsController;
  late TextEditingController startYearController;
  late TextEditingController endYearController;

  @override
  void initState() {
    super.initState();
    viewModel = EduinfoViewmodel();
    viewModel.degreeName(widget.degreeName);
    viewModel.institutionName(widget.institutionName);
    viewModel.totalGradeName(widget.totalGrade);
    viewModel.scoreGradeName(widget.scoreGrade);
    viewModel.achievementsName(widget.achievements);
    viewModel.startYearName(widget.startYear);
    viewModel.endYearName(widget.endYear);

    // fordocs

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = context.read<EduinfoViewmodel>();
      if (widget.editIndex != null) {
        await vm.loadEducationDataAt(email, widget.editIndex!);

        // preload into controllers
        degreeController.text = vm.degree;
        institutionController.text = vm.institution;
        totalGradeController.text = vm.totalGrade;
        scoreGradeController.text = vm.scoreGrade;
        achievementsController.text = vm.achievements;
        startYearController.text = vm.startYear;
        endYearController.text = vm.endYear;
      }
      setState(() {
        viewModel = vm;
      });
    });

    degreeController = TextEditingController(text: widget.degreeName);
    institutionController = TextEditingController(text: widget.institutionName);
    totalGradeController = TextEditingController(text: widget.totalGrade);
    scoreGradeController = TextEditingController(text: widget.scoreGrade);
    achievementsController = TextEditingController(text: widget.achievements);
    startYearController = TextEditingController(text: widget.startYear);
    endYearController = TextEditingController(text: widget.endYear);
  }

  @override
  void dispose() {
    degreeController.dispose();
    institutionController.dispose();
    totalGradeController.dispose();
    scoreGradeController.dispose();
    achievementsController.dispose();
    startYearController.dispose();
    endYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: _EducationInfoView(
        degreeController: degreeController,
        institutionController: institutionController,
        totalGradeController: totalGradeController,
        scoreGradeController: scoreGradeController,
        achievementsController: achievementsController,
        startYearController: startYearController,
        endYearController: endYearController,
        viewModel: viewModel,
        editIndex: widget.editIndex,
      ),
    );
  }
}

class _EducationInfoView extends StatelessWidget {
  final TextEditingController degreeController;
  final TextEditingController institutionController;
  final TextEditingController totalGradeController;
  final TextEditingController scoreGradeController;
  final TextEditingController achievementsController;
  final TextEditingController startYearController;
  final TextEditingController endYearController;
  final EduinfoViewmodel viewModel;
  final int? editIndex;
  const _EducationInfoView({
    required this.degreeController,
    required this.institutionController,
    required this.totalGradeController,
    required this.scoreGradeController,
    required this.achievementsController,
    required this.startYearController,
    required this.endYearController,
    required this.viewModel,
    this.editIndex,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EduinfoViewmodel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

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
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.04,
                screenHeight * 0.02,
                screenWidth * 0.04,
                100,
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
                      achievementsController: achievementsController,
                      startYearController: startYearController,
                      endYearController: endYearController,
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
                      // check data is enter than moce to next screen
                      if (degreeController.text.isEmpty ||
                          institutionController.text.isEmpty ||
                          totalGradeController.text.isEmpty ||
                          scoreGradeController.text.isEmpty ||
                          startYearController.text.isEmpty ||
                          endYearController.text.isEmpty) {
                        Utils().toastMessage("Enter all required fields");
                        return;
                      }

                      final viewmodel =
                          Provider.of<EduinfoViewmodel>(context, listen: false);
                      final String email = userMail;
                      if (kDebugMode) {
                        print("Saving for email: $email");
                      }
                      final info = EducationInfo(
                        degree: degreeController.text.trim(),
                        institution: institutionController.text.trim(),
                        totalGrade: totalGradeController.text.trim(),
                        scoreGrade: scoreGradeController.text.trim(),
                        achievements: achievementsController.text.trim(),
                        startYear: startYearController.text.trim(),
                        endYear: endYearController.text.trim(),
                        uploadedDocs: List<String>.from(viewModel.uploadedDocs),
                      );

                      if (kDebugMode) {
                        print("👤 Saving education info for: $email");
                        print("📚 Degree: ${info.degree}");
                        print("🏫 Institution: ${info.institution}");
                        print("📊 Total Grade: ${info.totalGrade}");
                        print("📈 Score Grade: ${info.scoreGrade}");
                        print("🏆 Achievements: ${info.achievements}");
                        print("📅 Start Year: ${info.startYear}");
                        print("📅 End Year: ${info.endYear}");
                        print(
                            "📂 Uploaded Docs: ${info.uploadedDocs.join(', ')}");
                      }
                      if (editIndex != null) {
                        await viewmodel.updateEducationInfoAt(
                            email, editIndex!, info);
                        Utils().toastMessage(
                            "Your record updated successfully...");
                      } else {
                        await viewmodel.saveEducationInfo(email, info);
                        Utils()
                            .toastMessage("Your record saved successfully...");
                      }
                      Navigator.pushNamed(context, AppRoutes.eduSave);
                      viewmodel.clearEduInfo();
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
      ),
    );
  }
}
