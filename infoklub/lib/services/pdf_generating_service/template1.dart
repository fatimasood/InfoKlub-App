import 'dart:io';
import 'package:pdf/pdf.dart';
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
          margin: const pw.EdgeInsets.all(10.0),
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

      final file = File('${cvDirectory.path}/$fileName');

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
    return pw.Container(
      color: PdfColors.white,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header Section Name + Designation
          pw.Text(
            '${cvData.firstName ?? ''} ${cvData.lastName ?? ''}',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
          if (cvData.workExperience.isNotEmpty)
            pw.Text(
              cvData.workExperience.first.position.toUpperCase(),
              style: const pw.TextStyle(
                fontSize: 16,
                color: PdfColors.grey700,
              ),
            ),
          pw.SizedBox(height: 20),

          // Contact Info Section
          pw.Container(
            height: 80,
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                top: pw.BorderSide(color: PdfColors.black, width: 1),
              ),
            ),
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  if (cvData.email != null)
                    pw.Text('${cvData.email}',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey800,
                        )),
                  if (cvData.phone != null)
                    pw.Text('${cvData.phone}',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey800,
                        )),
                  if (cvData.address != null)
                    pw.Text('${cvData.address}',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey800,
                        )),
                ],
              ),
            ),
          ),
          pw.SizedBox(height: 15),

          // Profile Info
          pw.Row(
            children: [
              pw.Text("PROFILE INFO ",
                  style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black)),
              pw.Expanded(
                  child: pw.Divider(color: PdfColors.black, thickness: 1)),
            ],
          ),

          // Profile Content
          if (cvData.summary != null)
            pw.Text(
              cvData.summary!,
              style: const pw.TextStyle(
                fontSize: 12,
                color: PdfColors.black,
                lineSpacing: 1.5,
              ),
              textAlign: pw.TextAlign.justify,
            ),

          pw.SizedBox(height: 15),

          // Two Column Layout for Education and Work Experience
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Left Column
              pw.Expanded(
                flex: 1,
                child: _buildLeftColumn(cvData),
              ),
              pw.SizedBox(width: 10),
              // Vertical Divider
              pw.Container(
                width: 1,
                color: PdfColors.black,
                height: 600, // Adjust height as needed
              ),
              pw.SizedBox(width: 10),
              // Right Column
              pw.Expanded(
                flex: 2,
                child: _buildRightColumn(cvData),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildLeftColumn(CVModel cvData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Education
        _buildSectionTitle('EDUCATION', PdfColors.black),
        pw.SizedBox(height: 10),

        if (cvData.education.isNotEmpty)
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: cvData.education
                .map(
                  (edu) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        edu.year,
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.black,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        edu.institution.toUpperCase(),
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.Text(
                        edu.degree,
                        style: const pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.black,
                        ),
                      ),
                      if (edu.fieldOfStudy?.isNotEmpty ?? false)
                        pw.Text(
                          edu.fieldOfStudy!,
                          style: const pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.grey600,
                          ),
                        ),
                      pw.SizedBox(height: 12),
                    ],
                  ),
                )
                .toList(),
          )
        else
          pw.Text(
            'No education information available',
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey600,
            ),
          ),

        pw.SizedBox(height: 15),

        // Skills
        _buildSectionTitle('SKILLS', PdfColors.black),
        pw.SizedBox(height: 10),

        if (cvData.skills.isNotEmpty)
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: cvData.skills
                .map(
                  (skill) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 4),
                    child: pw.Text(
                      '• $skill',
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.black,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

        pw.SizedBox(height: 15),

        // Languages
        _buildSectionTitle('LANGUAGES', PdfColors.black),
        pw.SizedBox(height: 10),

        if (cvData.languages.isNotEmpty)
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: cvData.languages
                .map(
                  (lang) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 4),
                    child: pw.Text(
                      '• ${lang.language} (${lang.level})',
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.black,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  static pw.Widget _buildRightColumn(CVModel cvData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Work Experience
        _buildSectionTitle('WORK EXPERIENCE', PdfColors.black),
        pw.SizedBox(height: 10),

        if (cvData.workExperience.isNotEmpty)
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: cvData.workExperience
                .map(
                  (work) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            work.company,
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                          ),
                          pw.Text(
                            work.duration,
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey600,
                            ),
                          ),
                        ],
                      ),
                      pw.Text(
                        work.position,
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                      if (work.description?.isNotEmpty ?? false)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 4),
                          child: pw.Text(
                            work.description!,
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey800,
                              lineSpacing: 1.3,
                            ),
                          ),
                        ),
                      pw.SizedBox(height: 15),
                    ],
                  ),
                )
                .toList(),
          )
        else
          pw.Text(
            'No work experience available',
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey600,
            ),
          ),
      ],
    );
  }

  static pw.Widget _buildSectionTitle(String title, PdfColor color) {
    return pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 14,
        fontWeight: pw.FontWeight.bold,
        color: color,
      ),
    );
  }
}
