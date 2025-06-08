import 'package:ai_music/model/music_list_model.dart';
import 'package:ai_music/ui/audio/music/music_screen.dart';
import 'package:ai_music/utils/app_common/fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/app_common/string_const.dart';

class MusicCard extends StatelessWidget {
  final MusicListModel musicListModel;

  const MusicCard({super.key, required this.musicListModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(MusicPlayerScreen(musicListModel: musicListModel)),
      child: Padding(
        padding: EdgeInsets.only(right: 20.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            width: 250.w,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey[300],
                    child: CachedNetworkImage(
                      imageUrl: musicListModel.imageName ?? '',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    padding: EdgeInsets.all(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      errorWidget:
                          (context, url, error) =>
                              Image.network(AppStrings.defaultImage, fit: BoxFit.cover),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Music",
                        style: TextStyle(color: Colors.orange, fontFamily: AppFonts.poppinsRegular),
                      ),
                      Text(
                        musicListModel.songName ?? "",
                        style: TextStyle(fontFamily: AppFonts.poppinsBold),
                      ),
                      Row(
                        children: [
                          Text(
                            musicListModel.artistName ?? "",
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          // Text("${course['rating']}"),
                        ],
                      ),
                      // Text("${course['students']} Std"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
