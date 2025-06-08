import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../helper/network_manager/api_constant.dart';
import '../../../../../helper/network_manager/remote_services.dart';
import '../../../../../model/response_model.dart';
import '../../../../../model/user_model.dart';
import '../../../../../utils/app_logger.dart';
import '../../../../../utils/snackbar_util.dart';

class ProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final mobileController = TextEditingController();
  var selectedDate = DateTime.now().obs;

  void saveChanges() {
    // You can add validation and saving logic here
    print('Name: ${nameController.text}');
    print('Email: ${emailController.text}');
    print('DOB: ${dobController.text}');
    print('Mobile: ${mobileController.text}');
    updateProfileAPiCall();
  }

  getProfileAPiCall() async {
    ResponseModel<UserModel> response = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.getUser,
    );

    if (response.status == ApiConstant.statusCodeSuccess) {
      nameController.text = response.data?.name ?? "";
      emailController.text = response.data?.email ?? "";
      dobController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(DateTime.parse(response.data?.birthDate ?? ""));
      mobileController.text = response.data?.phoneNumber ?? "";
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

  void pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      dobController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  updateProfileAPiCall() async {
    Map<String, dynamic> param = {
      "name": nameController.text,
      "phoneNumber": mobileController.text,
      "countryCode": userModelSingleton.countryCode,
      "birthDate": selectedDate.value.toUtc().toString(),
      "email": emailController.text,
    };

    ResponseModel response = await sharedServiceManager.createPostRequest(
      typeOfEndPoint: ApiType.updateUser,
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

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    dobController.dispose();
    mobileController.dispose();
    super.onClose();
  }
}
