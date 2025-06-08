import 'package:ai_music/ui/auth/welcome_screen.dart';
import 'package:ai_music/ui/bottombar/bottombar.dart';
import 'package:ai_music/ui/on_boarding/on_boarding_screen.dart';
import 'package:ai_music/utils/app_common/route_const.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRoute {
  static List<GetPage> routes = [
    GetPage(
      name: AppRouteConstant.onBoardingScreen,
      page: () => OnboardingScreen(),
      // bindings: [
      //   MyBottomNavigationBinding(),
      //   HomePageFragmentBinding(),
      //   BookingPageFragmentBinding(),
      // ],
    ),
    GetPage(name: AppRouteConstant.welcomeScreen, page: () => const WelcomeScreen()),

    GetPage(name: AppRouteConstant.myBottomNavigation, page: () => BottomBar()),
  ];
}
