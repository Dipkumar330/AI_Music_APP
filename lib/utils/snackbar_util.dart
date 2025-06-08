import 'package:ai_music/utils/size_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_common/colors_cost.dart';
import 'app_common/fonts.dart';

enum SnackType { success, error, warning, info }

class SnackBarUtil {
  static void showSnackBar({
    required context,
    required SnackType type,
    required String message,
    String? dec,
  }) {
    SnackBar snackBar = SnackBar(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.tr,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.white,
              fontFamily: AppFonts.poppinsSemiBold,
            ),
          ),
          Visibility(
            visible: dec != null || dec?.isNotEmpty == true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.sizeBoxH,
                Text(
                  dec?.tr ?? "",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                    fontFamily: AppFonts.poppinsSemiBold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: getBackgroundColorByType(snackType: type),
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static showGetSnackBar({required SnackType type, required String message, String? dec}) {
    Get.closeAllSnackbars();
    return Get.showSnackbar(
      GetSnackBar(
        message: message,
        snackStyle: SnackStyle.GROUNDED,
        messageText: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.tr,
              style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
                color: Colors.white,
                fontFamily: AppFonts.poppinsSemiBold,
              ),
            ),
            Visibility(
              visible: dec != null || dec?.isNotEmpty == true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.sizeBoxH,
                  Text(
                    dec?.tr ?? "",
                    style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                      fontFamily: AppFonts.poppinsSemiBold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: getBackgroundColorByType(snackType: type),
        duration: const Duration(seconds: 2),
        isDismissible: true,
      ),
    );
  }

  static Color getBackgroundColorByType({required SnackType snackType}) {
    if (snackType == SnackType.success) {
      return Colors.green;
    } else if (snackType == SnackType.warning) {
      return Colors.orangeAccent;
    } else if (snackType == SnackType.error) {
      return Colors.red;
    } else {
      return AppColors.primaryColor;
    }
  }
}
