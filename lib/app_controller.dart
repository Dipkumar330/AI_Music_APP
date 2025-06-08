import 'package:ai_music/model/user_model.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  bool isLoggedIn = false;
  String? route;

  void initUserData() async {
    isLoggedIn = await UserModel.isLoginVerified();
    if (isLoggedIn) {
      await userModelSingleton.loadUserDetails();
      // if (userDataSingleton.profileStep == 0) {
      //   route = AppRouteConstant.personalDetailsScreen;
      // } else if (userDataSingleton.profileStep == 1) {
      //   route = AppRouteConstant.vehicleDetailsScreen;
      // } else {
      //   route = AppRouteConstant.myBottomNavigation;
      // }
    }
  }

  @override
  void onInit() async {
    initUserData();
    // await DeviceUtil().updateDeviceInfo();
    super.onInit();
  }
}
