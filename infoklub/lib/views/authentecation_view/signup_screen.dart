import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
//import 'package:country_pickers/country.dart';
import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_divider.dart';
import '../../widgets/custom_textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isPasswordHidden = true; // State to toggle password visibility
  bool isChecked = false;
  String _selectedFlag = '🇧🇩';
  String _selectedCode = '880';
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
                      "Sign Up",
                      style:
                          AppTheme.getResponsiveTextTheme(context).displayLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          textAlign: TextAlign.center,
                          "Already have an account?  ",
                          style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 16.0,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.login);
                          },
                          child: const Text(
                            " Log in",
                            style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 16.0,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          //signup
          Positioned(
            top: screenHeight * 0.28, // Slightly below the white container
            left: screenWidth * 0.1,
            width: screenWidth * 0.8,
            child: Container(
              height: screenHeight * 0.6,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextField(
                            hintText: "First Name",
                            width: screenWidth * 0.33,
                            backgroundColor: AppTheme.whiteColor,
                            textColor: AppTheme.blackColor,
                            hintTextColor: AppTheme.greyColor,
                          ),
                          CustomTextField(
                            hintText: "Last Name",
                            width: screenWidth * 0.33,
                            backgroundColor: AppTheme.whiteColor,
                            textColor: AppTheme.blackColor,
                            hintTextColor: AppTheme.greyColor,
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      const CustomTextField(
                        hintText: "Email",
                        backgroundColor: AppTheme.whiteColor,
                        textColor: AppTheme.blackColor,
                        hintTextColor: AppTheme.greyColor,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      CustomTextField(
                        hintText: "$_selectedCode 726-0592",
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        hintTextColor: Colors.grey,
                        leftWidget: GestureDetector(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: true,
                              onSelect: (Country country) {
                                if (kDebugMode) {
                                  print(
                                      'Selected country: ${country.displayName}');
                                }
                                setState(() {
                                  _selectedFlag = country.flagEmoji;
                                  _selectedCode =
                                      '+${country.phoneCode}'; // Set the country code
                                });
                              },
                            );
                          },
                          child: Text(
                            _selectedFlag, // Display emoji directly
                            style: const TextStyle(fontSize: 24), // Adjust size
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      CustomTextField(
                        hintText: "Date of Birth",
                        backgroundColor: AppTheme.whiteColor,
                        textColor: AppTheme.blackColor,
                        hintTextColor: AppTheme.greyColor,
                        leftWidget: Icon(
                          Icons.calendar_month,
                          color: AppTheme.greyColor,
                          size: screenHeight * 0.02,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
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
                      SizedBox(height: screenHeight * 0.02),
                      CustomButton(
                        text: "Sign Up",
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.profile);
                        },
                        color: AppTheme.secondaryColor,
                        textColor: AppTheme.whiteColor,
                        borderRadius: 10.0,
                        height: screenHeight * 0.055,
                      ),
                      SizedBox(height: screenHeight * 0.01),
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
                                horizontal: screenWidth * 0.01),
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
                      SizedBox(height: screenHeight * 0.01),
                      CustomButton(
                        icon: const Icon(
                          Icons.phone,
                          color: AppTheme.blackColor,
                        ),
                        text: 'Sign up with Phone',
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.phone);
                        },
                        color: AppTheme.whiteColor,
                        textColor: AppTheme.blackColor,
                        borderRadius: 10.0,
                        height: screenHeight * 0.055,
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
