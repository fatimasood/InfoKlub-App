import 'dart:io';

import 'package:infoklub/models/cv/cv_creation_view_model.dart';
import 'package:infoklub/services/pdf_generating_service/tempalte4.dart';
import 'package:infoklub/services/pdf_generating_service/template1.dart';
import 'package:infoklub/services/pdf_generating_service/template2.dart';
import 'package:infoklub/services/pdf_generating_service/template3.dart';
import 'package:infoklub/services/pdf_generating_service/template5.dart';

abstract class CVTemplate {
  Future<File> generateCV(CVModel cvData);
  String get name;
  String get imageAsset;
}

// templates/template1.dart
class Template1 implements CVTemplate {
  @override
  String get name => "Professional";

  @override
  String get imageAsset => "lib/assets/cv_tem/cvtemp1.png";

  @override
  Future<File> generateCV(CVModel cvData) async {
    return await PdfGenerationService.generateCV(cvData);
  }
}

// templates/template2.dart
class Template2 implements CVTemplate {
  @override
  String get name => "Modern";

  @override
  String get imageAsset => "lib/assets/cv_tem/cvtemp2.png";

  @override
  Future<File> generateCV(CVModel cvData) async {
    return await Template2PdfService.generateCV(cvData);
  }
}

// templates/template3.dart
class Template3 implements CVTemplate {
  @override
  String get name => "Creative";

  @override
  String get imageAsset => "lib/assets/cv_tem/cvtemp3.png";

  @override
  Future<File> generateCV(CVModel cvData) async {
    return await Template3PdfService.generateCV(cvData);
  }
}

// templates/template4.dart
class Template4 implements CVTemplate {
  @override
  String get name => "Minimalist";

  @override
  String get imageAsset => "lib/assets/cv_tem/cvtemp4.png";

  @override
  Future<File> generateCV(CVModel cvData) async {
    return await Tempalte4PdfService.generateCV(cvData);
  }
}

// templates/template5.dart
class Template5 implements CVTemplate {
  @override
  String get name => "Executive";

  @override
  String get imageAsset => "lib/assets/cv_tem/cvtemp5.png";

  @override
  Future<File> generateCV(CVModel cvData) async {
    return await Template5PdfService.generateCV(cvData);
  }
}
