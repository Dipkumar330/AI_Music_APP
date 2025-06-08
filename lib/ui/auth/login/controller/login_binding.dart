import 'package:ai_music/ui/auth/login/controller/login_controller.dart';
import 'package:ai_music/ui/auth/signup/controller/signup_controller.dart';
import 'package:get/get.dart';

class LogInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => SignupController(), fenix: true);
  }
}
