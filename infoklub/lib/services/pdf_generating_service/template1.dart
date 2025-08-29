import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:infoklub/models/cv/cv_creation_view_model.dart';

class PdfGenerationService {
  static Future<File> generateCV(CVModel cvData) async {
    try {
      final pdf = pw.Document();

      // Add CV content with professional design
      pdf.addPage(
        pw.Page(
          margin: const pw.EdgeInsets.all(30),
          build: (pw.Context context) {
            return _buildCVContent(cvData);
          },
        ),
      );

      // Get directory for saving
      final directory = await getDownloadsDirectory();

      if (directory == null) {
        throw Exception('Could not access downloads directory');
      }

      final cvDirectory = Directory('${directory.path}/CVs');
      if (!await cvDirectory.exists()) {
        await cvDirectory.create(recursive: true);
      }

      final fileName =
          'CV_${cvData.firstName ?? 'User'}_${cvData.lastName ?? 'CV'}.pdf'
              .replaceAll(' ', '_')
              .replaceAll(RegExp(r'[^a-zA-Z0-9_.]'), '');

      final file = File('${directory.path}/$fileName');

      // Save the PDF
      final bytes = await pdf.save();
      await file.writeAsBytes(bytes);

      print('PDF saved successfully at: ${file.path}');
      print('File size: ${bytes.length} bytes');

      return file;
    } catch (e, stackTrace) {
      print('Error generating PDF: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  static pw.Widget _buildCVContent(CVModel cvData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Simple header for testing
        pw.Text(
          '${cvData.firstName ?? ''} ${cvData.lastName ?? ''}',
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),

        // Basic contact info
        if (cvData.email != null) pw.Text('Email: ${cvData.email}'),
        if (cvData.phone != null) pw.Text('Phone: ${cvData.phone}'),
        pw.SizedBox(height: 20),

        // Work Experience
        if (cvData.workExperience.isNotEmpty) ...[
          pw.Text('Work Experience',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          ...cvData.workExperience
              .map((work) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('${work.position} at ${work.company}'),
                      pw.Text('Duration: ${work.duration}'),
                      pw.SizedBox(height: 5),
                    ],
                  ))
              .toList(),
        ],

        // Education
        if (cvData.education.isNotEmpty) ...[
          pw.Text('Education',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          ...cvData.education
              .map((edu) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('${edu.degree} - ${edu.institution}'),
                      pw.Text('Year: ${edu.year}'),
                      pw.SizedBox(height: 5),
                    ],
                  ))
              .toList(),
        ],

        // Skills
        if (cvData.skills.isNotEmpty) ...[
          pw.Text('Skills',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Text(cvData.skills.join(', ')),
        ],
      ],
    );
  }
}
