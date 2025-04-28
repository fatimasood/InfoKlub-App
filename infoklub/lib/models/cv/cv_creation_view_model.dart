import 'dart:io' show File;

class CVModel {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? address;
  String? city;
  String? zipCode;
  File? profileImage;
  List<WorkExperience> workExperience = [];
  List<Education> education = [];
  List<String> skills = [];

  // Default constructor
  CVModel({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.zipCode,
    this.profileImage,
    List<WorkExperience>? workExperience,
    List<Education>? education,
    List<String>? skills,
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
    // ... include all other fields
  }) {
    return CVModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? email,
      phone: phone ?? phone,
      address: address ?? address,
      city: city ?? city,
      zipCode: zipCode ?? zipCode,
      profileImage: profileImage ?? profileImage,
      workExperience: workExperience,
      education: education,
      skills: skills,
    );
  }
}

// Supporting models
class WorkExperience {
  final String company;
  final String position;
  final String duration;

  WorkExperience({
    required this.company,
    required this.position,
    required this.duration,
  });
}

class Education {
  final String institution;
  final String degree;
  final String year;

  Education({
    required this.institution,
    required this.degree,
    required this.year,
  });
}
