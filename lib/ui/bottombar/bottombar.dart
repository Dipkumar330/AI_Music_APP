// views/main_screen.dart
import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:ai_music/ui/bottombar/bottombar_controller.dart';
import 'package:ai_music/ui/bottombar/home/home_screen.dart';
import 'package:ai_music/ui/bottombar/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'music/playlist/playlist_screen.dart';

class BottomBar extends StatefulWidget {
  BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with AfterLayoutMixin {
  final BottombarController controller = Get.find();

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    controller.selectedIndex.value = 0;
    await controller.getMusicAPiCall();
    await controller.getArtistAPiCall();
  }

  final List<Widget> pages = [HomeScreen(), PlaylistScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF9B57FF), // top-left
                Color(0xFF6D4AFF), // bottom-right
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Expanded(child: pages[controller.selectedIndex.value]),
              BottomNavigationBar(
                currentIndex: controller.selectedIndex.value,
                onTap: controller.changeTab,
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                selectedItemColor: Colors.deepPurple,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: false,
                showSelectedLabels: false,
                items: [
                  BottomNavigationBarItem(
                    icon: image("assets/images/home.png"),
                    activeIcon: image("assets/images/home_selected.png"),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: image("assets/images/music.png"),
                    activeIcon: image("assets/images/music_selected.png"),
                    label: 'Music',
                  ),
                  BottomNavigationBarItem(
                    icon: image("assets/images/user.png"),
                    activeIcon: image("assets/images/user_selected.png"),
                    label: 'Profile',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  image(image) {
    return Image.asset(image, height: 30.w, color: Colors.white);
  }
}
