// controllers/login_controller.dart
import 'package:ai_music/ui/bottombar/bottombar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helper/network_manager/api_constant.dart';
import '../../../../helper/network_manager/remote_services.dart';
import '../../../../model/response_model.dart';
import '../../../../model/user_model.dart';
import '../../../../utils/app_logger.dart';
import '../../../../utils/snackbar_util.dart';

class LoginController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isPasswordHidden = true.obs;
  var rememberMe = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  Future<void> login() async {
    // Add your login logic
    print("Email: ${emailController.text}");
    print("Password: ${passwordController.text}");
    print("Remember Me: ${rememberMe.value}");

    if (emailController.text.isEmpty) {
      SnackBarUtil.showSnackBar(
        context: Get.context!,
        type: SnackType.error,
        message: "Please Enter Email.",
      );
    } else if (!emailController.text.isEmail) {
      SnackBarUtil.showSnackBar(
        context: Get.context!,
        type: SnackType.error,
        message: "Please Enter Valid Email.",
      );
    } else if (passwordController.text.isEmpty) {
      SnackBarUtil.showSnackBar(
        context: Get.context!,
        type: SnackType.error,
        message: "Please Enter Password.",
      );
    } else if (passwordController.text.length < 6) {
      SnackBarUtil.showSnackBar(
        context: Get.context!,
        type: SnackType.error,
        message: "Please Enter Password at least 6 character.",
      );
    } else {
      bool res = await loginEmailAPiCall();
      if (res) {
        Get.to(BottomBar());
      }
    }
  }

  loginEmailAPiCall() async {
    Map<String, dynamic> param = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    ResponseModel<UserModel> response = await sharedServiceManager.createPostRequest<UserModel>(
      typeOfEndPoint: ApiType.login,
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
}
