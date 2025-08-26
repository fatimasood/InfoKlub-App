import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/models/cv/cv_creation_view_model.dart';
import 'package:infoklub/viewmodels/CV/cv_creation_view_model.dart';
import 'package:infoklub/viewmodels/CV/cv_view_model.dart';
import 'package:infoklub/views/CV/CV_creation/other_info_screen.dart';
import 'package:infoklub/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class EducationInfoScreen extends StatefulWidget {
  const EducationInfoScreen({super.key});

  @override
  State<EducationInfoScreen> createState() => _EducationInfoScreenState();
}

class _EducationInfoScreenState extends State<EducationInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _showAddForm = false;

  late TextEditingController _institutionController;
  late TextEditingController _degreeController;
  late TextEditingController _fieldOfStudyController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;

  // Add controllers for dates
  String? _startMonth;
  String? _startYear;
  String? _endMonth;
  String? _endYear;
  bool _isCurrentEducation = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _institutionController = TextEditingController();
    _degreeController = TextEditingController();
    _fieldOfStudyController = TextEditingController();
    _locationController = TextEditingController();
    _descriptionController = TextEditingController();

    // Pre-fill the form with existing data
    _prefillForm();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    _institutionController.dispose();
    _degreeController.dispose();
    _fieldOfStudyController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Method to pre-fill the form
  void _prefillForm() {
    // Access the ViewModel
    final cvViewModel = context.read<CvViewModel>();
    final cvData = cvViewModel.cvData;

    // Check if there is any education data
    if (cvData.education.isNotEmpty) {
      // For simplicity, we'll take the first education.
      Education firstEducation = cvData.education.first;

      // Set the text of the controllers to the saved values
      _institutionController.text = firstEducation.institution;
      _degreeController.text = firstEducation.degree;
      _fieldOfStudyController.text = firstEducation.fieldOfStudy ?? '';
      _locationController.text = '';
      _descriptionController.text = '';

      // Parse the year string to extract dates
      _parseDuration(firstEducation.year);
    }
  }

  void _parseDuration(String year) {
    if (year.contains('Present')) {
      _isCurrentEducation = true;
      // Extract start date from duration like "Jan 2020 - Present"
      final parts = year.split(' - ');
      if (parts.isNotEmpty) {
        final startParts = parts[0].split(' ');
        if (startParts.length >= 2) {
          _startMonth = startParts[0];
          _startYear = startParts[1];
        }
      }
    } else if (year.contains('-')) {
      // Extract dates from duration like "Jan 2020 - Dec 2022"
      final parts = year.split(' - ');
      if (parts.length >= 2) {
        final startParts = parts[0].split(' ');
        final endParts = parts[1].split(' ');

        if (startParts.length >= 2) {
          _startMonth = startParts[0];
          _startYear = startParts[1];
        }

        if (endParts.length >= 2) {
          _endMonth = endParts[0];
          _endYear = endParts[1];
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CvCreationViewModel>();
    final cvViewModel = context.watch<CvViewModel>();

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Education Details',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Display existing education entries with dividers
                  if (cvViewModel.cvData.education.isNotEmpty) ...[
                    Text(
                      'Your Education',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ..._buildEducationList(cvViewModel.cvData.education),
                    const SizedBox(height: 20),
                  ],

                  // Add New Education button and form
                  if (!_showAddForm && cvViewModel.cvData.education.isNotEmpty)
                    Center(
                      child: SizedBox(
                        width: 150,
                        child: CustomButton(
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: AppTheme.skyBlue,
                            size: 20,
                          ),
                          borderRadius: 15,
                          color: AppTheme.primaryColor,
                          text: "Add new",
                          textColor: AppTheme.skyBlue,
                          onPressed: () {
                            setState(() {
                              _showAddForm = true;
                            });
                          },
                        ),
                      ),
                    ),

                  if (_showAddForm || cvViewModel.cvData.education.isEmpty) ...[
                    if (cvViewModel.cvData.education.isNotEmpty) ...[
                      Divider(thickness: 2, color: Colors.grey[300]),
                      const SizedBox(height: 20),
                    ],
                    Text(
                      'Add New Education',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Institution",
                            style: TextStyle(
                              color: AppTheme.blackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 3.0),
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: _institutionController,
                            cursorColor: AppTheme.blackColor,
                            decoration: const InputDecoration(
                              hintText: 'University Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter institution name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          const Text(
                            "Degree",
                            style: TextStyle(
                              color: AppTheme.blackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 3.0),
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: _degreeController,
                            cursorColor: AppTheme.blackColor,
                            decoration: const InputDecoration(
                              hintText: 'Bachelor of Science',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter degree';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          const Text(
                            "Field of Study",
                            style: TextStyle(
                              color: AppTheme.blackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 3.0),
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: _fieldOfStudyController,
                            cursorColor: AppTheme.blackColor,
                            decoration: const InputDecoration(
                              hintText: 'Computer Science',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Date Selection Row
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Dates",
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Start Date",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: DropdownButtonFormField<
                                                  String>(
                                                isExpanded: true,
                                                value: _startMonth,
                                                hint: const Text('Month',
                                                    style: TextStyle(
                                                        fontSize: 12)),
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
                                                    .map((month) =>
                                                        DropdownMenuItem(
                                                          value: month,
                                                          child: Text(month,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12)),
                                                        ))
                                                    .toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    _startMonth = value;
                                                  });
                                                },
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0)),
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4),
                                                  isDense: true,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: DropdownButtonFormField<
                                                  String>(
                                                isExpanded: true,
                                                value: _startYear,
                                                hint: const Text('Year',
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                                items: List.generate(
                                                        50,
                                                        (index) =>
                                                            (DateTime.now()
                                                                        .year -
                                                                    index)
                                                                .toString())
                                                    .map((year) =>
                                                        DropdownMenuItem(
                                                          value: year,
                                                          child: Text(year,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12)),
                                                        ))
                                                    .toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    _startYear = value;
                                                  });
                                                },
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0)),
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4),
                                                  isDense: true,
                                                ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "End Date",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        if (!_isCurrentEducation)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: DropdownButtonFormField<
                                                    String>(
                                                  isExpanded: true,
                                                  value: _endMonth,
                                                  hint: const Text('Month',
                                                      style: TextStyle(
                                                          fontSize: 12)),
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
                                                      .map((month) =>
                                                          DropdownMenuItem(
                                                            value: month,
                                                            child: Text(month,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12)),
                                                          ))
                                                      .toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _endMonth = value;
                                                    });
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      borderSide: BorderSide(
                                                          color: Colors.grey),
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4),
                                                    isDense: true,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: DropdownButtonFormField<
                                                    String>(
                                                  isExpanded: true,
                                                  value: _endYear,
                                                  hint: const Text('Year',
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                  items: List.generate(
                                                          50,
                                                          (index) => (DateTime
                                                                          .now()
                                                                      .year -
                                                                  index)
                                                              .toString())
                                                      .map((year) =>
                                                          DropdownMenuItem(
                                                            value: year,
                                                            child: Text(year,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12)),
                                                          ))
                                                      .toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _endYear = value;
                                                    });
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      borderSide: BorderSide(
                                                          color: Colors.grey),
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4),
                                                    isDense: true,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        else
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              "Present",
                                              style: TextStyle(
                                                color: AppTheme.primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 4),
                              Row(
                                children: [
                                  Checkbox(
                                    activeColor: AppTheme.primaryColor,
                                    value: _isCurrentEducation,
                                    onChanged: (value) {
                                      setState(() {
                                        _isCurrentEducation = value ?? false;
                                      });
                                    },
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  const Text(
                                    "Currently Studying",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

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
                            style: TextStyle(color: Colors.black),
                            controller: _locationController,
                            cursorColor: AppTheme.blackColor,
                            decoration: const InputDecoration(
                              hintText: 'City, Country',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
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
                            style: TextStyle(color: Colors.black),
                            controller: _descriptionController,
                            maxLines: 5,
                            cursorColor: AppTheme.blackColor,
                            decoration: const InputDecoration(
                              hintText:
                                  'Describe your education, achievements, or relevant coursework',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  height: 45,
                                  text: "Cancel",
                                  color: Colors.grey[300]!,
                                  textColor: Colors.black,
                                  onPressed: () {
                                    setState(() {
                                      _showAddForm = false;
                                      _clearForm();
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomButton(
                                  height: 45,
                                  text: "Save",
                                  color: AppTheme.primaryColor,
                                  onPressed: () {
                                    _addEducation(cvViewModel);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomButton(
              text: "Next Step\t >",
              color: AppTheme.secondaryColor,
              onPressed: () {
                viewModel.nextStep();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OtherInfoScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _clearForm() {
    _institutionController.clear();
    _degreeController.clear();
    _fieldOfStudyController.clear();
    _locationController.clear();
    _descriptionController.clear();
    setState(() {
      _startMonth = null;
      _startYear = null;
      _endMonth = null;
      _endYear = null;
      _isCurrentEducation = false;
    });
  }

  List<Widget> _buildEducationList(List<Education> educations) {
    List<Widget> widgets = [];

    for (int i = 0; i < educations.length; i++) {
      final education = educations[i];

      widgets.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            education.institution,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            education.degree,
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
          if (education.fieldOfStudy != null &&
              education.fieldOfStudy!.isNotEmpty)
            Text(
              education.fieldOfStudy!,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          Text(
            education.year,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ));

      // Add divider if not the last item
      if (i < educations.length - 1) {
        widgets.add(Divider(thickness: 1, color: Colors.grey[300]));
        widgets.add(SizedBox(height: 16));
      }
    }

    return widgets;
  }

  void _addEducation(CvViewModel cvViewModel) {
    if (_institutionController.text.isEmpty || _degreeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter institution and degree")));
      return;
    }

    if (_startMonth == null || _startYear == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please select start date")));
      return;
    }

    if (!_isCurrentEducation && (_endMonth == null || _endYear == null)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Please select end date or mark as current education")));
      return;
    }

    // Create duration string
    String duration = '$_startMonth $_startYear';
    if (_isCurrentEducation) {
      duration += ' - Present';
    } else {
      duration += ' - $_endMonth $_endYear';
    }

    // Create new education
    final newEducation = Education(
      institution: _institutionController.text,
      degree: _degreeController.text,
      fieldOfStudy: _fieldOfStudyController.text.isNotEmpty
          ? _fieldOfStudyController.text
          : null,
      year: duration,
    );

    // Add to view model
    _addEducationToViewModel(cvViewModel, newEducation);

    // Clear the form and hide it
    setState(() {
      _showAddForm = false;
      _clearForm();
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Education added")));
  }

  void _addEducationToViewModel(CvViewModel cvViewModel, Education education) {
    // Create a new CVModel with the added education
    final newCvData = cvViewModel.cvData
        .copyWith(education: [...cvViewModel.cvData.education, education]);

    // Update the view model
    cvViewModel.updateCVData(newCvData);
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
