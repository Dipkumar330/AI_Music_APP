import 'package:ai_music/model/user_model.dart';
import 'package:ai_music/ui/auth/welcome_screen.dart';
import 'package:ai_music/ui/bottombar/settings/privarcy/privarcy_screen.dart';
import 'package:ai_music/ui/bottombar/settings/profile/controller/profile_screen.dart';
import 'package:ai_music/ui/bottombar/settings/report_problem/report_problem_screen.dart';
import 'package:ai_music/utils/app_common/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'help_support/help_support_screen.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  Widget section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: AppFonts.poppinsBold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget item(String label, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: AppFonts.poppinsRegular,
        ),
      ),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sections
              section("Account", [
                item("Edit profile", () {
                  Get.to(EditProfileScreen());
                }),
                item("Security", () {
                  Get.to(PrivacyPolicyPage());
                }),
                item("Privacy", () {
                  Get.to(PrivacyPolicyPage());
                }),
              ]),
              section("Support & About", [
                item("Help & Support", () {
                  Get.to(HelpSupportPage());
                }),
                item("Terms and Policies", () {
                  Get.to(PrivacyPolicyPage());
                }),
              ]),
              section("Actions", [
                item("Report a problem", () {
                  Get.to(ReportProblemPage());
                }),
                item("Log out", () {
                  userModelSingleton.clearPreference();
                  userModelSingleton.accessToken = "";
                  Get.offAll(WelcomeScreen());
                }),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
