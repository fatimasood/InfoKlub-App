import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/viewmodels/CV/cv_creation_view_model.dart';
import 'package:infoklub/views/CV/CV_creation/education_info_screen.dart';
import 'package:infoklub/widgets/custom_button.dart';

import 'package:provider/provider.dart';

class WorkInfoScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  WorkInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CvCreationViewModel>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppTheme.primaryColor,
          ),
          onPressed: () {
            viewModel.previousStep();
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Create CV',
          style: TextStyle(color: AppTheme.primaryColor, fontSize: 20.0),
        ),
      ),
      body: Column(
        children: [
          _buildProgressIndicator(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Work Experience',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Employer",
                      style: TextStyle(
                        color: AppTheme.blackColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    TextFormField(
                      cursorColor: AppTheme.blackColor,
                      decoration: const InputDecoration(
                        hintText: 'Company Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      onChanged: (value) =>
                          viewModel.updateContactInfo(firstName: value),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Start Date",
                                style: TextStyle(
                                  color: AppTheme.blackColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 3.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      value: null,
                                      hint: const Text('Month'),
                                      items: [
                                        'Jan',
                                        'Feb',
                                        'Mar',
                                        'Apr',
                                        'May',
                                        'Jun',
                                        'Jul',
                                        'Aug',
                                        'Sep',
                                        'Oct',
                                        'Nov',
                                        'Dec'
                                      ]
                                          .map((month) => DropdownMenuItem(
                                                value: month,
                                                child: Text(month),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        // Handle start month selection
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15.0),
                                          ),
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15.0),
                                          ),
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                      ),
                                      dropdownColor: AppTheme.whiteColor,
                                      menuMaxHeight: 200,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      value: null,
                                      hint: const Text('Year'),
                                      items: List.generate(
                                              50,
                                              (index) =>
                                                  (DateTime.now().year - index)
                                                      .toString())
                                          .map((year) => DropdownMenuItem(
                                                value: year,
                                                child: Text(year),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        // Handle start year selection
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15.0),
                                          ),
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15.0),
                                          ),
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15.0),
                                          ),
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                      ),
                                      dropdownColor: Colors.white,
                                      icon: Icon(Icons.arrow_drop_down,
                                          color: Colors.grey),
                                      style: TextStyle(color: Colors.black),
                                      menuMaxHeight:
                                          200, // Limits dropdown height
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "End Date",
                                style: TextStyle(
                                  color: AppTheme.blackColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 3.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      value: null,
                                      hint: const Text('Month'),
                                      items: [
                                        'Jan',
                                        'Feb',
                                        'Mar',
                                        'Apr',
                                        'May',
                                        'Jun',
                                        'Jul',
                                        'Aug',
                                        'Sep',
                                        'Oct',
                                        'Nov',
                                        'Dec'
                                      ]
                                          .map((month) => DropdownMenuItem(
                                                value: month,
                                                child: Text(month),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        // Handle end month selection
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15.0),
                                          ),
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15.0),
                                          ),
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15.0),
                                          ),
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                      ),
                                      dropdownColor: Colors.white,
                                      icon: Icon(Icons.arrow_drop_down,
                                          color: Colors.grey),
                                      style: TextStyle(color: Colors.black),
                                      menuMaxHeight:
                                          200, // Limits dropdown height
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      value: null,
                                      hint: const Text('Year'),
                                      items: List.generate(
                                              50,
                                              (index) =>
                                                  (DateTime.now().year - index)
                                                      .toString())
                                          .map((year) => DropdownMenuItem(
                                                value: year,
                                                child: Text(year),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        // Handle end year selection
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15.0),
                                          ),
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15.0),
                                          ),
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15.0),
                                          ),
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                      ),

                                      dropdownColor: Colors.white,
                                      icon: Icon(Icons.arrow_drop_down,
                                          color: Colors.grey),
                                      style: TextStyle(color: Colors.black),
                                      menuMaxHeight:
                                          200, // Limits dropdown height
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Job Title",
                      style: TextStyle(
                        color: AppTheme.blackColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    TextFormField(
                      cursorColor: AppTheme.blackColor,
                      decoration: const InputDecoration(
                        hintText: 'Sales Manager',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      onChanged: (value) =>
                          viewModel.updateContactInfo(lastName: value),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Location",
                      style: TextStyle(
                        color: AppTheme.blackColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    TextFormField(
                      cursorColor: AppTheme.blackColor,
                      decoration: const InputDecoration(
                        hintText: 'xyz city, Bangladesh',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) =>
                          viewModel.updateContactInfo(email: value),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Description",
                      style: TextStyle(
                        color: AppTheme.blackColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    TextFormField(
                      maxLines: 5,
                      cursorColor: AppTheme.blackColor,
                      decoration: const InputDecoration(
                        hintText:
                            'Describe your tasks, responsibilities related to this work experience',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      onChanged: (value) =>
                          viewModel.updateContactInfo(phone: value),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 130,
            //height: 50,
            child: CustomButton(
              icon: const Icon(
                Icons.add_circle_outline,
                color: AppTheme.skyBlue,
              ),
              borderRadius: 15,
              color: AppTheme.primaryColor,
              text: "Add new",
              textColor: AppTheme.skyBlue,
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomButton(
              text: "Next Step\t >",
              color: AppTheme.secondaryColor,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Proceed to next step
                  viewModel.nextStep();

                  // Navigate to education screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EducationInfoScreen(),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final steps = ['Contact', 'Work', 'Education', 'Others', 'Save'];

    return Consumer<CvCreationViewModel>(
      builder: (context, viewModel, _) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              // Progress line with circles
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: [
                    // Connecting line background
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 10,
                      child: Container(
                        height: 2,
                        color: Colors.grey[300],
                      ),
                    ),
                    // Progress line (colored part)
                    Positioned(
                      left: 0,
                      top: 10,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: (MediaQuery.of(context).size.width - 40) *
                            (viewModel.currentStep / (steps.length - 1)),
                        height: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    // Circles and labels
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: steps.asMap().entries.map((entry) {
                        final index = entry.key;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index <= viewModel.currentStep
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              entry.value,
                              style: TextStyle(
                                fontSize: 12,
                                color: index <= viewModel.currentStep
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
