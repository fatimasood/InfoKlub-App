import 'package:flutter/material.dart';
import 'package:infoklub/app/routes.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/services/firebase_services/splash_services.dart';
import 'package:infoklub/utils/utils.dart';
import 'package:infoklub/viewmodels/carrer/career_viewmodel.dart';
import 'package:infoklub/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class CarrerAllInfo extends StatefulWidget {
  const CarrerAllInfo({super.key});

  @override
  State<CarrerAllInfo> createState() => _CarrerAllInfoState();
}

class _CarrerAllInfoState extends State<CarrerAllInfo> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<CareerViewmodel>(context, listen: false);
      viewModel.loadCareerList(); // load career list from Hive
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CareerViewmodel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios,
              color: AppTheme.textColor, size: 18),
        ),
        title: Text(
          "Add Career Information",
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
                constraints: BoxConstraints(minHeight: screenHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Career Information",
                      style:
                          AppTheme.getResponsiveTextTheme(context).labelMedium,
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      text: 'Add Experience',
                      color: Colors.white,
                      borderColor: Colors.grey,
                      borderRadius: 10.0,
                      textColor: AppTheme.blackColor,
                      icon: const Icon(Icons.add_circle, color: Colors.black),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.career)
                            .then((_) {
                          viewModel.loadCareerList();
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Added Information",
                      style:
                          AppTheme.getResponsiveTextTheme(context).labelMedium,
                    ),
                    const SizedBox(height: 7),

                    // Show full list of career entries
                    ...List.generate(viewModel.careerList.length, (i) {
                      final career = viewModel.careerList[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(243, 229, 245, 1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.work_history_outlined,
                                color: AppTheme.purpleAccent),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                career.jobTitle,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await viewModel.deleteCareerInfoAt(userMail, i);
                                viewModel.loadCareerList();
                              },
                              child: const Icon(Icons.delete,
                                  color: AppTheme.purpleAccent),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            /// SAVE BUTTON - pinned to bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                    bottom: 20, left: 10, right: 10, top: 0),
                child: CustomButton(
                  onPressed: () async {
                    Utils().toastMessage(
                        "Your career record saved successfully...");
                    await Future.delayed(const Duration(milliseconds: 500));
                    //  if (!mounted) return;
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.finishScreen);
                  },
                  width: double.infinity,
                  text: "Save Information",
                  color: AppTheme.purpleAccent,
                  borderRadius: 10.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
