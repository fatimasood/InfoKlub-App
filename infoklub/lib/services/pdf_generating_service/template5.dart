import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:infoklub/models/cv/cv_creation_view_model.dart';

class Template5PdfService {
  static Future<File> generateCV(CVModel cvData) async {
    final blueNavy = PdfColor.fromHex('#164863');
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
          if (kDebugMode) {
            print('Error loading profile image: $e');
          }
        }
      }

      // Use MultiPage for automatic pagination
      pdf.addPage(
        pw.MultiPage(
          margin:
              const pw.EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
          build: (pw.Context context) {
            return [
              _buildCVContent(
                cvData,
                profileImage,
                blueNavy,
              ),
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

      if (kDebugMode) {
        print('PDF saved successfully at: ${file.path}');
      }
      if (kDebugMode) {
        print('File size: ${bytes.length} bytes');
      }

      return file;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error generating PDF: $e');
      }
      if (kDebugMode) {
        print('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  static pw.Widget _buildCVContent(
      CVModel cvData, pw.MemoryImage? profileImage, PdfColor blueNavy) {
    return pw.Container(
      color: PdfColors.white,
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          // Left Column
          pw.Expanded(
            flex: 1,
            child: pw.Container(
              // height: double.infinity,
              color: blueNavy,
              padding: const pw.EdgeInsets.all(15),
              child: _buildLeftColumn(cvData, profileImage),
            ),
          ),

          // Right Column
          pw.Expanded(
            flex: 2,
            child: pw.Container(
              color: PdfColors.white,
              padding: const pw.EdgeInsets.all(10),
              child: _buildRightColumn(cvData, blueNavy),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildLeftColumn(
      CVModel cvData, pw.MemoryImage? profileImage) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 10),
        // profile picture
        if (profileImage != null)
          pw.Center(
            child: pw.Container(
              width: 100,
              height: 100,
              decoration: pw.BoxDecoration(
                shape: pw.BoxShape.rectangle,
                image: pw.DecorationImage(
                  image: profileImage,
                  fit: pw.BoxFit.cover,
                ),
              ),
            ),
          ),
        //contact info
        pw.SizedBox(height: 15),
        _buildSectionTitle('CONTACT', PdfColors.white),
        pw.Divider(color: PdfColors.white),
        pw.SizedBox(height: 3),
        pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (cvData.email != null)
              pw.Text('${cvData.email}',
                  style: const pw.TextStyle(
                    fontSize: 9.5,
                    color: PdfColors.white,
                  )),
            pw.SizedBox(height: 2),
            if (cvData.phone != null)
              pw.Text('${cvData.phone}',
                  style: const pw.TextStyle(
                    fontSize: 9.5,
                    color: PdfColors.white,
                  )),
            pw.SizedBox(height: 2),
            if (cvData.address != null)
              pw.Text('${cvData.address}',
                  style: const pw.TextStyle(
                    fontSize: 9.5,
                    color: PdfColors.white,
                  )),
            pw.SizedBox(height: 2),
            if (cvData.linkedIn != null)
              pw.Text('${cvData.linkedIn}',
                  style: const pw.TextStyle(
                    fontSize: 9.5,
                    color: PdfColors.white,
                  )),
            pw.SizedBox(height: 2),
            if (cvData.website != null)
              pw.Text('${cvData.website}',
                  style: const pw.TextStyle(
                    fontSize: 9.5,
                    color: PdfColors.white,
                  )),
          ],
        ),
        // Education
        pw.SizedBox(height: 10),
        _buildSectionTitle('ACADEMIC QUALIFICATION', PdfColors.white),
        pw.Divider(color: PdfColors.white),
        pw.SizedBox(height: 3),

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
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.normal,
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        (edu.institution).toUpperCase(),
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        edu.degree,
                        style: const pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.white,
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
        _buildSectionTitle('SKILLS', PdfColors.white),
        pw.Divider(color: PdfColors.white),
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
                        color: PdfColors.white,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

        pw.SizedBox(height: 5),
        _buildSectionTitle('LANGUAGES', PdfColors.white),
        pw.Divider(color: PdfColors.white),
        pw.SizedBox(height: 3),

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
                        color: PdfColors.white,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  static pw.Widget _buildRightColumn(CVModel cvData, PdfColor blueNavy) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // name and title
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          child: pw.Center(
            child: pw.Column(
              children: [
                pw.SizedBox(height: 15),
                //name
                pw.Text(
                  '${cvData.firstName ?? ''} ${cvData.lastName ?? ''}',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: blueNavy,
                  ),
                ),
                pw.SizedBox(height: 7),
                if (cvData.workExperience.isNotEmpty)
                  pw.Text(
                    cvData.workExperience.first.position.toUpperCase(),
                    style: pw.TextStyle(
                      fontSize: 13,
                      color: blueNavy,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),

                pw.SizedBox(width: 100, child: pw.Divider(color: blueNavy)),
                pw.SizedBox(height: 15),
              ],
            ),
          ),
        ),
        //Summary
        pw.SizedBox(height: 10),
        _buildSectionTitle('PROFILE', blueNavy),
        pw.Divider(color: blueNavy),
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
        pw.SizedBox(height: 20),

        // Work Experience
        _buildSectionTitle('WORK EXPERIENCE', blueNavy),
        pw.Divider(color: blueNavy),
        pw.SizedBox(height: 5),

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
          _buildSectionTitle('CERTIFICATIONS', blueNavy),
        pw.Divider(color: blueNavy),
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
        letterSpacing: 2,
        font: pw.Font.helvetica(),
        fontWeight: pw.FontWeight.bold,
        color: color,
      ),
    );
  }
}
