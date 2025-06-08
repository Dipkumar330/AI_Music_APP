import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_logger.dart';

class LoaderComponent extends StatelessWidget {
  const LoaderComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _onWillPop, child: const CircularProgressIndicator());
  }

  Future<bool> _onWillPop() async {
    return false;
  }
}

// showLoader() {
//   Get.to(() => Container(color: Colors.black.withOpacity(0.2), child: Center(child: const LoaderComponent())));
// }

dismissLoader() {
  Get.back();
}

showLoader() {
  Logger().v("Show Loader");

  PageRouteBuilder builder = PageRouteBuilder(
    opaque: false,
    pageBuilder: (con, _, __) {
      return Container(
        color: Colors.black.withOpacity(0.55),
        child: const Center(child: LoaderComponent()),
      );
    },
  );
  Navigator.of(Get.context!).push(builder);
}
