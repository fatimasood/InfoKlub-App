import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/models/cv/cv_creation_view_model.dart';
import 'package:infoklub/models/education/education_model.dart';
import 'package:infoklub/services/firebase_services/splash_services.dart';
import 'package:infoklub/viewmodels/CV/cv_view_model.dart';
import 'package:infoklub/viewmodels/education/eduinfo_viewmodel.dart';
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
  late TextEditingController _totalGradeController;
  late TextEditingController _scoreGradeController;
  late TextEditingController _achievementsController;
  late TextEditingController _startYearController;
  late TextEditingController _endYearController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _institutionController = TextEditingController();
    _degreeController = TextEditingController();
    _totalGradeController = TextEditingController();
    _scoreGradeController = TextEditingController();
    _achievementsController = TextEditingController();
    _startYearController = TextEditingController();
    _endYearController = TextEditingController();

    // Load education data from Hive
    _loadEducationData();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    _institutionController.dispose();
    _degreeController.dispose();
    _totalGradeController.dispose();
    _scoreGradeController.dispose();
    _achievementsController.dispose();
    _startYearController.dispose();
    _endYearController.dispose();
    super.dispose();
  }

  Future<void> _loadEducationData() async {
    final eduViewModel = Provider.of<EduinfoViewmodel>(context, listen: false);
    final cvViewModel = Provider.of<CvViewModel>(context, listen: false);

    // Load education data from Hive
    await eduViewModel.loadEducationData(userMail);

    // Update CV data with loaded education info
    final educationEntries = eduViewModel.getAllEducationEntries(userMail);
    final cvEducationList = educationEntries.map((eduInfo) {
      return Education(
        institution: eduInfo.institution,
        degree: eduInfo.degree,
        year: "${eduInfo.startYear}-${eduInfo.endYear}",
        fieldOfStudy: null,
      );
    }).toList();

    cvViewModel
        .updateCVData(cvViewModel.cvData.copyWith(education: cvEducationList));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CvViewModel>();

    final eduViewModel = context.watch<EduinfoViewmodel>();

    // Get actual education data from Hive
    final educationEntries = eduViewModel.getAllEducationEntries(userMail);

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
                  if (educationEntries.isNotEmpty) ...[
                    const Text(
                      'Your Education',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ..._buildEducationList(educationEntries),
                    const SizedBox(height: 20),
                  ],

                  // Add New Education button and form
                  if (!_showAddForm && educationEntries.isNotEmpty)
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

                  if (_showAddForm || educationEntries.isEmpty) ...[
                    if (educationEntries.isNotEmpty) ...[
                      Divider(thickness: 2, color: Colors.grey[300]),
                      const SizedBox(height: 20),
                    ],
                    Text(
                      educationEntries.isEmpty
                          ? 'Add Education'
                          : 'Add New Education',
                      style: const TextStyle(
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
                            style: const TextStyle(color: Colors.black),
                            controller: _institutionController,
                            cursorColor: AppTheme.blackColor,
                            decoration: const InputDecoration(
                              hintText: 'University/School Name',
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
                            "Degree/Certificate",
                            style: TextStyle(
                              color: AppTheme.blackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 3.0),
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            controller: _degreeController,
                            cursorColor: AppTheme.blackColor,
                            decoration: const InputDecoration(
                              hintText:
                                  'Bachelor of Science, High School, etc.',
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
                                return 'Please enter degree/certificate';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          // Grades Section
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Total Marks",
                                      style: TextStyle(
                                        color: AppTheme.blackColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 3.0),
                                    TextFormField(
                                      style:
                                          const TextStyle(color: Colors.black),
                                      controller: _totalGradeController,
                                      cursorColor: AppTheme.blackColor,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: 'e.g: 1000',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Obtained Marks",
                                      style: TextStyle(
                                        color: AppTheme.blackColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 3.0),
                                    TextFormField(
                                      style:
                                          const TextStyle(color: Colors.black),
                                      controller: _scoreGradeController,
                                      cursorColor: AppTheme.blackColor,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: 'e.g: 850',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          const Text(
                            "Achievements",
                            style: TextStyle(
                              color: AppTheme.blackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 3.0),
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            controller: _achievementsController,
                            maxLines: 3,
                            cursorColor: AppTheme.blackColor,
                            decoration: const InputDecoration(
                              hintText:
                                  'Any achievements, honors, or special recognition',
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
                                    _addEducation();
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
    _totalGradeController.clear();
    _scoreGradeController.clear();
    _achievementsController.clear();
    _startYearController.clear();
    _endYearController.clear();
  }

  List<Widget> _buildEducationList(List<EducationInfo> educationEntries) {
    List<Widget> widgets = [];

    for (int i = 0; i < educationEntries.length; i++) {
      final education = educationEntries[i];

      widgets.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            education.institution,
            style: const TextStyle(
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
          // Display actual grades from EducationInfo
          if (education.totalGrade.isNotEmpty &&
              education.scoreGrade.isNotEmpty)
            Text(
              "Grades: ${education.scoreGrade}/${education.totalGrade}",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            )
          else if (education.totalGrade.isNotEmpty)
            Text(
              "Total Marks: ${education.totalGrade}",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            )
          else if (education.scoreGrade.isNotEmpty)
            Text(
              "Obtained Marks: ${education.scoreGrade}",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          if (education.startYear.isNotEmpty)
            Text(
              "Start Year: ${education.startYear}",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),

          if (education.endYear.isNotEmpty)
            Text(
              "End Year: ${education.endYear}",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          if (education.achievements.isNotEmpty)
            Text(
              "Achievements: ${education.achievements}",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
        ],
      ));

      // Add divider if not the last item
      if (i < educationEntries.length - 1) {
        widgets.add(Divider(thickness: 1, color: Colors.grey[300]));
        widgets.add(const SizedBox(height: 16));
      }
    }

    return widgets;
  }

  Future<void> _addEducation() async {
    if (_institutionController.text.isEmpty || _degreeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter institution and degree")));
      return;
    }

    try {
      final eduViewModel =
          Provider.of<EduinfoViewmodel>(context, listen: false);
      final cvViewModel = Provider.of<CvViewModel>(context, listen: false);

      // Create EducationInfo for Hive storage
      final educationInfo = EducationInfo(
        degree: _degreeController.text,
        institution: _institutionController.text,
        totalGrade: _totalGradeController.text,
        scoreGrade: _scoreGradeController.text,
        achievements: _achievementsController.text,
        startYear: _startYearController.text,
        endYear: _endYearController.text,
        uploadedDocs: [],
      );

      // Save to Hive
      await eduViewModel.saveEducationInfo(userMail, educationInfo);

      // Also update CV data for immediate display
      final newEducation = Education(
        institution: _institutionController.text,
        degree: _degreeController.text,
        year: "${_startYearController.text}-${_endYearController.text}",
        fieldOfStudy: null,
      );

      final updatedEducation =
          List<Education>.from(cvViewModel.cvData.education)..add(newEducation);

      cvViewModel.updateCVData(
          cvViewModel.cvData.copyWith(education: updatedEducation));

      // Clear the form and hide it
      setState(() {
        _showAddForm = false;
        _clearForm();
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Education added successfully")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error adding education: $e")));
    }
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final steps = ['Contact', 'Work', 'Education', 'Others', 'Save'];

    return Consumer<CvViewModel>(
      builder: (context, viewModel, _) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 10,
                      child: Container(
                        height: 2,
                        color: Colors.grey[300],
                      ),
                    ),
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
