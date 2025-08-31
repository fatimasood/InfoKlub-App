import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:infoklub/models/cv/cv_creation_view_model.dart';

class Template3PdfService {
  static Future<File> generateCV(CVModel cvData) async {
    try {
      final pdf = pw.Document();

      // Use MultiPage for automatic pagination
      pdf.addPage(
        pw.MultiPage(
          margin:
              const pw.EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0),
          build: (pw.Context context) => [
            _buildCVContent(cvData),
          ],
          footer: (pw.Context context) {
            return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 20),
              child: pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
            );
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
          pw.Center(
            child: pw.Text(
              '${cvData.firstName ?? ''} ${cvData.lastName ?? ''}',
              style: pw.TextStyle(
                fontSize: 30,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.black,
              ),
            ),
          ),
          pw.SizedBox(height: 10),
          if (cvData.workExperience.isNotEmpty)
            pw.Center(
              child: pw.Text(
                cvData.workExperience.first.position.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 14,
                  color: PdfColors.black,
                  fontWeight: pw.FontWeight.normal,
                ),
              ),
            ),
          pw.SizedBox(height: 25),

          // Contact Info Section
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1),
            ),
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  if (cvData.email != null)
                    pw.Text('mail: ${cvData.email}',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.black,
                        )),
                  if (cvData.phone != null)
                    pw.Text('phone: ${cvData.phone}',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey800,
                        )),
                  if (cvData.address != null)
                    pw.Text('location: ${cvData.address}',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.black,
                        )),
                ],
              ),
            ),
          ),
          pw.SizedBox(height: 20),

          // Profile Info
          pw.Row(
            children: [
              pw.Text("PROFILE INFO\t",
                  style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black)),
              pw.Expanded(
                  child: pw.Divider(color: PdfColors.black, thickness: 1)),
            ],
          ),
          pw.SizedBox(height: 15),
          // Profile Content
          if (cvData.summary != null && cvData.summary!.isNotEmpty)
            pw.Text(
              cvData.summary ?? '',
              style: const pw.TextStyle(
                fontSize: 13,
                color: PdfColors.black,
                lineSpacing: 1.5,
              ),
              textAlign: pw.TextAlign.justify,
            ),

          pw.SizedBox(height: 20),

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
              // Vertical Divider - FIXED: Use Container instead of Divider
              pw.Container(
                width: 1,
                color: PdfColors.black,
                height: _calculateColumnHeight(cvData), // Dynamic height
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

  // Helper method to calculate dynamic height for the divider
  static double _calculateColumnHeight(CVModel cvData) {
    double height = 0;

    // Education section height
    height += 30; // Title + spacing
    height += cvData.education.length * 60; // Each education item

    // Skills section height
    height += 30; // Title + spacing
    height += cvData.skills.length * 20; // Each skill

    // Languages section height
    height += 30; // Title + spacing
    height += cvData.languages.length * 20; // Each language

    return height;
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
                        (edu.institution).toUpperCase(),
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              edu.degree,
                              style: const pw.TextStyle(
                                fontSize: 12,
                                color: PdfColors.black,
                              ),
                            ),
                            pw.Text(
                              edu.year,
                              style: pw.TextStyle(
                                fontSize: 12,
                                color: PdfColors.grey600,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ]),
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

        pw.SizedBox(height: 10),

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
                      skill,
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.black,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

        pw.SizedBox(height: 10),

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
                      '${lang.language} (${lang.level})',
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
                              fontSize: 12,
                              color: PdfColors.black,
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
                      pw.SizedBox(height: 5),
                      pw.Text(
                        work.position,
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      if ((work.description ?? '').isNotEmpty)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 4),
                          child: pw.Text(
                            work.description ?? '',
                            style: const pw.TextStyle(
                              fontSize: 12,
                              color: PdfColors.black,
                              lineSpacing: 1.5,
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
