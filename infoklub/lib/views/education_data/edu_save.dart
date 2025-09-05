import 'package:flutter/material.dart';
import 'package:infoklub/services/firebase_services/splash_services.dart';
import 'package:infoklub/utils/utils.dart';
import 'package:infoklub/viewmodels/education/eduinfo_viewmodel.dart';
import 'package:infoklub/views/education_data/edu_info.dart';
import 'package:infoklub/views/home_view/main_home.dart';
import 'package:infoklub/widgets/custom_button.dart';
import 'package:infoklub/app/theme.dart';
import 'package:provider/provider.dart';
import '../../app/routes.dart';

class EduSave extends StatefulWidget {
  final bool isEdit;
  const EduSave({super.key, this.isEdit = false});

  @override
  State<EduSave> createState() => _EduSaveState();
}

class _EduSaveState extends State<EduSave> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EduinfoViewmodel>(context);
    final educationList = viewModel.getAllEducationEntries(userMail);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                    Text(
                      "Education Information",
                      style:
                          AppTheme.getResponsiveTextTheme(context).labelMedium,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                        Navigator.pushNamed(context, AppRoutes.eduData);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Added Information",
                      style:
                          AppTheme.getResponsiveTextTheme(context).labelMedium,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    for (int i = 0; i < educationList.length; i++)
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 60,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 225, 244, 255),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.school,
                              color: AppTheme.secondaryColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                educationList[i].degree,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (viewModel.isEditMode)
                              IconButton(
                                color: AppTheme.secondaryColor,
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EduInfo(
                                        editIndex: i,
                                        degreeName: educationList[i].degree,
                                        institutionName:
                                            educationList[i].institution,
                                        totalGrade: educationList[i].totalGrade,
                                        scoreGrade: educationList[i].scoreGrade,
                                        startYear: educationList[i].startYear,
                                        endYear: educationList[i].endYear,
                                        achievements:
                                            educationList[i].achievements,
                                        document: educationList[i]
                                                .uploadedDocs
                                                .isNotEmpty
                                            ? educationList[i]
                                                .uploadedDocs
                                                .first
                                            : '',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () async => await viewModel
                                  .deleteEducationInfoAt(userMail, i),
                              child: const Icon(
                                Icons.delete,
                                color: AppTheme.redAccent,
                              ),
                            ),
                          ],
                        ),
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
                padding: const EdgeInsets.only(
                    bottom: 20, left: 10, right: 10, top: 0),
                child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    onPressed: () async {
                      (userMail); // Correctly initialize the ViewModel

                      if (viewModel.isEditMode) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const MainHome(initialIndex: 1)));
                      } else {
                        Utils().toastMessage(
                            "Your education record saved successfully...");
                        await Future.delayed(const Duration(milliseconds: 500));

                        if (!mounted) return;
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.infodashboard,
                            arguments: userMail);
                      }
                    },
                    width: double.infinity,
                    text: "Save Information",
                    color: AppTheme.secondaryColor,
                    borderRadius: 10.0,
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
