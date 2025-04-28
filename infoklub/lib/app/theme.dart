import 'package:flutter/material.dart';

class AppTheme {
  // Define the main colors
  static const Color primaryColor = Color(0xff164863);
  static const Color secondaryColor = Color(0xff427D9D);
  static const Color whiteColor = Color(0xffffffff);
  static const Color halfwhite = Color.fromARGB(255, 251, 250, 245);
  // Additional frequently used colors
  static const Color redAccent = Color(0xFFE50026);
  static const Color mintGreen = Color(0xFFA3E4D7);
  static const Color lightsecondary = Color(0xFF98C1D9);
  static const Color skyBlue = Color(0xFFC6E7FF);
  static const Color lavender = Color(0xFFD9C6FB);
  static const Color purpleAccent = Color(0xFF6B3EB8);
  static const Color azureBlue = Color(0xFF0467AB);
  static const Color forestGreen = Color(0xFF005E49);
  static const Color tealAccent = Color(0xFF00B88F);
  static const Color coralAccent = Color(0xFFEE6C4D);
  static const Color blackColor = Color(0xFF000000);
  static const Color greyColor = Color(0xFF9E9E9E);
  static const Color textColor = Color(0xff03314B);
  static const Color backgreen = Color(0xffC8EFE7);
  static const Color greyblacktext = Color(0xff5D6A85);

  // Helper method to calculate responsive font size
  static double getResponsiveFontSize(
      BuildContext context, double baseFontSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Assume 375 is the base width used in the design
    return baseFontSize * (screenWidth / 375);
  }

  // Responsive text theme
  static TextTheme getResponsiveTextTheme(BuildContext context) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w800,
        color: primaryColor,
        fontSize: getResponsiveFontSize(context, 35.0), // Adjust dynamically
      ),
      displayMedium: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w900,
        color: AppTheme.blackColor,
        fontSize: getResponsiveFontSize(context, 30.0),
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        color: azureBlue,
        fontSize: getResponsiveFontSize(context, 26.0),
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: getResponsiveFontSize(context, 12.0), // Adjust dynamically
        fontWeight: FontWeight.normal,
        color: secondaryColor,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: getResponsiveFontSize(context, 18.0), // Adjust dynamically
        fontWeight: FontWeight.w700,
        // color: blackColor,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: getResponsiveFontSize(context, 13.0), // Adjust dynamically
        fontWeight: FontWeight.normal,
        color: whiteColor,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: getResponsiveFontSize(context, 23.0),
        fontWeight: FontWeight.w900,
        color: AppTheme.textColor,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: getResponsiveFontSize(context, 17.0),
        fontWeight: FontWeight.w700,
        color: AppTheme.textColor,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: getResponsiveFontSize(context, 14.0),
        fontWeight: FontWeight.w400,
        color: AppTheme.blackColor,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: getResponsiveFontSize(context, 16.0),
        fontWeight: FontWeight.w400,
        color: AppTheme.textColor,
      ),
    );
  }

  // Main app theme
  static ThemeData getThemeData(BuildContext context) {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: whiteColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: whiteColor,
        foregroundColor: whiteColor,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: whiteColor,
        ),
      ),
      textTheme: getResponsiveTextTheme(context),
      buttonTheme: const ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            //  fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppTheme.blackColor,
        //size: 20,
      ),
    );
  }
}
