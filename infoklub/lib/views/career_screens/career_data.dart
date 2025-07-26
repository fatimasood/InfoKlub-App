import 'package:flutter/material.dart';
import 'package:infoklub/main.dart';
import 'package:infoklub/viewmodels/carrer/career_viewmodel.dart';
import 'package:infoklub/views/career_screens/widget/custom_form_career.dart';
import 'package:infoklub/widgets/custom_button.dart';
import 'package:infoklub/app/theme.dart';
import 'package:provider/provider.dart';
import '../../app/routes.dart';

class CareerData extends StatefulWidget {
  final String companyName;
  final String jobTitle;
  final String address;
  final String startDate;
  final String endDate;
  final String skills;
  final String document;

  const CareerData({
    super.key,
    this.companyName = '',
    this.jobTitle = '',
    this.address = '',
    this.startDate = '',
    this.endDate = '',
    this.skills = '',
    this.document = '',
  });

  @override
  State<CareerData> createState() => _CareerDataState();
}

class _CareerDataState extends State<CareerData> {
  final String email = userMail;
  late CareerViewmodel careerViewmodel;
  late TextEditingController companyNameController;
  late TextEditingController jobTitleController;
  late TextEditingController addressController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController skillsController;

  @override
  void initState() {
    super.initState();
    careerViewmodel = Provider.of<CareerViewmodel>(context, listen: false);

    careerViewmodel.uploadedDocs = [];

    companyNameController = TextEditingController(text: widget.companyName);
    jobTitleController = TextEditingController(text: widget.jobTitle);
    addressController = TextEditingController(text: widget.address);
    startDateController = TextEditingController(text: widget.startDate);
    endDateController = TextEditingController(text: widget.endDate);
    skillsController = TextEditingController(text: widget.skills);
  }

  @override
  void dispose() {
    companyNameController.dispose();
    jobTitleController.dispose();
    addressController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    skillsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: careerViewmodel,
        child: _CareerInfoView(
          companyNameController: companyNameController,
          jobTitleController: jobTitleController,
          addressController: addressController,
          startDateController: startDateController,
          endDateController: endDateController,
          skillsController: skillsController,
          careerViewmodel: careerViewmodel,
        ));
  }
}

class _CareerInfoView extends StatelessWidget {
  final TextEditingController companyNameController;
  final TextEditingController jobTitleController;
  final TextEditingController addressController;
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final TextEditingController skillsController;
  const _CareerInfoView({
    super.key,
    required this.companyNameController,
    required this.jobTitleController,
    required this.addressController,
    required this.startDateController,
    required this.endDateController,
    required this.skillsController,
    required CareerViewmodel careerViewmodel,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppTheme.textColor,
            size: 18,
          ),
        ),
        title: Text(
          "Add Career Information",
          style: AppTheme.getResponsiveTextTheme(context).labelLarge,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomButton(
                      text: 'Add Experience',
                      color: const Color(0xFFFFFFFF),
                      borderColor: Colors.grey,
                      borderRadius: 10.0,
                      textColor: AppTheme.blackColor,
                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        print("Add experience Button Pressed");
                      },
                    ),
                    //take info from user
                    ReusableFormCareer(
                      companyNameController: companyNameController,
                      jobTitleController: jobTitleController,
                      addressController: addressController,
                      startDateController: startDateController,
                      endDateController: endDateController,
                      skillsController: skillsController,
                      onFileUpload: () {
                        print("File upload clicked");
                      },
                      onScanDocuments: () {
                        print("Scan documents clicked");
                      },
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                    bottom: 20, left: 10, right: 10, top: 0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.careerInfo);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.purpleAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
