import 'package:ai_music/ui/bottombar/bottom_bar_bindings.dart';
import 'package:ai_music/ui/bottombar/bottombar.dart';
import 'package:ai_music/ui/on_boarding/on_boarding_screen.dart';
import 'package:ai_music/utils/app_common/app_route.dart';
import 'package:ai_music/utils/app_common/colors_cost.dart';
import 'package:ai_music/utils/app_common/string_const.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // if (Platform.isAndroid) {
  //   var androidInfo = await DeviceInfoPlugin().androidInfo;
  //   if (androidInfo.version.sdkInt >= 32) {
  //     FirebaseMessaging messaging = FirebaseMessaging.instance;
  //     await messaging.requestPermission(badge: true, announcement: true, sound: true, alert: true);
  //   }
  // }
  Get.put<AppController>(AppController());

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) async {
    runApp(const AiMusic());
  });
}

class AiMusic extends StatelessWidget {
  const AiMusic({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(432, 960),
      minTextAdapt: false,
      splitScreenMode: false,
      builder: (BuildContext context, Widget? child) {
        return GetBuilder<AppController>(
          builder: (controller) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: AppStrings.appName,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child ?? Container(),
                );
              },
              theme: ThemeData(
                scaffoldBackgroundColor: AppColors.whiteColor,
                useMaterial3: true,
                primarySwatch: Colors.blue,
                appBarTheme: const AppBarTheme(
                  centerTitle: true,
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark,
                  ),
                ),
                navigationBarTheme: const NavigationBarThemeData(
                  elevation: 0,
                  indicatorColor: AppColors.primaryColor,
                  backgroundColor: AppColors.whiteColor,
                ),
              ),
              getPages: AppRoute.routes,
              // home: AudioQuizPage(),
              home: controller.isLoggedIn ? BottomBar() : OnboardingScreen(),
              initialBinding: BottomBarBinding(),
              // initialRoute: controller.isLoggedIn ? AppRouteConstant.myBottomNavigation : AppRouteConstant.logInScreen,
              // home: const MyBottomNavigation(),
              // initialBinding: MyBottomNavigationBinding(),
            );
          },
        );
      },
    );
  }
}
