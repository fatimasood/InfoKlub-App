import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';

import '../../app/routes.dart';
import '../../widgets/custom_button.dart';

class OnboardOne extends StatefulWidget {
  const OnboardOne({super.key});

  @override
  State<OnboardOne> createState() => _OnboardOneState();
}

class _OnboardOneState extends State<OnboardOne> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // PageView to allow swiping between pages
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  // Page 1: OnboardOne
                  _buildPage(
                    image: 'lib/assets/Images/onboardone.png',
                    title: "\t\tEasily Manage Your\n Medical Records Here",
                    description:
                        "Upload and manage your medical\n\t\t\t\t\t\t\t\t\t documents with ease.",
                  ),
                  // Page 2: OnboardTwo
                  _buildPage(
                    image: 'lib/assets/Images/onboard2.png',
                    title: "\t\t\t\tOrganize Your\n Education History",
                    description:
                        "Keep track of your educational\n\t\t\t\t\t\t\t\t journey in one place.",
                  ),
                  // Page 3: OnboardThree
                  _buildPage(
                    image: 'lib/assets/Images/onboard3.png',
                    title: "Manage Your Career\n\t\t\t\t\t\t\t\t\t\t\t History",
                    description:
                        "Document your professional journey\n\t\t\t\t\t by uploading career records.",
                  ),
                ],
              ),
            ),
            // Page indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  width: _currentPage == index ? 20.0 : 10.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppTheme.secondaryColor
                        : AppTheme.greyColor,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                );
              }),
            ),
            const SizedBox(
              height: 40.0,
            ),

            // Show SKIP and Next/ Get Started button
            if (_currentPage < 2)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.profile);
                    },
                    child: Text(
                      "SKIP",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppTheme.blackColor,
                        fontSize: screenHeight * 0.020,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  CustomButton(
                    text: "Next",
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    color: AppTheme.secondaryColor,
                    textColor: AppTheme.whiteColor,
                    borderRadius: 10.0,
                    height: screenHeight * 0.058,
                    width: screenWidth * 0.3,
                  ),
                ],
              )
            else
              // Centered "Get Started" button for last page
              Center(
                child: CustomButton(
                  text: "Get Started",
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.profile);
                  },
                  color: AppTheme.secondaryColor,
                  textColor: AppTheme.whiteColor,
                  borderRadius: 10.0,
                  height: screenHeight * 0.058,
                  width: screenWidth * 0.5,
                ),
              ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required String image,
    required String title,
    required String description,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            image,
            width: screenWidth * 0.6,
            height: screenHeight * 0.6,
          ),
        ),
        SizedBox(
          height: screenHeight * 0.01,
        ),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Inter',
            color: AppTheme.blackColor,
            fontSize: screenHeight * 0.027,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Text(
          description,
          style: TextStyle(
            fontFamily: 'Inter',
            color: AppTheme.greyColor,
            fontSize: screenHeight * 0.018,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
