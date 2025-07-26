import 'package:flutter/material.dart';

class CareerViewmodel extends ChangeNotifier {
  String jobTitle = '';
  String companyName = '';
  String startDate = '';
  String endDate = '';
  String skills = '';
  String location = '';

  void jobTitleName(String val) => jobTitle = val;
  void company(String val) => companyName = val;
  void startDateName(String val) => startDate = val;
  void endDateName(String val) => endDate = val;
  void skillsName(String val) => skills = val;
  void locationName(String val) => location = val;
}
