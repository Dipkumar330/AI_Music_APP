import 'package:ai_music/ui/common_component/common_textfield.dart';
import 'package:ai_music/utils/app_common/colors_cost.dart';
import 'package:ai_music/utils/app_common/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common_component/common_button.dart';
import 'controller/signup_controller.dart';

class BirthdatePage extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(),
          backgroundColor: Colors.transparent,
          elevation: 0),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("My Birthdate is",
                style:
                    TextStyle(fontSize: 24, fontFamily: AppFonts.poppinsBold)),
            SizedBox(height: 8.h),
            Text("Use this to show your age",
                style: TextStyle(
                    color: AppColors.greyColor,
                    fontFamily: AppFonts.poppinsRegular)),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: () => controller.pickDate(context),
              child: AbsorbPointer(
                  child: CommonTextField(
                      controller: controller.birthdateController,
                      hintText: "Select Date",
                      textAlign: TextAlign.center,
                      contentPadding: EdgeInsets.zero)),
            ),
            SizedBox(height: 32.h),
            Spacer(),
            CommonButton(
                text: 'Continue', onPressed: controller.submitBirthdate),
          ],
        ),
      ),
    );
  }
}
