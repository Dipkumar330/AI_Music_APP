import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_component/common_button.dart';
import 'controller/signup_controller.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key, required this.isSignup});

  final bool isSignup;

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(leading: BackButton(), elevation: 0, backgroundColor: Colors.transparent),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Verify Your Number",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Obx(
                () => RichText(
                  text: TextSpan(
                    text: 'Enter the code we’ve sent by text to\n',
                    style: TextStyle(color: Colors.grey[600]),
                    children: [
                      TextSpan(
                        text:
                            "${controller.selectedCountryCode.value.dialCode}${controller.phoneController.text}",
                        style: TextStyle(color: Colors.red[400]),
                      ),
                      TextSpan(text: '  '),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Get.back(); // Go back to change phone
                          },
                          child: Text(
                            'Change',
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    child: TextField(
                      controller: controller.otp[index],
                      focusNode: controller.focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          controller.focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          controller.focusNodes[index - 1].requestFocus();
                        }
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              Spacer(),
              CommonButton(
                text: 'Continue',
                onPressed: () => controller.submitOTP(widget.isSignup),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    controller.clearFields();
    super.initState();
  }
}
