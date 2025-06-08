import 'package:ai_music/model/user_model.dart';
import 'package:ai_music/ui/auth/signup/birthdate_screen.dart';
import 'package:ai_music/ui/auth/signup/email_screen.dart';
import 'package:ai_music/ui/auth/signup/name_screen.dart';
import 'package:ai_music/ui/auth/signup/otp_verification_screen.dart';
import 'package:ai_music/ui/auth/signup/password_screen.dart';
import 'package:ai_music/ui/bottombar/bottombar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../helper/network_manager/api_constant.dart';
import '../../../../helper/network_manager/remote_services.dart';
import '../../../../model/response_model.dart';
import '../../../../utils/app_logger.dart';
import '../../../../utils/snackbar_util.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();

  final birthdateController = TextEditingController();
  var selectedDate = DateTime.now().obs;

  final emailController = TextEditingController();
  final isValidEmail = false.obs;

  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final isValidPassword = false.obs;

  final phoneController = TextEditingController();
  final selectedCountryCode = CountryCode(name: "Australia", code: "AU", dialCode: "+61").obs;

  final countryCodes = <CountryCode>[
    CountryCode(name: "Australia", code: "AU", dialCode: "+61"),
    CountryCode(name: "United States", code: "US", dialCode: "+1"),
    CountryCode(name: "India", code: "IN", dialCode: "+91"),
    CountryCode(name: "United Kingdom", code: "GB", dialCode: "+44"),
  ];

  var verificationId = ''.obs;
  var isPhoneVerified = false.obs;

  final otp = List
      .generate(6, (_) => TextEditingController())
      .obs;
  final focusNodes = List.generate(6, (_) => FocusNode());

  Future<void> submitOTP(bool isSignup) async {
    final code = otp.map((c) => c.text).join();
    if (code.length < 6) {
      SnackBarUtil.showSnackBar(
        context: Get.context!,
        type: SnackType.error,
        message: 'Please enter the complete 6-digit code',
      );
    } else {
      bool res = await verifyOtpAPiCall(code, isSignup);
      if (res) {
        if (isSignup) {
          Get.to(NameScreen());
        } else {
          Get.offAll(BottomBar());
        }
      }
    }
  }

  void clearFields() {
    for (var controller in otp) {
      controller.clear();
    }
    focusNodes[0].requestFocus();
  }

  @override
  void onInit() {
    super.onInit();
    birthdateController.text = DateFormat('dd/MM/yyyy').format(selectedDate.value);
  }

  void submitName() {
    if (nameController.text.isEmpty) {
      SnackBarUtil.showSnackBar(
        context: Get.context!,
        type: SnackType.error,
        message: 'Please enter your name.',
      );
    } else {
      Get.to(BirthdatePage());
    }
  }

  void pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      birthdateController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  void submitBirthdate() {
    if (birthdateController.text.trim().isEmpty) {
      SnackBarUtil.showSnackBar(
        context: Get.context!,
        type: SnackType.error,
        message: 'Please select birthday',
      );
    } else {
      Get.to(EmailScreen());
    }

    // Navigate to next screen if needed
  }

  void validateEmail() {
    final email = emailController.text;
    isValidEmail.value = GetUtils.isEmail(email);
  }

  void submitEmail() {
    validateEmail();
    if (isValidEmail.value) {
      Get.to(PasswordPage());
    } else {
      SnackBarUtil.showSnackBar(
        context: Get.context!,
        type: SnackType.error,
        message: "Please enter a valid email",
      );
    }
  }

  void toggleVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> submitPassword() async {
    if (passwordController.text.length >= 6) {
      bool res = await signupAPiCall();
      if (res) {
        Get.to(BottomBar());
      }
    } else {
      SnackBarUtil.showSnackBar(
        context: Get.context!,
        type: SnackType.error,
        message: "Password must be at least 6 characters",
      );
    }
  }

  signupAPiCall() async {
    Map<String, dynamic> param = {
      "name": nameController.text,
      "phoneNumber": phoneController.text,
      "countryCode": selectedCountryCode.value.dialCode,
      "birthDate": selectedDate.value.toUtc().toString(),
      "email": emailController.text,
      "password": passwordController.text,
    };

    ResponseModel<UserModel> response = await sharedServiceManager.createPostRequest(
      typeOfEndPoint: ApiType.signUp,
      params: param,
    );

    if (response.status == ApiConstant.statusCodeSuccess) {
      await UserModel.saveIsLoginVerified();

      return true;
    } else {
      SnackBarUtil.showSnackBar(
        type: SnackType.error,
        message: response.message ?? "",
        context: Get.context!,
      );
      Logger().e(response.message);
      return false;
    }
  }

  checkNumberDigits(String code) {
    switch (code) {
      case '+91':
        return 10;
      case '+61':
        return 9;
      case '+1':
        return 10;
      case '+44':
        return 10;
    }
  }

  Future<void> continueWithPhone(bool isSignup) async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      SnackBarUtil.showSnackBar(
        context: Get.context!,
        type: SnackType.error,
        message: "Phone number cannot be empty",
      );
    } else if (phone.length < checkNumberDigits(selectedCountryCode.value.dialCode)) {
      SnackBarUtil.showSnackBar(
        context: Get.context!,
        type: SnackType.error,
        message: "Enter valid number.",
      );
    } else {
      bool res = isSignup ? await sendOtpAPiCall() : await loginPhoneAPiCall();
      if (res) {
        Get.to(OTPVerificationScreen(isSignup: isSignup));
      }
    }
  }

  loginPhoneAPiCall() async {
    Map<String, dynamic> param = {
      "phoneNumber": phoneController.text,
      "contryCode": selectedCountryCode.value.dialCode,
    };

    ResponseModel<UserModel> response = await sharedServiceManager.createPostRequest<UserModel>(
      typeOfEndPoint: ApiType.login,
      params: param,
    );

    if (response.status == ApiConstant.statusCodeSuccess) {
      return true;
    } else {
      SnackBarUtil.showSnackBar(
        type: SnackType.error,
        message: response.message ?? "",
        context: Get.context!,
      );
      Logger().e(response.message);
      return false;
    }
  }

  sendOtpAPiCall() async {
    Map<String, dynamic> param = {
      "phoneNumber": phoneController.text,
      "countryCode": selectedCountryCode.value.dialCode,
    };

    ResponseModel<UserModel> response = await sharedServiceManager.createPostRequest<UserModel>(
      typeOfEndPoint: ApiType.sendOTP,
      params: param,
    );

    if (response.status == ApiConstant.statusCodeSuccess) {
      return true;
    } else {
      SnackBarUtil.showSnackBar(
        type: SnackType.error,
        message: response.message ?? "",
        context: Get.context!,
      );
      Logger().e(response.message);
      return false;
    }
  }

  verifyOtpAPiCall(String otp, isSignUp) async {
    Map<String, dynamic> param = {
      "phoneNumber": phoneController.text,
      "countryCode": selectedCountryCode.value.dialCode,
      "otp": otp,
      "isSignUp": !isSignUp,
    };

    ResponseModel<UserModel> response = await sharedServiceManager.createPostRequest<UserModel>(
      typeOfEndPoint: ApiType.verifyOtp,
      params: param,
    );

    if (response.status == ApiConstant.statusCodeSuccess) {
      await UserModel.saveIsLoginVerified();
      await userModelSingleton.loadUserDetails();
      return true;
    } else {
      SnackBarUtil.showSnackBar(
        type: SnackType.error,
        message: response.message ?? "",
        context: Get.context!,
      );
      Logger().e(response.message);
      return false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    birthdateController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    for (var controller in otp) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}

class CountryCode {
  final String name;
  final String code;
  final String dialCode;

  CountryCode({required this.name, required this.code, required this.dialCode});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CountryCode &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              code == other.code &&
              dialCode == other.dialCode;

  @override
  int get hashCode => name.hashCode ^ code.hashCode ^ dialCode.hashCode;

  @override
  String toString() => '$dialCode'; // Helpful for debugging
}
