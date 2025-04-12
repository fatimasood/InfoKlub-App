import 'package:flutter/material.dart';

import '../app/theme.dart';

Widget dropfiles() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20.0),
    decoration: BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(color: Colors.grey[400]!),
    ),
    child: Column(
      children: [
        GestureDetector(
          child: Image.asset(
            'lib/assets/Images/upload.png',
            width: 100,
            height: 100,
          ),
          onTap: () {
            // Define the tap action
            debugPrint("Upload button tapped");
          },
        ),
        const SizedBox(height: 10),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "Drag & drop files ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "or ",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: "Browse",
                style: TextStyle(
                  color: AppTheme.secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          "Supported formats: JPEG, PNG, PDF, PSD, Word",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
