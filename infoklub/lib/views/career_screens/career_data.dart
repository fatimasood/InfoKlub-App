// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infoklub/app/routes.dart';
import 'package:infoklub/models/career/career_model.dart';
import 'package:infoklub/services/firebase_services/splash_services.dart';
import 'package:infoklub/utils/utils.dart';
import 'package:infoklub/viewmodels/carrer/career_viewmodel.dart';
import 'package:infoklub/views/career_screens/custom_form_career.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/widgets/drag_dropfile.dart';
import 'package:provider/provider.dart';

class CareerData extends StatefulWidget {
  final String companyName;
  final String jobTitle;
  final String address;
  final String startDate;
  final String endDate;
  final String responsibilities;
  final String document;
  final int? index;

  const CareerData({
    super.key,
    this.companyName = '',
    this.jobTitle = '',
    this.address = '',
    this.startDate = '',
    this.endDate = '',
    this.responsibilities = '',
    this.document = '',
    this.index,
  });

  @override
  State<CareerData> createState() => _CareerDataState();
}

class _CareerDataState extends State<CareerData> {
  String email = userMail;

  late TextEditingController companyNameController;
  late TextEditingController jobTitleController;
  late TextEditingController addressController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController responsibilitiesController;

  @override
  void initState() {
    super.initState();
    companyNameController = TextEditingController(text: widget.companyName);
    jobTitleController = TextEditingController(text: widget.jobTitle);
    addressController = TextEditingController(text: widget.address);
    startDateController = TextEditingController(text: widget.startDate);
    endDateController = TextEditingController(text: widget.endDate);
    responsibilitiesController =
        TextEditingController(text: widget.responsibilities);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = context.read<CareerViewmodel>();
      if (widget.index != null) {
        await vm.loadCareerDataAt(userMail, widget.index!);

        companyNameController.text = vm.companyName;
        jobTitleController.text = vm.jobTitle;
        startDateController.text = vm.startDate;
        endDateController.text = vm.endDate;
        addressController.text = vm.location;
        responsibilitiesController.text = vm.responsibilities;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    companyNameController.dispose();
    jobTitleController.dispose();
    addressController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    responsibilitiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CareerViewmodel()..initialize(email),
      builder: (context, _) {
        return _CareerInfoView(
          companyNameController: companyNameController,
          jobTitleController: jobTitleController,
          addressController: addressController,
          startDateController: startDateController,
          endDateController: endDateController,
          responsibilitiesController: responsibilitiesController,
          editIndex: widget.index,
        );
      },
    );
  }
}

class _CareerInfoView extends StatefulWidget {
  final TextEditingController companyNameController;
  final TextEditingController jobTitleController;
  final TextEditingController addressController;
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final TextEditingController responsibilitiesController;
  final int? editIndex;
  const _CareerInfoView({
    required this.companyNameController,
    required this.jobTitleController,
    required this.addressController,
    required this.startDateController,
    required this.endDateController,
    required this.responsibilitiesController,
    this.editIndex,
  });

  @override
  State<_CareerInfoView> createState() => _CareerInfoViewState();
}

class _CareerInfoViewState extends State<_CareerInfoView> {
  @override
  Widget build(BuildContext context) {
    final careerViewmodel = Provider.of<CareerViewmodel>(context);

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
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.04,
                screenHeight * 0.02,
                screenWidth * 0.04,
                100,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FileUploadWidget(onUploadTap: () {
                      careerViewmodel.pickDocument();
                    }),
                    if (careerViewmodel.uploadedDocs.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        "Uploaded Documents",
                        style: TextStyle(
                          fontSize: isTablet ? 20.0 : 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          color: AppTheme.blackColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: careerViewmodel.uploadedDocs.length,
                        itemBuilder: (context, index) {
                          final path = careerViewmodel.uploadedDocs[index];
                          final isImage = path.endsWith('.jpg') ||
                              path.endsWith('.jpeg') ||
                              path.endsWith('.png');

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 6.0),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.whiteColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey[300]!),
                              boxShadow: [
                                BoxShadow(
                                  // ignore: deprecated_member_use
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                isImage
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(path),
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.insert_drive_file,
                                        color: AppTheme.secondaryColor,
                                        size: 40,
                                      ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    path.split('/').last,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.greyblacktext,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () {
                                    careerViewmodel.uploadedDocs
                                        .removeAt(index);
                                    careerViewmodel
                                        .notifyListeners(); // To update the UI
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 10.0),
                    ReusableFormCareer(
                      companyNameController: widget.companyNameController,
                      jobTitleController: widget.jobTitleController,
                      addressController: widget.addressController,
                      startDateController: widget.startDateController,
                      endDateController: widget.endDateController,
                      responsibilitiesController:
                          widget.responsibilitiesController,
                      onFileUpload: () {
                        if (kDebugMode) {
                          print("File upload clicked");
                        }
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
                    onPressed: () async {
                      // check data entered '

                      if (widget.companyNameController.text.isEmpty ||
                          widget.jobTitleController.text.isEmpty ||
                          widget.addressController.text.isEmpty ||
                          widget.startDateController.text.isEmpty ||
                          widget.responsibilitiesController.text.isEmpty) {
                        Utils().toastMessage("Enter all required fields");
                        return;
                      }
                      final viewModel =
                          Provider.of<CareerViewmodel>(context, listen: false);
                      final String email = userMail;
                      if (kDebugMode) {
                        print("Saving for email: $email");
                      }
                      final info = CarrerModel(
                        jobTitle: widget.jobTitleController.text.trim(),
                        companyName: widget.companyNameController.text.trim(),
                        startDate: widget.startDateController.text.trim(),
                        endDate: widget.endDateController.text.trim(),
                        responsibilities:
                            widget.responsibilitiesController.text.trim(),
                        location: widget.addressController.text.trim(),
                        documentPaths:
                            List<String>.from(viewModel.uploadedDocs),
                      );

                      if (kDebugMode) {
                        print("yaha gr barrrr lgti ha");
                        print("Company Name: ${viewModel.companyName}");
                        print("Job Title: ${viewModel.jobTitle}");
                        print("Address: ${viewModel.location}");
                        print("Start Date: ${viewModel.startDate}");
                        print("End Date: ${viewModel.endDate}");
                        print(
                            "responsibilities: ${viewModel.responsibilities}");
                        print(viewModel.uploadedDocs);
                      }

                      if (widget.editIndex != null) {
                        // 🔄 Update existing entry
                        await viewModel.updateCareerInfoAt(
                            email, widget.editIndex!, info);
                        Utils().toastMessage(
                            "Career record updated successfully...");
                        Navigator.pushNamed(context, AppRoutes.careerInfo);
                      } else {
                        // ➕ Add new entry
                        await viewModel.saveCareerInfo(email, info);
                        Utils().toastMessage(
                            "Career record saved successfully...");
                        Navigator.pushNamed(context, AppRoutes.careerInfo);
                      }

                      viewModel.clearCareerData();
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
