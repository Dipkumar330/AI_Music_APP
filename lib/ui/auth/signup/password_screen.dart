import 'package:ai_music/utils/app_common/colors_cost.dart';
import 'package:ai_music/utils/app_common/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common_component/common_button.dart';
import '../../common_component/common_textfield.dart';
import 'controller/signup_controller.dart';

class PasswordPage extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());

  PasswordPage({super.key});

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
              Text("Set Your Password",
                  style: TextStyle(
                      fontSize: 24, fontFamily: AppFonts.poppinsBold)),
              SizedBox(height: 8),
              Text("Create simple and easy password to remember",
                  style: TextStyle(
                      color: AppColors.greyColor,
                      fontFamily: AppFonts.poppinsRegular)),
              SizedBox(height: 24),
              Obx(
                () => CommonTextField(
                  controller: controller.passwordController,
                  hintText: 'Password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  obscureText: !controller.isPasswordVisible.value,
                  prefixWidget: Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Image.asset('assets/images/lock.png',
                          height: 30.w, width: 30.w)),
                  onToggleVisibility: controller.toggleVisibility,
                ),
              ),
              SizedBox(height: 32),
              Spacer(),
              CommonButton(
                  text: 'Continue', onPressed: controller.submitPassword),
            ],
          ),
        ),
      ),
    );
  }
}
