import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/viewmodels/CV/cv_creation_view_model.dart';
import 'package:infoklub/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class OtherInfoScreen extends StatefulWidget {
  const OtherInfoScreen({super.key});

  @override
  State<OtherInfoScreen> createState() => _OtherInfoScreenState();
}

class _OtherInfoScreenState extends State<OtherInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  bool showActivities = false;
  bool showLanguages = false;
  bool showSkills = false;
  bool showCertificates = false;

  // Controllers for text fields
  final TextEditingController _activityNameController = TextEditingController();
  final TextEditingController _activityDescController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  String _selectedLanguageLevel = 'Basic';
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _certificateNameController =
      TextEditingController();
  final TextEditingController _certificateUrlController =
      TextEditingController();
  final TextEditingController _summaryController = TextEditingController();

  @override
  void dispose() {
    _activityNameController.dispose();
    _activityDescController.dispose();
    _languageController.dispose();
    _skillsController.dispose();
    _certificateNameController.dispose();
    _certificateUrlController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

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
                        'Other Details',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Extracurricular Activities
                    _buildSectionButton(
                      context,
                      icon: Icons.sports_soccer,
                      text: "Extracurricular Activities",
                      isExpanded: showActivities,
                      onPressed: () {
                        setState(() {
                          showActivities = !showActivities;
                        });
                      },
                    ),
                    _buildExpandableSection(
                      visible: showActivities,
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _activityNameController,
                            label: "Activity Name",
                            hint: "e.g., Football Team Captain",
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: _activityDescController,
                            label: "Description",
                            hint:
                                "Brief description of your role and achievements",
                            maxLines: 3,
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.secondaryColor,
                                backgroundColor:
                                    AppTheme.secondaryColor.withOpacity(0.1),
                              ),
                              onPressed: () {
                                if (_activityNameController.text.isNotEmpty) {
                                  viewModel.addActivity(
                                    name: _activityNameController.text,
                                    description: _activityDescController.text,
                                  );
                                  _activityNameController.clear();
                                  _activityDescController.clear();
                                  setState(() {});
                                }
                              },
                              child: const Text('Add Activity'),
                            ),
                          ),
                          _buildAddedItemsList(
                            items: viewModel.cvData.activities,
                            itemBuilder: (activity) => ListTile(
                              title: Text(activity.name),
                              subtitle: activity.description.isNotEmpty
                                  ? Text(activity.description)
                                  : null,
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  viewModel.removeActivity(activity);
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Languages
                    _buildSectionButton(
                      context,
                      icon: Icons.language,
                      text: "Languages",
                      isExpanded: showLanguages,
                      onPressed: () {
                        setState(() {
                          showLanguages = !showLanguages;
                        });
                      },
                    ),
                    _buildExpandableSection(
                      visible: showLanguages,
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _languageController,
                            label: "Language",
                            hint: "e.g., French",
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _selectedLanguageLevel,
                            decoration: InputDecoration(
                              labelText: "Level",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppTheme.primaryColor),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                  value: "Basic", child: Text("Basic")),
                              DropdownMenuItem(
                                  value: "Intermediate",
                                  child: Text("Intermediate")),
                              DropdownMenuItem(
                                  value: "Fluent", child: Text("Fluent")),
                              DropdownMenuItem(
                                  value: "Native", child: Text("Native")),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedLanguageLevel = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.secondaryColor,
                                backgroundColor:
                                    AppTheme.secondaryColor.withOpacity(0.1),
                              ),
                              onPressed: () {
                                if (_languageController.text.isNotEmpty) {
                                  viewModel.addLanguage(
                                    language: _languageController.text,
                                    level: _selectedLanguageLevel,
                                  );
                                  _languageController.clear();
                                  setState(() {});
                                }
                              },
                              child: const Text('Add Language'),
                            ),
                          ),
                          _buildAddedItemsList(
                            items: viewModel.cvData.languages,
                            itemBuilder: (language) => ListTile(
                              title: Text(language.language),
                              subtitle: Text(language.level),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  viewModel.removeLanguage(language);
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Skills
                    _buildSectionButton(
                      context,
                      icon: Icons.star,
                      text: "Skills",
                      isExpanded: showSkills,
                      onPressed: () {
                        setState(() {
                          showSkills = !showSkills;
                        });
                      },
                    ),
                    _buildExpandableSection(
                      visible: showSkills,
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _skillsController,
                            label: "Your Skills",
                            hint:
                                "e.g., Photoshop, Public Speaking, Team Leadership",
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Separate skills with commas",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.secondaryColor,
                                backgroundColor:
                                    AppTheme.secondaryColor.withOpacity(0.1),
                              ),
                              onPressed: () {
                                if (_skillsController.text.isNotEmpty) {
                                  final skills = _skillsController.text
                                      .split(',')
                                      .map((s) => s.trim())
                                      .where((s) => s.isNotEmpty)
                                      .toList();

                                  if (skills.isNotEmpty) {
                                    viewModel.addSkills(skills);
                                    _skillsController.clear();
                                    setState(() {});
                                  }
                                }
                              },
                              child: const Text('Add Skills'),
                            ),
                          ),
                          _buildAddedItemsList(
                            items: viewModel.cvData.skills,
                            itemBuilder: (skill) => ListTile(
                              title: Text(skill),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  viewModel.removeSkill(skill);
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Certificates
                    _buildSectionButton(
                      context,
                      icon: Icons.card_membership,
                      text: "Certificates",
                      isExpanded: showCertificates,
                      onPressed: () {
                        setState(() {
                          showCertificates = !showCertificates;
                        });
                      },
                    ),
                    _buildExpandableSection(
                      visible: showCertificates,
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _certificateNameController,
                            label: "Certificate Name",
                            hint: "e.g., Google Analytics Certification",
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: _certificateUrlController,
                            label: "Certificate URL",
                            hint: "https://example.com/certificate",
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.secondaryColor,
                                backgroundColor:
                                    AppTheme.secondaryColor.withOpacity(0.1),
                              ),
                              onPressed: () {
                                if (_certificateNameController
                                    .text.isNotEmpty) {
                                  viewModel.addCertificate(
                                    name: _certificateNameController.text,
                                    url: _certificateUrlController.text,
                                  );
                                  _certificateNameController.clear();
                                  _certificateUrlController.clear();
                                  setState(() {});
                                }
                              },
                              child: const Text('Add Certificate'),
                            ),
                          ),
                          _buildAddedItemsList(
                            items: viewModel.cvData.certificates,
                            itemBuilder: (certificate) => ListTile(
                              title: Text(certificate.name),
                              subtitle: certificate.url.isNotEmpty
                                  ? Text(certificate.url)
                                  : null,
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  viewModel.removeCertificate(certificate);
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    Text(
                      "Summary",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _summaryController,
                      maxLines: 8,
                      cursorColor: AppTheme.primaryColor,
                      decoration: InputDecoration(
                        hintText:
                            'Having recently graduated with an MSc in International Business Management, with expertise in client communication, managing inquiries, and administrative duties, I am seeking a role as a Paralegal at HFIS Limited. I have the right to work in the UK.',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.primaryColor),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      onChanged: (value) => viewModel.updateSummary(value),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomButton(
              text: "Next Step\t >",
              color: AppTheme.secondaryColor,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  viewModel.nextStep();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OtherInfoScreen(),
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

  Widget _buildSectionButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required bool isExpanded,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color:
            isExpanded ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpanded ? AppTheme.primaryColor : Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isExpanded ? AppTheme.primaryColor : Colors.grey[700],
        ),
        title: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isExpanded ? AppTheme.primaryColor : Colors.grey[700],
          ),
        ),
        trailing: Icon(
          isExpanded ? Icons.expand_less : Icons.expand_more,
          color: isExpanded ? AppTheme.primaryColor : Colors.grey,
        ),
        onTap: onPressed,
      ),
    );
  }

  Widget _buildExpandableSection({
    required bool visible,
    required Widget child,
  }) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: visible
          ? Container(
              key: ValueKey<bool>(visible),
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: child,
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.blackColor,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          cursorColor: AppTheme.primaryColor,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddedItemsList<T>({
    required List<T> items,
    required Widget Function(T) itemBuilder,
  }) {
    if (items.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text(
          "Added Items:",
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) => itemBuilder(items[index]),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final steps = ['Contact', 'Work', 'Education', 'Others', 'Save'];

    return Consumer<CvCreationViewModel>(
      builder: (context, viewModel, _) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
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
                      top: 15,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    // Progress line (colored part)
                    Positioned(
                      left: 0,
                      top: 15,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        width: (MediaQuery.of(context).size.width - 40) *
                            (viewModel.currentStep / (steps.length - 1)),
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Circles and labels
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: steps.asMap().entries.map((entry) {
                        final index = entry.key;
                        final isActive = index <= viewModel.currentStep;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isActive
                                    ? AppTheme.primaryColor
                                    : Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isActive
                                        ? Colors.white
                                        : Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              entry.value,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isActive
                                    ? AppTheme.primaryColor
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
