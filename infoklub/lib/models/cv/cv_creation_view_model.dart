import 'dart:io' show File;

// Define these classes outside of CVModel
class Activity {
  final String name;
  final String description;

  Activity({required this.name, required this.description});
}

class Language {
  final String language;
  final String level;

  Language({required this.language, required this.level});
}

class Certificate {
  final String name;
  final String url;

  Certificate({required this.name, required this.url});
}

class WorkExperience {
  final String company;
  final String position;
  final String duration;
  final String? location;
  final String? description;

  WorkExperience({
    required this.company,
    required this.position,
    required this.duration,
    this.location,
    this.description,
  });
}

class Education {
  final String institution;
  final String degree;
  final String year;
  final String? fieldOfStudy;

  Education({
    required this.institution,
    required this.degree,
    required this.year,
    this.fieldOfStudy,
  });
}

class CVModel {
  // Personal Info
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? address;
  File? profileImage;

  // Work Experience
  List<WorkExperience> workExperience = [];

  // Education
  List<Education> education = [];

  // Skills
  List<String> skills = [];

  // Other Info
  String? summary;
  String? references;

  // Activities
  List<Activity> activities = [];

  // Languages
  List<Language> languages = [];

  // Certificates
  List<Certificate> certificates = [];

  // Default constructor
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
    this.references,
    List<Activity>? activities,
    List<Language>? languages,
    List<Certificate>? certificates,
  })  : workExperience = workExperience ?? [],
        education = education ?? [],
        skills = skills ?? [],
        activities = activities ?? [],
        languages = languages ?? [],
        certificates = certificates ?? [];

  // Factory constructor for empty CV
  factory CVModel.empty() {
    return CVModel();
  }

  // Add copyWith method for immutability patterns
  CVModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    File? profileImage,
    List<WorkExperience>? workExperience,
    List<Education>? education,
    List<String>? skills,
    String? summary,
    String? references,
    List<Activity>? activities,
    List<Language>? languages,
    List<Certificate>? certificates,
  }) {
    return CVModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      profileImage: profileImage ?? this.profileImage,
      workExperience: workExperience ?? this.workExperience,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      summary: summary ?? this.summary,
      references: references ?? this.references,
      activities: activities ?? this.activities,
      languages: languages ?? this.languages,
      certificates: certificates ?? this.certificates,
    );
  }
}
