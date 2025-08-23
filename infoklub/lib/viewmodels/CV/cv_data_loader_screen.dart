import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/viewmodels/CV/cv_view_model.dart';
import 'package:infoklub/views/CV/cv_main_screen.dart';
import 'package:provider/provider.dart';

class CVDataLoaderScreen extends StatefulWidget {
  const CVDataLoaderScreen({super.key});

  @override
  _CVDataLoaderScreenState createState() => _CVDataLoaderScreenState();
}

class _CVDataLoaderScreenState extends State<CVDataLoaderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

// Update the _loadUserData method

  Future<void> _loadUserData() async {
    final cvViewModel = context.read<CvViewModel>();
    try {
      await cvViewModel.loadUserDataForCV();

      if (cvViewModel.error == null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CVPage()),
        );
      } else if (mounted) {
        // Show error if any
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${cvViewModel.error}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unexpected error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.halfwhite,
      body: Consumer<CvViewModel>(
        builder: (context, cvViewModel, _) {
          if (cvViewModel.error != null) {
            return _buildErrorState(cvViewModel.error!);
          }

          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                ),
                SizedBox(height: 20),
                Text(
                  'Loading your information...',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.blackColor,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              'Failed to load data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.blackColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _loadUserData(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
