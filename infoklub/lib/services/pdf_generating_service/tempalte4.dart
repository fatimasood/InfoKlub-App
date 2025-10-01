import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:infoklub/models/cv/cv_creation_view_model.dart';

class Tempalte4PdfService {
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

      String getFormattedTimestamp() {
        final now = DateTime.now();
        return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
      }

      final timestamp = getFormattedTimestamp();
      final fileName =
          'CV_${cvData.firstName ?? 'User'}_${cvData.lastName ?? 'CV'}_$timestamp.pdf'
              .replaceAll(' ', '_')
              .replaceAll(RegExp(r'[^a-zA-Z0-9_.]'), '');

      final file = File('${cvDirectory.path}/$fileName');
      // Save the PDF
      final bytes = await pdf.save();
      await file.writeAsBytes(bytes);

      debugPrint('PDF saved successfully at: ${file.path}');
      debugPrint('File size: ${bytes.length} bytes');

      return file;
    } catch (e, stackTrace) {
      debugPrint('Error generating PDF: $e');
      debugPrint('Stack trace: $stackTrace');
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
          pw.Align(
            alignment: pw.Alignment.topRight,
            child: pw.Text(
              '${cvData.firstName ?? ''} ${cvData.lastName ?? ''}',
              style: pw.TextStyle(
                fontSize: 30,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.black,
              ),
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Align(
            alignment: pw.Alignment.topRight,
            child: pw.SizedBox(
                width: 100,
                height: 3,
                child: pw.Divider(
                  color: PdfColors.grey600,
                  thickness: 2,
                )),
          ),
          pw.SizedBox(height: 5),
          if (cvData.workExperience.isNotEmpty)
            pw.Align(
              alignment: pw.Alignment.topRight,
              child: pw.Text(
                cvData.workExperience.first.position.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 14,
                  color: PdfColors.black,
                  fontWeight: pw.FontWeight.normal,
                ),
              ),
            ),
          pw.SizedBox(height: 15),

          // Contact Info Section
          pw.Container(
            decoration: pw.BoxDecoration(
              color: PdfColors.grey900,
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
                          color: PdfColors.white,
                        )),
                  if (cvData.phone != null)
                    pw.Text('phone: ${cvData.phone}',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.white,
                        )),
                  if (cvData.address != null)
                    pw.Text('home: ${cvData.address}',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.white,
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
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey900)),
              pw.Expanded(
                  child: pw.Divider(color: PdfColors.grey900, thickness: 1)),
            ],
          ),
          pw.SizedBox(height: 10),
          // Profile Content
          if (cvData.summary != null && cvData.summary!.isNotEmpty)
            pw.Text(
              cvData.summary ?? '',
              style: const pw.TextStyle(
                fontSize: 12,
                color: PdfColors.grey900,
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
                flex: 2,
                child: _buildRightColumn(cvData),
              ),

              pw.SizedBox(width: 10),

              // Right Column
              pw.Expanded(
                flex: 1,
                child: _buildLeftColumn(cvData),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildLeftColumn(CVModel cvData) {
    return pw.Container(
        decoration: const pw.BoxDecoration(
          color: PdfColors.grey200,
        ),
        child: pw.Padding(
          padding: const pw.EdgeInsets.all(20.0),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Education
              pw.Row(
                children: [
                  _buildSectionTitle('EDUCATION\t', PdfColors.grey900),
                  pw.Expanded(
                      child:
                          pw.Divider(color: PdfColors.grey900, thickness: 1)),
                ],
              ),

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
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
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
              pw.Row(
                children: [
                  _buildSectionTitle('SKILLS\t', PdfColors.grey900),
                  pw.Expanded(
                      child:
                          pw.Divider(color: PdfColors.grey900, thickness: 1)),
                ],
              ),

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
              pw.Row(
                children: [
                  _buildSectionTitle('LANGUAGES\t', PdfColors.grey900),
                  pw.Expanded(
                      child:
                          pw.Divider(color: PdfColors.grey900, thickness: 1)),
                ],
              ),

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
          ),
        ));
  }

  static pw.Widget _buildRightColumn(CVModel cvData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Work Experience
        pw.Row(
          children: [
            _buildSectionTitle('EXPERIENCE\t', PdfColors.grey900),
            pw.Expanded(
                child: pw.Divider(color: PdfColors.grey900, thickness: 1)),
          ],
        ),

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

        //certifications
        pw.SizedBox(height: 5),
        if (cvData.certificates.isNotEmpty)
          pw.Row(
            children: [
              _buildSectionTitle('Certifications\t', PdfColors.black),
              pw.Expanded(
                  child: pw.Divider(color: PdfColors.grey600, thickness: 1)),
            ],
          ),

        pw.SizedBox(height: 5),

        if (cvData.certificates.isNotEmpty)
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: cvData.certificates
                .map(
                  (certificate) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            certificate.name,
                            style: const pw.TextStyle(
                              fontSize: 12,
                              color: PdfColors.black,
                            ),
                          ),
                          pw.Text(
                            certificate.url,
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey600,
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 3),
                    ],
                  ),
                )
                .toList(),
          )
        else
          pw.Text(
            'No certificates available',
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
