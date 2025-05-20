// profile_setup_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:country_picker/country_picker.dart';

import '../../app/constants.dart';
import '../../app/theme.dart';
import '../../viewmodels/profile_setup/profilesetup_viewmodel.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';

class ProfileSetup extends StatelessWidget {
  const ProfileSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileSetupViewModel(),
      child: const _ProfileSetupView(),
    );
  }
}

class _ProfileSetupView extends StatelessWidget {
  const _ProfileSetupView();

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
                      Positioned(
                        bottom: 10,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.greyColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.greyColor,
                              width: 2.0,
                            ),
                          ),
                          child: const Icon(Icons.edit),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      personName,
                      style:
                          AppTheme.getResponsiveTextTheme(context).labelMedium,
                    ),
                    const SizedBox(width: 4.0),
                    const Icon(Icons.edit),
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
                      const CustomInput(
                        backgroundColor: AppTheme.halfwhite,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Phone Number",
                        style: AppTheme.getResponsiveTextTheme(context)
                            .displaySmall,
                      ),
                      const SizedBox(height: 6.0),
                      CustomInput(
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
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Date of Birth",
                        style: AppTheme.getResponsiveTextTheme(context)
                            .displaySmall,
                      ),
                      const SizedBox(height: 6.0),
                      const CustomInput(
                        backgroundColor: AppTheme.halfwhite,
                        hintText: '24 Oct 2000',
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "City",
                        style: AppTheme.getResponsiveTextTheme(context)
                            .displaySmall,
                      ),
                      const SizedBox(height: 6.0),
                      const CustomInput(
                        hintText: 'City',
                        backgroundColor: AppTheme.halfwhite,
                        keyboardType: TextInputType.streetAddress,
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
                      ),
                      const SizedBox(height: 10.0),
                      CustomButton(
                        text: "Connect with",
                        onPressed: () {
                          // connect with linkedln
                        },
                        image: Image.asset(
                          "lib/assets/Images/linkedlnlogo.png",
                          height: 40,
                          width: 60,
                        ),
                        color: AppTheme.whiteColor,
                        textColor: AppTheme.secondaryColor,
                        borderColor: AppTheme.secondaryColor,
                        borderRadius: 10.0,
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
