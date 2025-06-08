import 'package:ai_music/ui/bottombar/bottombar_controller.dart';
import 'package:ai_music/utils/app_common/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'playlist_card.dart';
import 'playlist_controller.dart';

class PlaylistScreen extends StatelessWidget {
  final PlaylistController controller = Get.put(PlaylistController());
  final BottombarController bottombarController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Your Playlists")),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Text(
              "Your Songs",
              style: TextStyle(fontFamily: AppFonts.poppinsBold, color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 10.h),
            Divider(height: 1),
            // SizedBox(height: 30.h),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: bottombarController.musicList.length,
                  itemBuilder: (context, index) {
                    return PlaylistCard(musicListModel: bottombarController.musicList[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
