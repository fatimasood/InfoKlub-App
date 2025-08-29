import 'dart:io';
import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/models/cv/cv_creation_view_model.dart';
import 'package:infoklub/services/pdf_generating_service/template1.dart';
import 'package:infoklub/viewmodels/CV/cv_view_model.dart';
import 'package:infoklub/widgets/custom_button.dart';
import 'package:infoklub/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';

class CvDownload extends StatefulWidget {
  const CvDownload({super.key});

  @override
  State<CvDownload> createState() => _CvDownloadState();
}

class _CvDownloadState extends State<CvDownload> {
  final _formKey = GlobalKey<FormState>();
  bool _isGeneratingPdf = false;

  @override
  void initState() {
    super.initState();
    // Load user data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cvViewModel = context.read<CvViewModel>();
      if (cvViewModel.cvData.firstName == null) {
        cvViewModel.loadUserDataForCV();
      }
    });
  }

  Future<void> _generateAndDownloadPdf(CvViewModel cvViewModel) async {
    setState(() {
      _isGeneratingPdf = true;
    });

    try {
      final pdfFile = await PdfGenerationService.generateCV(cvViewModel.cvData);

      // Show success dialog
      _showDownloadSuccess(context, pdfFile);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate PDF: $e')),
      );
    } finally {
      setState(() {
        _isGeneratingPdf = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cvViewModel = context.watch<CvViewModel>();

    return LoadingOverlay(
      isLoading: _isGeneratingPdf || cvViewModel.isLoading,
      message: _isGeneratingPdf
          ? 'Please wait while we create your CV...'
          : 'Loading your data...',
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppTheme.primaryColor,
            ),
            onPressed: () {
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
                          'Save/Download',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.primaryColor),
                            color: Colors.white),
                        child: Image.asset(
                          "lib/assets/cv_tem/cvtemp1.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                      // Show user data preview
                      if (cvViewModel.cvData.firstName != null)
                        _buildDataPreview(cvViewModel.cvData),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _generateAndDownloadPdf(cvViewModel),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.download,
                          color: AppTheme.redAccent,
                          size: 25,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Save as PDF",
                          style: TextStyle(
                              color: AppTheme.redAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showTemplateSelection(context);
                    },
                    child: const Text(
                      "More Templates",
                      style: TextStyle(
                          color: AppTheme.textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomButton(
                text: "Finish >",
                color: AppTheme.secondaryColor,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataPreview(CVModel cvData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Your CV Preview:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text('Name: ${cvData.firstName ?? ''} ${cvData.lastName ?? ''}'),
        if (cvData.email != null) Text('Email: ${cvData.email}'),
        if (cvData.phone != null) Text('Phone: ${cvData.phone}'),
        if (cvData.workExperience.isNotEmpty)
          Text('Work Experiences: ${cvData.workExperience.length}'),
        if (cvData.education.isNotEmpty)
          Text('Education: ${cvData.education.length} entries'),
        if (cvData.skills.isNotEmpty)
          Text('Skills: ${cvData.skills.length} skills'),
      ],
    );
  }

  void _showDownloadSuccess(BuildContext context, File pdfFile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('CV Generated Successfully'),
        content: const Text('Your CV has been saved as PDF.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Share the file
              // Share.shareXFiles([XFile(pdfFile.path)]);
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  void _showTemplateSelection(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Template'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Professional Template'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Creative Template'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final steps = ['Contact', 'Work', 'Education', 'Others', 'Save'];

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
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 40) *
                        (4 / (steps.length - 1)),
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
                            color: index <= 4
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
                            color: index <= 4
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
  }
}
