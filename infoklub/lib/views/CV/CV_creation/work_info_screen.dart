import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/models/cv/cv_creation_view_model.dart';
import 'package:infoklub/viewmodels/CV/cv_view_model.dart';
import 'package:infoklub/views/CV/CV_creation/education_info_screen.dart';
import 'package:infoklub/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class WorkInfoScreen extends StatefulWidget {
  const WorkInfoScreen({super.key});

  @override
  State<WorkInfoScreen> createState() => _WorkInfoScreenState();
}

class _WorkInfoScreenState extends State<WorkInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _showAddForm = false;

  late TextEditingController _companyController;
  late TextEditingController _jobTitleController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;

  // Add controllers for dates
  String? _startMonth;
  String? _startYear;
  String? _endMonth;
  String? _endYear;
  bool _isCurrentJob = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _companyController = TextEditingController();
    _jobTitleController = TextEditingController();
    _locationController = TextEditingController();
    _descriptionController = TextEditingController();

    // Pre-fill the form with existing data
    _prefillForm();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    _companyController.dispose();
    _jobTitleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Method to pre-fill the form
  void _prefillForm() {
    // Access the ViewModel
    final cvViewModel = context.read<CvViewModel>();
    final cvData = cvViewModel.cvData;

    // Check if there is any work experience data
    if (cvData.workExperience.isNotEmpty) {
      // For simplicity, we'll take the first work experience.
      WorkExperience firstJob = cvData.workExperience.first;

      // Set the text of the controllers to the saved values
      _companyController.text = firstJob.company;
      _jobTitleController.text = firstJob.position;
      _locationController.text = firstJob.location ?? '';
      _descriptionController.text = firstJob.description ?? '';

      // Parse the duration string to extract dates
      _parseDuration(firstJob.duration);
    }
  }

  void _parseDuration(String duration) {
    if (duration.contains('Present')) {
      _isCurrentJob = true;
      // Extract start date from duration like "Jan 2020 - Present"
      final parts = duration.split(' - ');
      if (parts.isNotEmpty) {
        final startParts = parts[0].split(' ');
        if (startParts.length >= 2) {
          _startMonth = startParts[0];
          _startYear = startParts[1];
        }
      }
    } else if (duration.contains('-')) {
      // Extract dates from duration like "Jan 2020 - Dec 2022"
      final parts = duration.split(' - ');
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
    final viewModel = context.watch<CvViewModel>();
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
                      'Work Experience',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Display existing career entries with dividers
                  if (cvViewModel.cvData.workExperience.isNotEmpty) ...[
                    const Text(
                      'Your Work Experiences',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ..._buildCareerList(cvViewModel.cvData.workExperience),
                    const SizedBox(height: 20),
                  ],

                  // Add New Experience button and form
                  if (!_showAddForm &&
                      cvViewModel.cvData.workExperience.isNotEmpty)
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

                  if (_showAddForm ||
                      cvViewModel.cvData.workExperience.isEmpty) ...[
                    if (cvViewModel.cvData.workExperience.isNotEmpty) ...[
                      Divider(thickness: 2, color: Colors.grey[300]),
                      const SizedBox(height: 20),
                    ],
                    const Text(
                      'Add New Experience',
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
                            "Employer",
                            style: TextStyle(
                              color: AppTheme.blackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 3.0),
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            controller: _companyController,
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
                                                              style:
                                                                  const TextStyle(
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
                                                              style:
                                                                  const TextStyle(
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
                                        if (!_isCurrentJob)
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
                                                                style:
                                                                    const TextStyle(
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
                                                                style:
                                                                    const TextStyle(
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
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
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
                              Checkbox(
                                activeColor: AppTheme.primaryColor,
                                value: _isCurrentJob,
                                onChanged: (value) {
                                  setState(() {
                                    _isCurrentJob = value ?? false;
                                  });
                                },
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              const Text(
                                "Currently Working ?",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
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
                            style: const TextStyle(color: Colors.black),
                            controller: _jobTitleController,
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
                            style: const TextStyle(color: Colors.black),
                            controller: _locationController,
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
                            style: const TextStyle(color: Colors.black),
                            controller: _descriptionController,
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
                                    _addWorkExperience(cvViewModel);
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
                    builder: (context) => const EducationInfoScreen(),
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
    _companyController.clear();
    _jobTitleController.clear();
    _locationController.clear();
    _descriptionController.clear();
    setState(() {
      _startMonth = null;
      _startYear = null;
      _endMonth = null;
      _endYear = null;
      _isCurrentJob = false;
    });
  }

  List<Widget> _buildCareerList(List<WorkExperience> experiences) {
    List<Widget> widgets = [];

    for (int i = 0; i < experiences.length; i++) {
      final experience = experiences[i];

      widgets.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            experience.company,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            experience.position,
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
          Row(
            children: [
              Text(
                experience.duration,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              if (experience.location != null &&
                  experience.location!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "•",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
              if (experience.location != null &&
                  experience.location!.isNotEmpty)
                Text(
                  experience.location!,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          if (experience.description != null &&
              experience.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                experience.description!,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ));

      // Add divider if not the last item
      if (i < experiences.length - 1) {
        widgets.add(Divider(thickness: 1, color: Colors.grey[300]));
        widgets.add(const SizedBox(height: 16));
      }
    }

    return widgets;
  }

  void _addWorkExperience(CvViewModel cvViewModel) {
    if (_companyController.text.isEmpty || _jobTitleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter company and job title")));
      return;
    }

    if (_startMonth == null || _startYear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select start date")));
      return;
    }

    if (!_isCurrentJob && (_endMonth == null || _endYear == null)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please select end date or mark as current job")));
      return;
    }

    // Create duration string
    String duration = '$_startMonth $_startYear';
    if (_isCurrentJob) {
      duration += ' - Present';
    } else {
      duration += ' - $_endMonth $_endYear';
    }

    // Create new work experience
    final newExperience = WorkExperience(
      company: _companyController.text,
      position: _jobTitleController.text,
      location:
          _locationController.text.isNotEmpty ? _locationController.text : null,
      description: _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : null,
      duration: duration,
    );

    // Add to view model
    _addWorkExperienceToViewModel(cvViewModel, newExperience);

    // Clear the form and hide it
    setState(() {
      _showAddForm = false;
      _clearForm();
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Work experience added")));
  }

  void _addWorkExperienceToViewModel(
      CvViewModel cvViewModel, WorkExperience experience) {
    // Create a new CVModel with the added experience
    final newCvData = cvViewModel.cvData.copyWith(
        workExperience: [...cvViewModel.cvData.workExperience, experience]);

    // Update the view model
    cvViewModel.updateCVData(newCvData);
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final steps = ['Contact', 'Work', 'Education', 'Others', 'Save'];

    return Consumer<CvViewModel>(
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
