// screens/onboarding_screen.dart
import 'package:ai_music/utils/app_common/colors_cost.dart';
import 'package:ai_music/utils/app_common/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../common_component/common_button.dart';
import 'on_boarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  final controller = Get.put(OnboardingController());

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Welcome & Personalised Music Experience",
      "subtitle": "Discover music like never before.\nTailored just for you.",
      "image": "assets/images/onboarding1.png"
    },
    {
      "title": "AI Powered Recommendations",
      "subtitle":
          "Let AI match your mood with music.\nEnjoy smart suggestions.",
      "image": "assets/images/onboarding2.png"
    },
    {
      "title": "Lyrics and Playback Together",
      "subtitle": "Sing along and feel the music.\nLyrics in real time.",
      "image": "assets/images/onboarding3.png"
    },
  ];

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF9B5DE5), Color(0xFF5F0A87)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFA259FF), Color(0xFF5D0BE3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.asset(onboardingData[index]['image']!,
                                height: 300, fit: BoxFit.cover)),
                      ),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(onboardingData[index]['title']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 24,
                                fontFamily: AppFonts.poppinsBold,
                                color: AppColors.whiteColor)),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          onboardingData[index]['subtitle']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16,
                              fontFamily: AppFonts.poppinsRegular,
                              color: AppColors.whiteColor),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: controller.currentPage.value == index ? 12 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                        color: controller.currentPage.value == index
                            ? Colors.white
                            : Colors.white38,
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: CommonButton(
                    text: "Next",
                    backgroundColor: Colors.white,
                    textColor: AppColors.blackColor,
                    onPressed: controller.nextPage)),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
