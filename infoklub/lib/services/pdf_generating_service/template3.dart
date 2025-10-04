import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:infoklub/models/cv/cv_creation_view_model.dart';

class Template3PdfService {
  static Future<File> generateCV(CVModel cvData) async {
    try {
      final pdf = pw.Document();

      pw.MemoryImage? profileImage;

      if (cvData.profileImage != null && cvData.profileImage!.isNotEmpty) {
        try {
          final file = File(cvData.profileImage!);
          if (await file.exists()) {
            final imageData = await file.readAsBytes();
            profileImage = pw.MemoryImage(imageData);
          }
        } catch (e) {
          debugPrint('Error loading profile image: $e');
        }
      }

      // Use MultiPage for automatic pagination
      pdf.addPage(
        pw.MultiPage(
          margin:
              const pw.EdgeInsets.symmetric(vertical: 28.0, horizontal: 22.0),
          build: (pw.Context context) {
            return [
              _buildCVContent(cvData, profileImage),
            ];
          },
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

  static pw.Widget _buildCVContent(
      CVModel cvData, pw.MemoryImage? profileImage) {
    return pw.Container(
      color: PdfColors.white,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Two sides
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              // Left Column
              if (profileImage != null)
                pw.Center(
                  child: pw.Container(
                    width: 100,
                    height: 100,
                    decoration: pw.BoxDecoration(
                      shape: pw.BoxShape.circle,
                      image: pw.DecorationImage(
                        image: profileImage,
                        fit: pw.BoxFit.cover,
                      ),
                    ),
                  ),
                ),

              pw.SizedBox(width: 30),
              // Right Column
              pw.Expanded(
                flex: 2,
                child: pw.Container(
                  padding: const pw.EdgeInsets.only(left: 10),
                  child: _introPart(cvData),
                ),
              ),
            ],
          ),

          // bottom part
          pw.SizedBox(height: 20),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Left Column
              pw.Expanded(
                flex: 1,
                child: pw.Container(
                  child: _buildLeftColumn(cvData),
                ),
              ),
              pw.SizedBox(width: 20),
              // Right Column
              pw.Expanded(
                flex: 2,
                child: pw.Container(
                  padding: const pw.EdgeInsets.only(left: 10),
                  child: _buildRightColumn(cvData),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// top header part
  static pw.Widget _introPart(CVModel cvData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        //name
        pw.Align(
          alignment: pw.Alignment.center,
          child: pw.Text(
            '${cvData.firstName ?? ''} ${cvData.lastName ?? ''}'.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 22,
              color: PdfColors.black,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.SizedBox(height: 4),
        //designation
        if (cvData.workExperience.isNotEmpty)
          pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Text(
              cvData.workExperience.first.position.toUpperCase(),
              style: pw.TextStyle(
                fontSize: 13,
                color: PdfColors.black,
                fontWeight: pw.FontWeight.normal,
              ),
            ),
          ),

        //contact info
        pw.SizedBox(height: 13),

        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (cvData.email != null)
              pw.Text('${cvData.email}',
                  style: const pw.TextStyle(
                    fontSize: 9.5,
                    color: PdfColors.grey800,
                  )),
            if (cvData.phone != null)
              pw.Text('${cvData.phone}',
                  style: const pw.TextStyle(
                    fontSize: 9.5,
                    color: PdfColors.grey800,
                  )),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildLeftColumn(CVModel cvData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        //About Me
        pw.Row(
          children: [
            _buildSectionTitle('About Me\t', PdfColors.black),
            pw.Expanded(
                child: pw.Divider(color: PdfColors.grey600, thickness: 1)),
          ],
        ),

        pw.SizedBox(height: 5),
        if (cvData.summary != null && cvData.summary!.isNotEmpty)
          pw.Text(
            cvData.summary ?? '',
            style: const pw.TextStyle(
              fontSize: 12,
              color: PdfColors.black,
              lineSpacing: 1.5,
            ),
            textAlign: pw.TextAlign.justify,
          ),
        // Education
        pw.SizedBox(height: 10),
        pw.Row(
          children: [
            _buildSectionTitle('Education\t', PdfColors.black),
            pw.Expanded(
                child: pw.Divider(color: PdfColors.grey600, thickness: 1)),
          ],
        ),

        pw.SizedBox(height: 5),

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
                      pw.SizedBox(height: 3),
                      pw.Text(
                        edu.degree,
                        style: const pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        edu.year,
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.black,
                          fontWeight: pw.FontWeight.normal,
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

        pw.SizedBox(height: 3),
        pw.Row(
          children: [
            _buildSectionTitle('Skills\t', PdfColors.black),
            pw.Expanded(
                child: pw.Divider(color: PdfColors.grey600, thickness: 1)),
          ],
        ),

        pw.SizedBox(height: 3),
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

        pw.SizedBox(height: 5),
        pw.Row(
          children: [
            _buildSectionTitle('Languages\t', PdfColors.black),
            pw.Expanded(
                child: pw.Divider(color: PdfColors.grey600, thickness: 1)),
          ],
        ),

        pw.SizedBox(height: 5),

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
        // Work Experience with Timeline
        pw.Row(
          children: [
            _buildSectionTitle('Experience\t', PdfColors.black),
            pw.Expanded(
                child: pw.Divider(color: PdfColors.grey600, thickness: 1)),
          ],
        ),
        pw.SizedBox(height: 5),

        if (cvData.workExperience.isNotEmpty)
          pw.Stack(
            children: [
              // Timeline vertical line (behind content)
              pw.Positioned(
                left: 4,
                top: 0,
                bottom: 0,
                child: pw.Container(
                  width: 1,
                  color: PdfColors.black,
                ),
              ),
              // Experience content
              pw.Padding(
                padding: const pw.EdgeInsets.only(left: 15),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: cvData.workExperience
                      .map(
                        (work) => pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            // Timeline dot
                            pw.Container(
                              width: 5,
                              height: 5,
                              margin:
                                  const pw.EdgeInsets.only(right: 8, top: 4),
                              decoration: const pw.BoxDecoration(
                                shape: pw.BoxShape.circle,
                                color: PdfColors.black,
                              ),
                            ),
                            // Experience content
                            pw.Expanded(
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text(
                                        work.company,
                                        style: pw.TextStyle(
                                            fontSize: 12,
                                            color: PdfColors.black,
                                            fontWeight: pw.FontWeight.normal),
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
                                      color: PdfColors.grey900,
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
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
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
