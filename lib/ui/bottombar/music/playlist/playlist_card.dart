import 'package:ai_music/model/music_list_model.dart';
import 'package:ai_music/ui/audio/music/music_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_common/string_const.dart';

class PlaylistCard extends StatelessWidget {
  final bool? shadow;
  final MusicListModel musicListModel;

  const PlaylistCard({super.key, required this.musicListModel, this.shadow = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow:
            shadow == true
                ? [BoxShadow(color: Colors.white30, blurRadius: 6, offset: const Offset(0, 4))]
                : null,
      ),
      child: Row(
        children: [
          // Playlist Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: musicListModel.imageName ?? '',
              height: 50,
              width: 50,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) =>
                      CircularProgressIndicator(strokeWidth: 2, padding: EdgeInsets.all(10)),
              errorWidget: (context, url, error) => Image.network(AppStrings.defaultImage),
            ),
          ),
          const SizedBox(width: 12),

          // Text Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  musicListModel.songName ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  musicListModel.artistName ?? "",
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Play Button
          ElevatedButton.icon(
            onPressed: () {
              Get.to(MusicPlayerScreen(musicListModel: musicListModel));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 0,
            ),
            icon: const Icon(Icons.play_arrow, color: Colors.white),
            label: const Text("Play", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
