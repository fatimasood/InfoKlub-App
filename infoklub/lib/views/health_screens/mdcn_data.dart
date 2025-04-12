import 'package:flutter/material.dart';
import 'package:infoklub/widgets/custom_button.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';

class MdcnData extends StatefulWidget {
  const MdcnData({super.key});

  @override
  State<MdcnData> createState() => _MdcnDataState();
}

class _MdcnDataState extends State<MdcnData> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _enteredSymptoms = [];
  bool _showHintText = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Prevent button from moving when the keyboard appears
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                top: screenHeight * 0.06,
                bottom: screenHeight * 0.04,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Do you have any symptoms/allergy?",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Image.asset(
                    'lib/assets/Images/frame.png',
                    width: screenWidth * 0.8,
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  // Symptoms input box with chips
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.tealAccent, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Wrap(
                      spacing: 4.0,
                      // runSpacing: 2.0,
                      children: [
                        // Display the entered symptoms as chips
                        ..._enteredSymptoms.map((symptom) {
                          return Chip(
                            label: Text(
                              symptom,
                              style: const TextStyle(
                                  color: AppTheme.tealAccent,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700),
                            ),
                            backgroundColor: AppTheme.backgreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(color: AppTheme.backgreen),
                            ),
                            deleteIcon: const Icon(Icons.close,
                                size: 18, color: AppTheme.tealAccent),
                            onDeleted: () {
                              setState(() {
                                _enteredSymptoms.remove(symptom);
                                if (_enteredSymptoms.isEmpty) {
                                  _showHintText = true; // Show hint again
                                }
                              });
                            },
                          );
                        }),
                        // Input field for adding symptoms
                        SizedBox(
                          width: 150,
                          child: TextField(
                            controller: _textController,
                            style: const TextStyle(
                              color: Colors.black, // Black text when typing
                            ),
                            onChanged: (value) {
                              setState(() {
                                _showHintText = false; // Hide hint when typing
                              });
                            },
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  _enteredSymptoms.add(value);
                                  _textController.clear();
                                });
                              }
                            },
                            decoration: InputDecoration(
                              hintText: _showHintText ? "Add symptom" : null,
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomButton(
              width: double.infinity,
              text: "Save Information",
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.healthdboard);
              },
              color: AppTheme.tealAccent,
              borderRadius: 10.0,
            ),
          ),
          const SizedBox(height: 16.0), // Space below button
        ],
      ),
    );
  }
}
