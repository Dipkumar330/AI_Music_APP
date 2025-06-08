// screens/login_screen.dart
import 'package:ai_music/ui/auth/signup/phone_number_screen.dart';
import 'package:ai_music/utils/app_common/colors_cost.dart';
import 'package:ai_music/utils/app_common/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common_component/common_button.dart';
import '../../common_component/common_textfield.dart';
import 'controller/login_controller.dart';

class LoginWithEmailScreen extends StatefulWidget {
  const LoginWithEmailScreen({super.key});

  @override
  State<LoginWithEmailScreen> createState() => _LoginWithEmailScreenState();
}

class _LoginWithEmailScreenState extends State<LoginWithEmailScreen> {
  final LoginController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(backgroundColor: AppColors.whiteColor),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome back",
                style: TextStyle(fontSize: 26, fontFamily: AppFonts.poppinsBold),
              ),
              SizedBox(height: 8.h),
              const Text(
                "Please enter your email & password to signin.",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.greyColor,
                  fontFamily: AppFonts.poppinsRegular,
                ),
              ),
              SizedBox(height: 32.h),
              CommonTextField(
                controller: controller.emailController,
                hintText: 'Email',
                icon: Icons.email_outlined,
                prefixWidget: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Image.asset('assets/images/mail.png', height: 30.w, width: 30.w),
                ),
              ),
              SizedBox(height: 16.h),
              Obx(
                () => CommonTextField(
                  controller: controller.passwordController,
                  hintText: 'Password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  obscureText: controller.isPasswordHidden.value,
                  prefixWidget: Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Image.asset('assets/images/lock.png', height: 30.w, width: 30.w),
                  ),
                  onToggleVisibility: controller.togglePasswordVisibility,
                ),
              ),
              SizedBox(height: 24.h),
              CommonButton(text: 'Log In', onPressed: controller.login),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Obx(
                    () => Checkbox(
                      value: controller.rememberMe.value,
                      onChanged: controller.toggleRememberMe,
                      activeColor: AppColors.redD9494E,
                    ),
                  ),
                  const Text("Remember me", style: TextStyle(fontFamily: AppFonts.poppinsSemiBold)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(
                        color: AppColors.redD9494E,
                        fontFamily: AppFonts.poppinsSemiBold,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don’t have an account? ",
                    style: TextStyle(fontFamily: AppFonts.poppinsRegular),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(PhoneNumberScreen(isSignup: true));
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: AppColors.redD9494E,
                        fontFamily: AppFonts.poppinsBold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // controller.emailController.clear();
    super.initState();
  }

  @override
  void dispose() {
    controller.emailController.dispose();
    super.dispose();
  }
}
