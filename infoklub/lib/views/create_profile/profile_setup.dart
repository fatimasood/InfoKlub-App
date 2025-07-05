// profile_setup_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:country_picker/country_picker.dart';
import '../../app/theme.dart';
import '../../viewmodels/profile_setup/profilesetup_viewmodel.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';

class ProfileSetup extends StatefulWidget {
  final String initialName;
  final String initialLastName;
  final String initialEmail;
  final String initialPhone;
  final String initialDob;
  final String initialFlag;
  final String initialCode;
  // Constructor to accept initial values
  const ProfileSetup(
      {super.key,
      required this.initialName,
      required this.initialLastName,
      required this.initialEmail,
      required this.initialPhone,
      required this.initialDob,
      required this.initialFlag,
      required this.initialCode});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileSetupViewModel>(
      create: (_) {
        final vm = ProfileSetupViewModel();
        vm.updateName(widget.initialName, widget.initialLastName);
        vm.updateEmail(widget.initialEmail);
        vm.updatePhone(widget.initialPhone);
        vm.updateDob(widget.initialDob);
        vm.updateCountry(widget.initialFlag, widget.initialCode);
        return vm;
      },
      child: const _ProfileSetupView(),
    );
  }
}

class _ProfileSetupView extends StatelessWidget {
  const _ProfileSetupView();

  get personImage => Image.asset(
        "lib/assets/Images/person.png",
        fit: BoxFit.cover,
      );

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfileSetupViewModel>(context);
    //final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.halfwhite,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Profile Set Up",
                  style: AppTheme.getResponsiveTextTheme(context).labelMedium,
                ),
                Text(
                  "Add Your Details",
                  style: AppTheme.getResponsiveTextTheme(context).labelLarge,
                ),
                const SizedBox(height: 8.0),
                GestureDetector(
                  onTap: () => viewModel.pickImage(context),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppTheme.skyBlue,
                        radius: 60.0,
                        backgroundImage: viewModel.selectedImage != null
                            ? FileImage(viewModel.selectedImage!)
                            : null,
                        child: viewModel.selectedImage == null
                            ? personImage
                            : null,
                      ),
                      /*Positioned(
                        bottom: 10,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 209, 209, 209),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color.fromARGB(255, 209, 209, 209),
                              width: 2.0,
                            ),
                          ),
                          //child: const Icon(Icons.edit),
                        ),
                      ),*/
                    ],
                  ),
                ),
                const SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    viewModel.isEditingName
                        ? SizedBox(
                            width: 180,
                            child: TextField(
                              autofocus: true,
                              onSubmitted: (val) {
                                viewModel.updateName(val, val);
                                viewModel.toggleNameEdit();
                              },
                              decoration: const InputDecoration(
                                hintText: 'Enter Name',
                                border: UnderlineInputBorder(),
                              ),
                              style: AppTheme.getResponsiveTextTheme(context)
                                  .labelMedium,
                            ),
                          )
                        : Text(
                            viewModel.name,
                            style: AppTheme.getResponsiveTextTheme(context)
                                .labelMedium,
                          ),
                    const SizedBox(width: 4.0),
                    GestureDetector(
                      onTap: () {
                        viewModel.toggleNameEdit();
                      },
                      child: const Icon(Icons.edit, color: AppTheme.textColor),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email Address",
                        style: AppTheme.getResponsiveTextTheme(context)
                            .displaySmall,
                      ),
                      const SizedBox(height: 6.0),
                      CustomInput(
                        initialValue: viewModel.email,
                        backgroundColor: AppTheme.halfwhite,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (val) => viewModel.updateEmail(val),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Phone Number",
                        style: AppTheme.getResponsiveTextTheme(context)
                            .displaySmall,
                      ),
                      const SizedBox(height: 6.0),
                      CustomInput(
                        initialValue: viewModel.phone,
                        backgroundColor: AppTheme.halfwhite,
                        keyboardType: TextInputType.phone,
                        hintText: "${viewModel.selectedCode} 726-0592",
                        textColor: Colors.black,
                        hintTextColor: Colors.grey,
                        leftWidget: GestureDetector(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: true,
                              onSelect: (Country country) {
                                viewModel.updateCountry(
                                  country.flagEmoji,
                                  '+${country.phoneCode}',
                                );
                              },
                            );
                          },
                          child: Text(
                            viewModel.selectedFlag,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        onChanged: (val) {
                          viewModel.updatePhone(val);
                        },
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Date of Birth",
                        style: AppTheme.getResponsiveTextTheme(context)
                            .displaySmall,
                      ),
                      const SizedBox(height: 6.0),
                      CustomInput(
                        initialValue: viewModel.dob,
                        backgroundColor: AppTheme.halfwhite,
                        hintText: '24 Oct 2000',
                        keyboardType: TextInputType.text,
                        onChanged: (val) => viewModel.updateDob(val),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "City",
                        style: AppTheme.getResponsiveTextTheme(context)
                            .displaySmall,
                      ),
                      const SizedBox(height: 6.0),
                      CustomInput(
                        hintText: 'City',
                        backgroundColor: AppTheme.halfwhite,
                        keyboardType: TextInputType.streetAddress,
                        onChanged: (val) => viewModel.updateCity(val),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Bio",
                        style: AppTheme.getResponsiveTextTheme(context)
                            .displaySmall,
                      ),
                      const SizedBox(height: 6.0),
                      CustomInput(
                        height: screenHeight * 0.20,
                        hintText: 'About',
                        backgroundColor: AppTheme.halfwhite,
                        keyboardType: TextInputType.multiline,
                        textAlign: TextAlign.start,
                        onChanged: (val) => viewModel.updateBio(val),
                      ),
                      const SizedBox(height: 10.0),
                      CustomButton(
                        text: "Next",
                        onPressed: () =>
                            viewModel.navigateToNextScreen(context),
                        color: AppTheme.secondaryColor,
                        borderRadius: 10.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
