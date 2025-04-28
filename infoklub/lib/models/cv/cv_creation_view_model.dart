import 'dart:io' show File;

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
  })  : workExperience = workExperience ?? [],
        education = education ?? [],
        skills = skills ?? [];

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
    );
  }
}
