import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/services/template_services/template_service.dart';
import 'package:infoklub/viewmodels/CV/cv_view_model.dart';
import 'package:infoklub/views/CV/cv_templates/all_templares_screen.dart';
import 'package:infoklub/views/CV/cv_templates/template_selection_screen.dart';
import 'package:infoklub/widgets/custom_button.dart';
import 'package:infoklub/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';

class CvDownload extends StatefulWidget {
  const CvDownload({super.key});

  @override
  State<CvDownload> createState() => _CvDownloadState();
}

class _CvDownloadState extends State<CvDownload> {
  final _formKey = GlobalKey<FormState>();
  bool _isGeneratingPdf = false;
  String? _errorMessage;

  CVTemplate _selectedTemplate = TemplateService.getDefaultTemplate();

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
    if (_isGeneratingPdf) return;

    setState(() {
      _isGeneratingPdf = true;
      _errorMessage = null;
    });

    try {
      if (kDebugMode) {
        print('Starting PDF generation...');
      }
      if (kDebugMode) {
        print(
            'Starting PDF generation with template: ${_selectedTemplate.name}');
      }
      if (kDebugMode) {
        print(
            'CV Data: ${cvViewModel.cvData.firstName} ${cvViewModel.cvData.lastName}');
      }
      if (kDebugMode) {
        print('Work experiences: ${cvViewModel.cvData.workExperience.length}');
      }
      if (kDebugMode) {
        print('Education: ${cvViewModel.cvData.education.length}');
      }
      if (kDebugMode) {
        print('Skills: ${cvViewModel.cvData.skills.length}');
      }

      final pdfFile = await _selectedTemplate.generateCV(cvViewModel.cvData);

      if (kDebugMode) {
        print('PDF generated successfully: ${pdfFile.path}');
      }

      // Show success dialog
      _showDownloadSuccess(context, pdfFile);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error generating PDF: $e');
      }
      if (kDebugMode) {
        print('Stack trace: $stackTrace');
      }

      setState(() {
        _errorMessage = 'Failed to generate PDF: $e';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() {
        _isGeneratingPdf = false;
      });
    }
  }

  Future<void> _openPdfFile(File pdfFile) async {
    try {
      final result = await OpenFile.open(pdfFile.path);

      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('CV saved at: ${pdfFile.path}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot open file: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Create CV',
            style: TextStyle(color: AppTheme.primaryColor, fontSize: 20.0),
          ),
        ),
        body: Column(
          children: [
            _buildProgressIndicator(),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
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
                      // Selected Template Preview
                      Text(
                        'Selected Template: ${_selectedTemplate.name}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Template preview
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppTheme.primaryColor, width: 2),
                        ),
                        child: Image.asset(
                          _selectedTemplate.imageAsset,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _generateAndDownloadPdf(cvViewModel),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    icon: const Icon(Icons.download, size: 20),
                    label: const Text(
                      "Save as PDF",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AllTemplaresScreen()));
                    },
                    child: const Text(
                      "More Templates",
                      style: TextStyle(
                          color: AppTheme.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Finish >"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDownloadSuccess(BuildContext context, File pdfFile) {
    // Get a user-friendly path display
    String userVisiblePath = pdfFile.path;

    // Clean up the path for display
    if (userVisiblePath.contains('/Android/data/')) {
      userVisiblePath =
          userVisiblePath.replaceFirst(RegExp(r'.*Download/'), 'Downloads/');
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.whiteColor,
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 20),
            SizedBox(width: 10),
            Text('CV Ready!'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your professional CV has been saved.'),
              SizedBox(height: 10),
              Text(
                'To access your CV:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                '• Use "Open CV" button below\n• Or find in Downloads folder',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          CustomButton(
            height: 40,
            color: AppTheme.secondaryColor,
            text: "Open CV",
            onPressed: () {
              Navigator.pop(context);
              _openPdfFile(pdfFile);
            },
          )
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
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
                            border: Border.all(color: Colors.white, width: 2),
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
