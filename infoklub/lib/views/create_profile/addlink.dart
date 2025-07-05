import 'package:flutter/material.dart';
import 'package:infoklub/viewmodels/profile_setup/link_add_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/widgets/custom_input.dart';
import '../../app/routes.dart';
import '../../widgets/custom_button.dart';

class Addlink extends StatelessWidget {
  const Addlink({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (_) => AddLinkViewModel(),
      child: Scaffold(
        backgroundColor: AppTheme.halfwhite,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.02,
                    left: screenWidth * 0.01,
                    right: screenWidth * 0.01,
                  ),
                  child: Consumer<AddLinkViewModel>(
                    builder: (context, vm, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 3.0),
                              Text(
                                "Add Portfolio",
                                style: AppTheme.getResponsiveTextTheme(context)
                                    .labelLarge,
                              ),
                              const SizedBox(height: 2.0),
                              const Text(
                                "Kindly enter at least 1 portfolio",
                                style: TextStyle(
                                    fontSize: 13.5,
                                    color: AppTheme.greyColor,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        buildLinkInput(
                            context, vm, "Behance", vm.behanceController),
                        buildLinkInput(
                            context, vm, "Dribbble", vm.dribbbleController),
                        buildLinkInput(
                            context, vm, "Github", vm.githubController),
                        buildLinkInput(
                            context, vm, "LinkedIn", vm.linkedinController),
                        buildLinkInput(
                            context, vm, "Website", vm.websiteController),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20.0,
                  left: 10.0,
                  right: 10.0,
                  child: Consumer<AddLinkViewModel>(
                    builder: (context, vm, _) => CustomButton(
                      text: "Next",
                      onPressed: () async {
                        if (!vm.validateUrls()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("❌ Enter at least 1 valid link"),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        final success = await vm.saveLinksToHive();
                        if (success) {
                          Navigator.pushNamed(context, AppRoutes.infodashboard);
                        }
                      },
                      color: AppTheme.secondaryColor,
                      borderRadius: 10.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLinkInput(BuildContext context, AddLinkViewModel vm, String label,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: TextAlign.start,
          style: AppTheme.getResponsiveTextTheme(context).displaySmall,
        ),
        const SizedBox(height: 6.0),
        CustomInput(
          controller: controller,
          backgroundColor: AppTheme.halfwhite,
          hintText: 'https://',
          keyboardType: TextInputType.url,
          onChanged: (val) {},
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
