// controllers/onboarding_controller.dart
import 'package:ai_music/ui/auth/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  PageController pageController = PageController();
  var currentPage = 0.obs;

  void nextPage() {
    if (currentPage.value < 2) {
      pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Get.off(WelcomeScreen());
    }
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }
}
