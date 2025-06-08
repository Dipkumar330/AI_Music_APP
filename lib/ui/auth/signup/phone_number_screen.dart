// phone_login_page.dart
import 'package:ai_music/utils/app_common/colors_cost.dart';
import 'package:ai_music/utils/app_common/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common_component/common_button.dart';
import 'controller/signup_controller.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key, this.isSignup});

  final bool? isSignup;
  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final SignupController controller = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(backgroundColor: AppColors.whiteColor),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Continue with\nPhone Number",
                  style: TextStyle(fontSize: 24, fontFamily: AppFonts.poppinsBold),
                ),
                SizedBox(height: 10),
                Text(
                  "We protect our community by making sure that everyone is real.",
                  style: TextStyle(color: AppColors.greyColor),
                ),
                SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton<CountryCode>(
                              value: controller.selectedCountryCode.value,
                              onChanged: (CountryCode? newValue) {
                                if (newValue != null) {
                                  controller.selectedCountryCode.value = newValue;
                                }
                              },
                              items:
                                  controller.countryCodes.map((country) {
                                    return DropdownMenuItem(
                                      value: country,
                                      child: Text(country.dialCode),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                      ),
                      VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
                      Expanded(
                        child: TextField(
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: controller.checkNumberDigits(
                            controller.selectedCountryCode.value.dialCode,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            hintText: "Phone Number",
                            border: InputBorder.none,
                            counterText: '',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                CommonButton(
                  text: 'Continue',
                  onPressed: () => controller.continueWithPhone(widget.isSignup ?? false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    controller.phoneController.clear();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
