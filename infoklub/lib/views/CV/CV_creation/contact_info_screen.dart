import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/viewmodels/CV/cv_creation_view_model.dart';
import 'package:infoklub/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class ContactInfoScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  ContactInfoScreen({super.key});

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
          onPressed: () => Navigator.pop(context),
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
                    Text(
                      'Contact Information',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),

                    // Image container with rounded corners
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                      ),
                      child: const Icon(Icons.camera_enhance_rounded, size: 40),
                    ),
                    const SizedBox(height: 20),

                    // Form fields in proper column layout
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) =>
                          viewModel.updateContactInfo(firstName: value),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) =>
                          viewModel.updateContactInfo(lastName: value),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) =>
                          viewModel.updateContactInfo(email: value),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: (value) =>
                          viewModel.updateContactInfo(phone: value),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomButton(text: "Next Step >", onPressed: () {}),
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
