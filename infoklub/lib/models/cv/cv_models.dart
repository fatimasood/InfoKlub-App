import 'dart:io';

import 'package:infoklub/models/cv/cv_creation_view_model.dart';

class CVModel {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? address;
  File? profileImage;
  List<WorkExperience> workExperience = [];
  List<Education> education = [];
  List<String> skills = [];
  String? summary;
  List<Language> languages = [];
  List<Certificate> certificates = [];

  CVModel({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.address,
    this.profileImage,
    List<WorkExperience>? workExperience,
    List<Education>? education,
    List<String>? skills,
    this.summary,
    List<Language>? languages,
    List<Certificate>? certificates,
  })  : workExperience = workExperience ?? [],
        education = education ?? [],
        skills = skills ?? [],
        languages = languages ?? [],
        certificates = certificates ?? [];

  factory CVModel.empty() => CVModel();
}
