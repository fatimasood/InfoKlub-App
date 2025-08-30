import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/viewmodels/CV/cv_view_model.dart';
import 'package:infoklub/views/CV/CV_creation/work_info_screen.dart';
import 'package:infoklub/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class ContactInfoScreen extends StatefulWidget {
  const ContactInfoScreen({super.key});

  @override
  State<ContactInfoScreen> createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends State<ContactInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _populateFormData();
    });
  }

  void _populateFormData() {
    final cvViewModel = context.read<CvViewModel>();

    final cvData = cvViewModel.cvData;
    if (kDebugMode) {
      print('Populating form with CV data:');
    }
    if (kDebugMode) {
      print('First: ${cvData.firstName}, Last: ${cvData.lastName}');
    }
    if (kDebugMode) {
      print('Email: ${cvData.email}');
    }
    if (kDebugMode) {
      print('Phone: ${cvData.phone}');
    }
    if (kDebugMode) {
      print('Address: ${cvData.address}');
    }

    // Set values in controllers
    _firstNameController.text = cvData.firstName ?? '';
    _lastNameController.text = cvData.lastName ?? '';
    _emailController.text = cvData.email ?? '';
    _phoneController.text = cvData.phone ?? '';
    _addressController.text = cvData.address ?? '';

    // Also update the creation viewmodel
    cvViewModel.updateContactInfo(
      firstName: cvData.firstName,
      lastName: cvData.lastName,
      email: cvData.email,
      phone: cvData.phone,
      address: cvData.address,
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CvViewModel>();
    final cvViewModel = context.watch<CvViewModel>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
          onPressed: () {
            viewModel.previousStep();
            Navigator.pop(context);
          },
        ),
        title: const Text('Create CV',
            style: TextStyle(color: AppTheme.primaryColor, fontSize: 20.0)),
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
                      child: Text('Contact Information',
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                    const SizedBox(height: 20),

                    // Profile Image and Name Section
                    _buildProfileSection(context, cvViewModel),

                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _emailController,
                      label: "Email",
                      hint: "noor12@gmail.com",
                      onChanged: (value) =>
                          viewModel.updateContactInfo(email: value),
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _phoneController,
                      label: "Phone Number",
                      hint: "+44 456 7890",
                      onChanged: (value) =>
                          viewModel.updateContactInfo(phone: value),
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _addressController,
                      label: "Home Address",
                      hint: "Street, City, Country",
                      onChanged: (value) =>
                          viewModel.updateContactInfo(address: value),
                      keyboardType: TextInputType.streetAddress,
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
                          builder: (context) => WorkInfoScreen()));
                }
              },
            ),
          )
        ],
      ),
    );
  }

  // ContactInfoScreen mein _buildProfileSection update karo
  Widget _buildProfileSection(BuildContext context, CvViewModel cvViewModel) {
    return Row(
      children: [
        // Profile Image
        Container(
          height: 140,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[200],
            image: cvViewModel.cvData.profileImage != null
                ? DecorationImage(
                    image: FileImage(cvViewModel.cvData.profileImage!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: cvViewModel.cvData.profileImage == null
              ? const Icon(Icons.person, size: 40, color: Colors.grey)
              : null,
        ),
        const SizedBox(width: 20),

        // Name Fields
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _firstNameController,
                label: "First Name",
                hint: "Fatema",
                onChanged: (value) => context
                    .read<CvViewModel>()
                    .updateContactInfo(firstName: value),
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _lastNameController,
                label: "Last Name",
                hint: "BiBi",
                onChanged: (value) => context
                    .read<CvViewModel>()
                    .updateContactInfo(lastName: value),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.blackColor,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 3.0),
        TextFormField(
          style: const TextStyle(
            color: AppTheme.blackColor,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
          controller: controller,
          cursorColor: AppTheme.blackColor,
          decoration: InputDecoration(
            hintText: hint,
            // ignore: deprecated_member_use
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.2)),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
          keyboardType: keyboardType,
          onChanged: onChanged,
        ),
      ],
    );
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
                      child: Container(height: 2, color: Colors.grey[300]),
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
                                border:
                                    Border.all(color: Colors.white, width: 2),
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
