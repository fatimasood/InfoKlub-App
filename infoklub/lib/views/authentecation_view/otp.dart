import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight * 0.5,
                color: AppTheme.whiteColor,
                child: Padding(
                  padding: const EdgeInsets.all(100.0),
                  child: Image.asset(
                    'lib/assets/Images/logo.png',
                    width: screenWidth * 0.2,
                    height: screenHeight * 0.1,
                    alignment: Alignment.topCenter,
                    //fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: screenHeight * 0.35, // Slightly below the white container
            left: screenWidth * 0.1,
            width: screenWidth * 0.8,
            child: Container(
              height: screenHeight * 0.35,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: screenHeight * 0.03,
                  bottom: screenHeight * 0.02,
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05,
                ),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        "OTP",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            color: AppTheme.whiteColor,
                            fontSize: screenHeight * 0.03,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        "We send you Email please check\n your Mail and Complete OTP Code ",
                        style:
                            AppTheme.getResponsiveTextTheme(context).bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextField(
                            textAlign: TextAlign.center,
                            hintText: "1",
                            width: screenWidth * 0.15,
                            backgroundColor: AppTheme.whiteColor,
                            textColor: AppTheme.blackColor,
                            hintTextColor: AppTheme.greyColor,
                          ),
                          CustomTextField(
                            textAlign: TextAlign.center,
                            hintText: "6",
                            width: screenWidth * 0.15,
                            backgroundColor: AppTheme.whiteColor,
                            textColor: AppTheme.blackColor,
                            hintTextColor: AppTheme.greyColor,
                          ),
                          CustomTextField(
                            textAlign: TextAlign.center,
                            hintText: "4",
                            width: screenWidth * 0.15,
                            backgroundColor: AppTheme.whiteColor,
                            textColor: AppTheme.blackColor,
                            hintTextColor: AppTheme.greyColor,
                          ),
                          CustomTextField(
                            textAlign: TextAlign.center,
                            hintText: "2",
                            width: screenWidth * 0.15,
                            backgroundColor: AppTheme.whiteColor,
                            textColor: AppTheme.blackColor,
                            hintTextColor: AppTheme.greyColor,
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      CustomButton(
                        text: "CONFIRM",
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.forgotpsd);
                        },
                        color: AppTheme.secondaryColor,
                        textColor: AppTheme.whiteColor,
                        borderRadius: 10.0,
                        height: screenHeight * 0.055,
                      ),
                      SizedBox(height: screenHeight * 0.03),
                    ],
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
