import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final Widget? leftWidget; // Can be an Icon or a Dropdown
  final Widget? rightWidget; // Can be a Button/Icon/etc.
  final Function()? onRightIconPressed;
  final bool obscureText;
  final double? height;
  final double? width;
  final TextAlign textAlign;
  final Color backgroundColor;
  final Color textColor;
  final Color hintTextColor;
  final List<Map<String, String>>? countryDropdownData;
  final Function(String)? onCountrySelected;

  const CustomInput({
    super.key,
    this.hintText = '',
    this.controller,
    this.keyboardType = TextInputType.text,
    this.leftWidget,
    this.rightWidget,
    this.onRightIconPressed,
    this.height,
    this.width,
    this.obscureText = false,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.hintTextColor = Colors.grey,
    this.countryDropdownData,
    this.onCountrySelected,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the top
        children: [
          // Left Widget (Optional, could be Icon or Dropdown)
          if (leftWidget != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 10),
              child: leftWidget!,
            ),

          // Country Dropdown (Optional)
          if (countryDropdownData != null && leftWidget == null) ...[
            DropdownButton<String>(
              value: countryDropdownData?.first['code'], // Default value
              icon: const Icon(Icons.arrow_drop_down),
              underline: const SizedBox(), // Removes underline
              onChanged: (value) {
                if (onCountrySelected != null) {
                  onCountrySelected!(value!);
                }
              },
              items: countryDropdownData?.map((country) {
                return DropdownMenuItem<String>(
                  value: country['code'],
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        country['flag']!,
                        width: 24,
                        height: 24,
                      ),
                      // const SizedBox(width: 8.0),
                      Text(
                        country['name']!,
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],

          // Input Field
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              style: TextStyle(color: textColor),
              textAlign: textAlign,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: hintTextColor),
                border: InputBorder.none,
              ),
            ),
          ),

          // Right Widget (Optional)
          if (rightWidget != null) rightWidget!,
        ],
      ),
    );
  }
}
