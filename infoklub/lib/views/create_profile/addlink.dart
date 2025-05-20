import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/widgets/custom_input.dart';
import '../../app/routes.dart';
import '../../widgets/custom_button.dart';

class Addlink extends StatefulWidget {
  const Addlink({super.key});

  @override
  State<Addlink> createState() => _AddlinkState();
}

class _AddlinkState extends State<Addlink> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.halfwhite,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: screenHeight * 0.02,
                  // bottom: screenHeight * 0.6, // Add space for the fixed button
                  left: screenWidth * 0.01,
                  right: screenWidth * 0.01,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 3.0,
                          ),
                          Text(
                            "Add Portfolio",
                            style: AppTheme.getResponsiveTextTheme(context)
                                .labelLarge,
                          ),
                          const SizedBox(height: 2.0),
                          const Text(
                            "Kindly enter at least 1 portfolio",
                            style: TextStyle(
                                fontSize: 13.5,
                                color: AppTheme.greyColor,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Behance",
                          textAlign: TextAlign.start,
                          style: AppTheme.getResponsiveTextTheme(context)
                              .displaySmall,
                        ),
                        const SizedBox(height: 6.0),
                        const CustomInput(
                          backgroundColor: AppTheme.halfwhite,
                          hintText: 'https://',
                          keyboardType: TextInputType.url,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "Dribble",
                          textAlign: TextAlign.start,
                          style: AppTheme.getResponsiveTextTheme(context)
                              .displaySmall,
                        ),
                        const SizedBox(height: 6.0),
                        const CustomInput(
                          backgroundColor: AppTheme.halfwhite,
                          hintText: 'https://',
                          keyboardType: TextInputType.url,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "Github",
                          textAlign: TextAlign.start,
                          style: AppTheme.getResponsiveTextTheme(context)
                              .displaySmall,
                        ),
                        const SizedBox(height: 6.0),
                        const CustomInput(
                          backgroundColor: AppTheme.halfwhite,
                          hintText: 'https://',
                          keyboardType: TextInputType.url,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "Linkedln",
                          textAlign: TextAlign.start,
                          style: AppTheme.getResponsiveTextTheme(context)
                              .displaySmall,
                        ),
                        const SizedBox(height: 6.0),
                        const CustomInput(
                          backgroundColor: AppTheme.halfwhite,
                          hintText: 'https://',
                          keyboardType: TextInputType.url,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "Website",
                          textAlign: TextAlign.start,
                          style: AppTheme.getResponsiveTextTheme(context)
                              .displaySmall,
                        ),
                        const SizedBox(height: 6.0),
                        const CustomInput(
                          backgroundColor: AppTheme.halfwhite,
                          hintText: 'https://',
                          keyboardType: TextInputType.url,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 20.0,
                left: 10.0,
                right: 10.0,
                child: CustomButton(
                  text: "Next",
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.infodashboard);
                  },
                  color: AppTheme.secondaryColor,
                  borderRadius: 10.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
