import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:ai_music/ui/bottombar/settings/profile/controller/profile_controller.dart';
import 'package:ai_music/ui/common_component/common_button.dart';
import 'package:ai_music/utils/app_common/fonts.dart';
import 'package:ai_music/utils/size_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common_component/common_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key}) {}

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> with AfterLayoutMixin {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Future<FutureOr<void>> afterFirstLayout(BuildContext context) async {
    await controller.getProfileAPiCall();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xFFA678F2),
        appBar: AppBar(
          backgroundColor: Color(0xFFA678F2),
          elevation: 0,
          title: Text(
            'Edit Profile',
            style: TextStyle(color: Colors.white, fontFamily: AppFonts.poppinsSemiBold),
          ),
          leading: BackButton(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Name', controller.nameController),
              buildTextField('Email', controller.emailController, enabled: false),
              // buildTextField('Date of Birth', controller.dobController),
              Text(
                'Date of Birth',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppFonts.poppinsSemiBold,
                  color: Colors.white,
                ),
              ),
              5.sizeBoxH,
              GestureDetector(
                onTap: () => controller.pickDate(context),
                child: AbsorbPointer(
                  child: CommonTextField(
                    controller: controller.dobController,
                    hintText: "Select Date",
                  ),
                ),
              ),
              buildTextField('Mobile Number', controller.mobileController, enabled: false),
              SizedBox(height: 20),
              Spacer(),
              CommonButton(text: 'Save changes', onPressed: controller.saveChanges),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontFamily: AppFonts.poppinsSemiBold,
              color: Colors.white,
            ),
          ),
          5.sizeBoxH,
          CommonTextField(controller: controller, hintText: label, enabled: enabled),
          // TextField(
          //   controller: controller,
          //   obscureText: obscureText,
          //   style: TextStyle(color: Colors.black, fontFamily: AppFonts.poppinsRegular),
          //   decoration: InputDecoration(
          //     filled: true,
          //     fillColor: Colors.white,
          //     hintText: label,
          //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          //   ),
          // ),
        ],
      ),
    );
  }
}
