import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_divider.dart';
import '../../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordHidden = true; // State to toggle password visibility
  bool isChecked = false;
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: screenHeight * 0.09,
                          bottom: screenHeight * 0.02),
                      child: Image.asset(
                        'lib/assets/Images/logo.png',
                        width: screenWidth * 0.3,
                        height: screenHeight * 0.06,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      "Sign in to your\nAccount",
                      style:
                          AppTheme.getResponsiveTextTheme(context).displayLarge,
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Enter your email and password to log in ",
                      style: TextStyle(
                          color: AppTheme.secondaryColor,
                          fontSize: 16.0,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: screenHeight * 0.33, // Slightly below the white container
            left: screenWidth * 0.1,
            width: screenWidth * 0.8,
            child: Container(
              height: screenHeight * 0.5,
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
                      CustomButton(
                        icon: const Icon(
                          Icons.phone,
                          color: AppTheme.blackColor,
                        ),
                        text: 'Continue with Phone',
                        onPressed: () {
                          // button onPressed logic
                        },
                        color: AppTheme.whiteColor,
                        textColor: AppTheme.blackColor,
                        borderRadius: 10.0,
                        height: screenHeight * 0.055,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        children: [
                          const Expanded(
                            child: CustomDivider(
                              thickness: 1,
                              height: 1.0,
                              indent: 0,
                              endIndent: 0,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02),
                            child: const Text(
                              "Or login with",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: AppTheme.whiteColor,
                                fontSize: 14.0,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: CustomDivider(
                              thickness: 1,
                              height: 1.0,
                              indent: 0,
                              endIndent: 0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      const CustomTextField(
                        hintText: "person@gmail.com",
                        backgroundColor: AppTheme.whiteColor,
                        textColor: AppTheme.blackColor,
                        hintTextColor: AppTheme.greyColor,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      CustomTextField(
                        hintText: "***********",
                        backgroundColor: AppTheme.whiteColor,
                        textColor: AppTheme.blackColor,
                        hintTextColor: AppTheme.greyColor,
                        obscureText: _isPasswordHidden,
                        rightWidget: IconButton(
                          icon: Icon(
                            _isPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          color: AppTheme.greyColor,
                          iconSize: screenHeight * 0.02,
                          onPressed: () {
                            setState(() {
                              _isPasswordHidden = !_isPasswordHidden;
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            activeColor: Colors.transparent,
                            checkColor: Colors.white,
                            side: const BorderSide(
                              color: AppTheme.whiteColor,
                            ),
                            value: isChecked,
                            onChanged: (bool? newValue) {
                              setState(
                                () {
                                  isChecked = newValue ?? false;
                                },
                              );
                            },
                          ),
                          Text(
                            "Remember me",
                            style: AppTheme.getResponsiveTextTheme(context)
                                .bodyLarge,
                          ),
                          SizedBox(width: screenWidth * 0.08),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.forgotpsd);
                            },
                            child: Text(
                              "Forgot Password?",
                              style: AppTheme.getResponsiveTextTheme(context)
                                  .bodyLarge,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      CustomButton(
                        text: "Log In",
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.profile);
                        },
                        color: AppTheme.secondaryColor,
                        textColor: AppTheme.whiteColor,
                        borderRadius: 10.0,
                        height: screenHeight * 0.055,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(
                                color: AppTheme.greyColor,
                                fontSize: 13.0,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.signup);
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: AppTheme.whiteColor,
                                  fontSize: 13.0,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
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
