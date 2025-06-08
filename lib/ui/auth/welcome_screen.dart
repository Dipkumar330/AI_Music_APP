import 'package:ai_music/ui/auth/login/controller/login_binding.dart';
import 'package:ai_music/ui/auth/login/login_with_email.dart';
import 'package:ai_music/ui/auth/signup/phone_number_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/app_common/colors_cost.dart';
import '../../utils/app_common/fonts.dart';
import '../common_component/common_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.welcomeScreenBackgroundColor,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/images/background_grid.png', fit: BoxFit.cover),
          ),
          // Gradient Overlay
          Positioned.fill(
            top: MediaQuery.sizeOf(context).height / 6,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  tileMode: TileMode.mirror,
                  colors: [
                    Colors.transparent,
                    Color(0xFF7C58E6), // Light purple/blue top
                    Color(0xFFE049F9), // Middle gradient blend
                    // Color(0xFFFF65A3), // Pink bottom
                  ],
                ),
              ),
            ),
          ),
          // Foreground Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    "Experience Realtime music with your friends",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: AppFonts.poppinsSemiBold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: const Text(
                    "Join millions of music lovers and connect, discover, and groove together!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontFamily: AppFonts.poppinsRegular,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: CommonButton(
                    text: "Login with Phone",
                    backgroundColor: Colors.white,
                    textColor: Colors.blue,
                    onPressed: () {
                      Get.to(PhoneNumberScreen(), binding: LogInBinding());
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: CommonButton(
                    text: "Login with Email",
                    backgroundColor: Colors.white,
                    textColor: Colors.blue,
                    onPressed: () {
                      Get.to(LoginWithEmailScreen(), binding: LogInBinding());
                    },
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
