import 'package:ai_music/ui/auth/login/controller/login_controller.dart';
import 'package:ai_music/ui/auth/signup/controller/signup_controller.dart';
import 'package:ai_music/ui/bottombar/bottombar_controller.dart';
import 'package:get/get.dart';

class BottomBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BottombarController(), fenix: true);
    Get.lazyPut(() => SignupController(), fenix: true);
    Get.lazyPut(() => LoginController(), fenix: true);
  }
}
