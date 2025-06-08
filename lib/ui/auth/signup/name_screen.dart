import 'package:ai_music/ui/common_component/common_textfield.dart';
import 'package:ai_music/utils/app_common/colors_cost.dart';
import 'package:ai_music/utils/app_common/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common_component/common_button.dart';
import 'controller/signup_controller.dart';

class NameScreen extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());

  NameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(),
          elevation: 0,
          backgroundColor: Colors.transparent),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("What's Your Name",
                style:
                    TextStyle(fontSize: 24, fontFamily: AppFonts.poppinsBold)),
            SizedBox(height: 8.h),
            Text("You won't able to change this later",
                style: TextStyle(
                    color: AppColors.greyColor,
                    fontFamily: AppFonts.poppinsRegular)),
            SizedBox(height: 24.h),
            CommonTextField(
              controller: controller.nameController,
              hintText: "Enter your name",
              icon: Icons.person,
              prefixWidget: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Icon(Icons.person)),
            ),
            SizedBox(height: 32.h),
            Spacer(),
            CommonButton(text: 'Continue', onPressed: controller.submitName),
          ],
        ),
      ),
    );
  }
}
