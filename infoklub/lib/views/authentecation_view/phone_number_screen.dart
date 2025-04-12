import 'package:country_picker/country_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
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
                      Text(
                        "Enter your Phone \n\tNumber",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            color: AppTheme.whiteColor,
                            fontSize: screenHeight * 0.03,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.02),
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
                      SizedBox(height: screenHeight * 0.02),
                      CustomButton(
                        text: "Send OTP",
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.otp);
                        },
                        color: AppTheme.secondaryColor,
                        textColor: AppTheme.whiteColor,
                        borderRadius: 10.0,
                        height: screenHeight * 0.055,
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
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
                              Navigator.pushNamed(context, AppRoutes.login);
                            },
                            child: const Text(
                              "Login",
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
