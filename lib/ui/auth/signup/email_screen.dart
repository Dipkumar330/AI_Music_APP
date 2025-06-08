import 'package:ai_music/ui/common_component/common_textfield.dart';
import 'package:ai_music/utils/app_common/colors_cost.dart';
import 'package:ai_music/utils/app_common/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common_component/common_button.dart';
import 'controller/signup_controller.dart';

class EmailScreen extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());

  EmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
            leading: BackButton(),
            backgroundColor: Colors.transparent,
            elevation: 0),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("What’s Your Email",
                  style: TextStyle(
                      fontSize: 24, fontFamily: AppFonts.poppinsBold)),
              SizedBox(height: 8.h),
              Text("You won’t be able to change this later",
                  style: TextStyle(
                      color: AppColors.greyColor,
                      fontFamily: AppFonts.poppinsRegular)),
              SizedBox(height: 24.h),
              // TextField(
              //   controller: controller.emailController,
              //   keyboardType: TextInputType.emailAddress,
              //   decoration: InputDecoration(
              //     hintText: "example@email.com",
              //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              //     contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              //   ),
              // ),
              CommonTextField(
                  controller: controller.emailController,
                  hintText: "example@email.com"),
              SizedBox(height: 32.h),
              Spacer(),
              CommonButton(text: 'Continue', onPressed: controller.submitEmail),
            ],
          ),
        ),
      ),
    );
  }
}
