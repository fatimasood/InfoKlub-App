import 'package:flutter/material.dart';
import '../app/theme.dart';

class FileUploadWidget extends StatelessWidget {
  final VoidCallback onUploadTap;

  const FileUploadWidget({super.key, required this.onUploadTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onUploadTap,
            child: Image.asset(
              'lib/assets/Images/upload.png',
              width: 100,
              height: 100,
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: "Drag & drop files ",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: "or ",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: GestureDetector(
                    onTap: onUploadTap,
                    child: const Text(
                      "Browse",
                      style: TextStyle(
                        color: AppTheme.secondaryColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "Supported formats: JPEG, PNG, PDF, PSD, Word",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
