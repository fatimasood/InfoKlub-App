import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:infoklub/models/cv/cv_creation_view_model.dart';

class PdfGenerationService {
  static Future<File> generateCV(CVModel cvData) async {
    final pdf = pw.Document();

    // Add CV content based on user data
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Personal Information
              _buildPersonalInfoSection(cvData),
              pw.SizedBox(height: 20),

              // Work Experience
              _buildWorkExperienceSection(cvData.workExperience),
              pw.SizedBox(height: 20),

              // Education
              _buildEducationSection(cvData.education),
              pw.SizedBox(height: 20),

              // Skills
              _buildSkillsSection(cvData.skills),

              // Add other sections as needed
              if (cvData.languages.isNotEmpty) ...[
                pw.SizedBox(height: 20),
                _buildLanguagesSection(cvData.languages),
              ],

              if (cvData.certificates.isNotEmpty) ...[
                pw.SizedBox(height: 20),
                _buildCertificatesSection(cvData.certificates),
              ],
            ],
          );
        },
      ),
    );

    // Get directory for saving
    final directory = await getApplicationDocumentsDirectory();
    final file = File(
        '${directory.path}/cv_${DateTime.now().millisecondsSinceEpoch}.pdf');

    // Save the PDF
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  static pw.Widget _buildPersonalInfoSection(CVModel cvData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Personal Information',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.Divider(),
        if (cvData.firstName?.isNotEmpty ?? false)
          pw.Text('Name: ${cvData.firstName ?? ''} ${cvData.lastName ?? ''}'),
        if (cvData.email?.isNotEmpty ?? false)
          pw.Text('Email: ${cvData.email}'),
        if (cvData.phone?.isNotEmpty ?? false)
          pw.Text('Phone: ${cvData.phone}'),
        if (cvData.address?.isNotEmpty ?? false)
          pw.Text('Address: ${cvData.address}'),
      ],
    );
  }

  static pw.Widget _buildWorkExperienceSection(
      List<WorkExperience> workExperiences) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Work Experience',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.Divider(),
        if (workExperiences.isNotEmpty)
          ...workExperiences
              .map((work) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Company: ${work.company}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Position: ${work.position}'),
                      pw.Text('Duration: ${work.duration}'),
                      if (work.location?.isNotEmpty ?? false)
                        pw.Text('Location: ${work.location}'),
                      if (work.description?.isNotEmpty ?? false)
                        pw.Text('Description: ${work.description}'),
                      pw.SizedBox(height: 10),
                    ],
                  ))
              .toList()
        else
          pw.Text('No work experience provided'),
      ],
    );
  }

  static pw.Widget _buildEducationSection(List<Education> educations) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Education',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.Divider(),
        if (educations.isNotEmpty)
          ...educations
              .map((education) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Institution: ${education.institution}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Degree: ${education.degree}'),
                      if (education.fieldOfStudy?.isNotEmpty ?? false)
                        pw.Text('Field of Study: ${education.fieldOfStudy}'),
                      pw.Text('Year: ${education.year}'),
                      pw.SizedBox(height: 10),
                    ],
                  ))
              .toList()
        else
          pw.Text('No education information provided'),
      ],
    );
  }

  static pw.Widget _buildSkillsSection(List<String> skills) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Skills',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.Divider(),
        if (skills.isNotEmpty)
          pw.Text(skills.join(', '))
        else
          pw.Text('No skills provided'),
      ],
    );
  }

  static pw.Widget _buildLanguagesSection(List<Language> languages) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Languages',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.Divider(),
        ...languages
            .map((language) => pw.Text(
                  '${language.language}: ${language.level}',
                ))
            .toList(),
      ],
    );
  }

  static pw.Widget _buildCertificatesSection(List<Certificate> certificates) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Certificates',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.Divider(),
        ...certificates
            .map((certificate) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Name: ${certificate.name}'),
                    if (certificate.url.isNotEmpty)
                      pw.Text('URL: ${certificate.url}'),
                    pw.SizedBox(height: 5),
                  ],
                ))
            .toList(),
      ],
    );
  }
}
