import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:infoklub/services/firebase_services/splash_services.dart';
import 'package:infoklub/utils/utils.dart';
import 'package:infoklub/views/create_profile/profile_setup.dart';
import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance; //initialize firebase

  bool _isPasswordHidden = true; // State to toggle password visibility
  bool isChecked = false;
  String _selectedFlag = '🇧🇩';
  String _selectedCode = '880';

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final dateBirthController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    dateBirthController.dispose();
  }

  void signup() {
    _auth
        .createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      Utils().toastMessage(value.user!.email.toString());
      userMail = emailController.text;

      print(userMail);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileSetup(
              initialName: firstNameController.text,
              initialLastName: lastNameController.text,
              initialEmail: emailController.text,
              initialPhone: phoneNumberController.text,
              initialDob: dateBirthController.text,
              initialFlag: _selectedFlag,
              initialCode: _selectedCode),
        ),
      );
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Utils()
          .toastMessage("Failed to register your account.Try Again Later..!!");
    });
  }

  @override
  void initState() {
    super.initState();
  }

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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextField(
                              controller: firstNameController,
                              hintText: "First Name",
                              width: screenWidth * 0.33,
                              backgroundColor: AppTheme.whiteColor,
                              textColor: AppTheme.blackColor,
                              hintTextColor: AppTheme.greyColor,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  Utils().toastMessage('Enter Name');
                                }
                                return null;
                              },
                            ),
                            CustomTextField(
                              controller: lastNameController,
                              hintText: "Last Name",
                              width: screenWidth * 0.33,
                              backgroundColor: AppTheme.whiteColor,
                              textColor: AppTheme.blackColor,
                              hintTextColor: AppTheme.greyColor,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  Utils().toastMessage('Enter Full Name');
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        CustomTextField(
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty ||
                                !value.endsWith('@gmail.com')) {
                              Utils()
                                  .toastMessage('Enter proper email address');
                            }

                            return null;
                          },
                          hintText: "Email",
                          backgroundColor: AppTheme.whiteColor,
                          textColor: AppTheme.blackColor,
                          hintTextColor: AppTheme.greyColor,
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        CustomTextField(
                          controller: phoneNumberController,
                          validator: (value) {
                            if (value!.isEmpty || value.length >= 11) {
                              Utils().toastMessage('Enter proper phone number');
                            }

                            return null;
                          },
                          hintText: "3200784539",
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          hintTextColor: Colors.grey,
                          leftWidget: GestureDetector(
                            onTap: () {
                              showCountryPicker(
                                context: context,
                                showPhoneCode: true,
                                countryListTheme: const CountryListThemeData(
                                  searchTextStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  inputDecoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: 'Search country',
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppTheme.primaryColor)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppTheme.primaryColor)),
                                  ),
                                  backgroundColor: Colors.white,
                                  textStyle: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
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
                              style: const TextStyle(
                                  fontSize: 24, color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        CustomTextField(
                          controller: dateBirthController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              Utils().toastMessage('Enter your Date of Birth');
                            }
                            return null;
                          },
                          hintText: "Date of Birth",
                          backgroundColor: AppTheme.whiteColor,
                          textColor: AppTheme.blackColor,
                          hintTextColor: AppTheme.greyColor,
                          leftWidget: GestureDetector(
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime(2000),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                                initialEntryMode:
                                    DatePickerEntryMode.calendarOnly,
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: AppTheme.primaryColor,
                                        onPrimary: AppTheme.whiteColor,
                                        onSurface: AppTheme.blackColor,
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              AppTheme.primaryColor,
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  dateBirthController.text =
                                      "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                                });
                              }
                            },
                            child: Icon(
                              Icons.calendar_month,
                              color: AppTheme.greyColor,
                              size: screenHeight * 0.02,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        CustomTextField(
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              Utils().toastMessage(
                                  'Kindly set any password that is atleast 6 charecters long and strong');
                            }

                            return null;
                          },
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
                            if (_formKey.currentState!.validate()) {
                              signup();
                            }
                          },
                          color: AppTheme.secondaryColor,
                          textColor: AppTheme.whiteColor,
                          borderRadius: 10.0,
                          height: screenHeight * 0.055,
                        ),
                        SizedBox(height: screenHeight * 0.01),
                      ],
                    ),
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
