import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/widgets/custom_button.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(const MaterialApp(
    home: PdfDownloadScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class PdfDownloadScreen extends StatefulWidget {
  const PdfDownloadScreen({super.key});

  @override
  State<PdfDownloadScreen> createState() => _PdfDownloadScreenState();
}

class _PdfDownloadScreenState extends State<PdfDownloadScreen> {
  bool _isGenerating = false;
  double _progress = 0;
  Uint8List? _cachedPdfBytes;
  StreamController<double>? _progressController;
  bool _hasError = false;

  @override
  void dispose() {
    _progressController?.close();
    super.dispose();
  }

  Future<void> _generateAndSavePdf() async {
    if (_cachedPdfBytes != null) {
      await _saveAndOpenPdf(_cachedPdfBytes!);
      return;
    }

    setState(() {
      _isGenerating = true;
      _progress = 0;
      _hasError = false;
    });

    _progressController = StreamController<double>();
    final completer = Completer<Uint8List>();
    final receivePort = ReceivePort();

    try {
      await Isolate.spawn(
        _generatePdfInBackground,
        _IsolateParams(receivePort.sendPort),
      );

      receivePort.listen((message) {
        if (message is double) {
          setState(() {
            _progress = message;
          });
        } else if (message is Uint8List) {
          _cachedPdfBytes = message;
          completer.complete(message);
          receivePort.close();
        } else if (message is String) {
          _hasError = true;
          _showErrorSnackbar(message);
          receivePort.close();
        }
      });

      final pdfBytes = await completer.future.timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw TimeoutException('PDF generation took too long');
        },
      );

      await _saveAndOpenPdf(pdfBytes);
    } catch (e) {
      _showErrorSnackbar('Failed: ${e.toString()}');
      setState(() => _hasError = true);
    } finally {
      _progressController?.close();
      setState(() => _isGenerating = false);
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _saveAndOpenPdf(Uint8List bytes) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File(
          '${dir.path}/resume_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    } catch (e) {
      _showErrorSnackbar('Failed to save PDF: ${e.toString()}');
    }
  }

  static Future<void> _generatePdfInBackground(_IsolateParams params) async {
    final sendPort = params.sendPort;

    try {
      final pdf = pw.Document();
      double progress = 0;

      void updateProgress(double value) {
        progress = value;
        sendPort.send(progress);
      }

      updateProgress(0.1);

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            final sections = [
              _buildHeader(),
              pw.SizedBox(height: 20),
              _buildSummary(),
              pw.SizedBox(height: 20),
              _buildEducation(),
              pw.SizedBox(height: 20),
              _buildWorkExperience(),
              pw.SizedBox(height: 20),
              _buildExtracurricular(),
              pw.SizedBox(height: 20),
              _buildSkillsCertificates(),
            ];

            for (int i = 0; i < sections.length; i++) {
              updateProgress(0.1 + (0.8 * (i / sections.length)));
            }

            return sections;
          },
        ),
      );

      final bytes = await pdf.save();
      updateProgress(1.0);
      sendPort.send(bytes);
    } catch (e) {
      sendPort.send('Error generating PDF: $e');
    }
  }

  static pw.Widget _buildHeader() => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Name',
              style:
                  pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text('Email: youremail@gmail.com | Mobile: +441234567890',
              style: const pw.TextStyle(fontSize: 12)),
          pw.Text('LinkedIn: linkedin.com/yourhandle | Address: City, UK',
              style: const pw.TextStyle(fontSize: 12)),
        ],
      );

  static pw.Widget _buildSummary() => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('SUMMARY',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text(
            'Recent MSc graduate in International Business Management with expertise in client communication and administration. Seeking a Paralegal role at HFIS Limited. Right to work in the UK.',
            style: const pw.TextStyle(fontSize: 12),
          ),
        ],
      );

  static pw.Widget _buildEducation() => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('EDUCATION',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text(
              'MSc in Public Policy and Management, King\'s College London (2021-2022)',
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.Text(
              'Modules: Economics, Research Methods, e-Services | Distinction',
              style: const pw.TextStyle(fontSize: 12)),
          pw.SizedBox(height: 8),
          pw.Text(
              'BA in Arabic and French, University College London (2017-2021)',
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.Text(
              'Modules: Literature, Political Economy | Study Abroad in Jordan & France',
              style: const pw.TextStyle(fontSize: 12)),
        ],
      );

  static pw.Widget _buildWorkExperience() => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('WORK EXPERIENCE',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text('Sales Analyst | IDEAGlobal | London | 2023',
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.Bullet(
              text: 'Improved client response time by 15%',
              style: const pw.TextStyle(fontSize: 12)),
          pw.Bullet(
              text: 'Reduced data access time by 30%',
              style: const pw.TextStyle(fontSize: 12)),
          pw.SizedBox(height: 8),
          pw.Text('Account Manager | Just Gifts | Mumbai | 2020-2022',
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.Bullet(
              text: 'Boosted revenue by 30%',
              style: const pw.TextStyle(fontSize: 12)),
          pw.Bullet(
              text: 'Trained 45 staff on tools',
              style: const pw.TextStyle(fontSize: 12)),
        ],
      );

  static pw.Widget _buildExtracurricular() => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('EXTRACURRICULAR ACTIVITIES',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Bullet(
              text: 'Media Secretary - increased merchandise sales by 50%',
              style: const pw.TextStyle(fontSize: 12)),
          pw.Bullet(
              text: 'Treasurer - raised £5,000',
              style: const pw.TextStyle(fontSize: 12)),
        ],
      );

  static pw.Widget _buildSkillsCertificates() => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('SKILLS & CERTIFICATES',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text('Languages: English (native), Spanish (intermediate)',
              style: const pw.TextStyle(fontSize: 12)),
          pw.Text('Skills: SEO, SEM, Google Analytics, HTML, CSS, JS',
              style: const pw.TextStyle(fontSize: 12)),
          pw.Text('Certifications: Google Analytics, Facebook Blueprint',
              style: const pw.TextStyle(fontSize: 12)),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Download Resume'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.picture_as_pdf, size: 100, color: Colors.red),
              const SizedBox(height: 20),
              const Text('Generate and Download Resume PDF',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor)),
              const SizedBox(height: 30),
              if (_isGenerating) ...[
                LinearProgressIndicator(value: _progress),
                const SizedBox(height: 10),
                Text('${(_progress * 100).toStringAsFixed(0)}% completed'),
                const SizedBox(height: 20),
                if (_hasError)
                  OutlinedButton(
                    onPressed: _generateAndSavePdf,
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red)),
                    child: const Text('Retry',
                        style: TextStyle(color: Colors.red)),
                  ),
              ] else ...[
                SizedBox(
                  width: 150,
                  child: CustomButton(
                      color: AppTheme.secondaryColor,
                      text: "Download PDF",
                      onPressed: _generateAndSavePdf),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _IsolateParams {
  final SendPort sendPort;
  _IsolateParams(this.sendPort);
}
