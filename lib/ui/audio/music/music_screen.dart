import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:ai_music/model/music_list_model.dart';
import 'package:ai_music/utils/loader_component.dart';
import 'package:ai_music/utils/size_box_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/app_common/string_const.dart';
import 'music_controller.dart'; // Import your controller

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key, required this.musicListModel});

  final MusicListModel musicListModel;

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> with AfterLayoutMixin {
  final MusicController controller = Get.put(MusicController());

  final scrollController = ScrollController();

  @override
  void initState() {
    AudioPlayerScreen();

    super.initState();
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    showLoader();
    await controller.loadAudioAndLyrics(
      widget.musicListModel.mp3File,
      widget.musicListModel.lrcFile,
    );
    dismissLoader();

    controller.player.durationStream.listen((d) {
      if (d != null) controller.duration.value = d;
    });

    controller.player.positionStream.listen((p) {
      controller.position.value = p;
    });
  }

  // AudioPlayerScreen() {
  //   controller.currentLineIndex.listen((index) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       if (scrollController.hasClients) {
  //         scrollController.animateTo(
  //           index * 40.0,
  //           duration: Duration(milliseconds: 300),
  //           curve: Curves.easeInOut,
  //         );
  //       }
  //     });
  //   });
  // }

  AudioPlayerScreen() {
    controller.currentLineIndex.listen((index) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            index * 40.0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            40.sizeBoxH,
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),

            // Album Artwork
            // const SizedBox(height: 20),
            // const Icon(Icons.music_note, size: 120, color: Colors.white54),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: widget.musicListModel.imageName ?? '',
                height: 200.h,
                width: 200.h,
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
                errorWidget: (context, url, error) => Image.network(AppStrings.defaultImage),
              ),
            ),

            const SizedBox(height: 20),

            // Song Title and Artist
            Text(
              widget.musicListModel.songName ?? "",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(widget.musicListModel.artistName ?? "", style: TextStyle(color: Colors.white70)),

            const SizedBox(height: 50),

            // Expanded(
            //   child: Obx(() {
            //     return ListView.builder(
            //       controller: scrollController,
            //       itemCount: controller.lyrics.length,
            //       itemBuilder: (context, index) {
            //         return Container(
            //           height: 40,
            //           alignment: Alignment.center,
            //           child: Obx(() {
            //             return AnimatedDefaultTextStyle(
            //               duration: Duration(milliseconds: 300),
            //               style: TextStyle(
            //                 fontSize: controller.currentLineIndex.value == index ? 20 : 16,
            //                 color:
            //                     controller.currentLineIndex.value == index
            //                         ? Colors.white
            //                         : Colors.grey,
            //                 fontWeight:
            //                     controller.currentLineIndex.value == index
            //                         ? FontWeight.bold
            //                         : FontWeight.normal,
            //               ),
            //               child: Text(controller.lyrics[index].text),
            //             );
            //           }),
            //         );
            //       },
            //     );
            //   }),
            // ),
            const SizedBox(height: 50),
            Obx(() {
              final line =
                  controller.lyrics.isNotEmpty &&
                          controller.currentLineIndex.value < controller.lyrics.length
                      ? controller.lyrics[controller.currentLineIndex.value].text
                      : '';
              return AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 300),
                style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                child: Text(line, textAlign: TextAlign.center),
              );
            }),
            const Spacer(),

            // Playback Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.shuffle, color: Colors.white, size: 30),
                  const Icon(Icons.skip_previous, color: Colors.white, size: 30),
                  Obx(
                    () => GestureDetector(
                      onTap: controller.togglePlayPause,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFF9B57FF),
                        child: Icon(
                          controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Icon(Icons.skip_next, color: Colors.white, size: 30),
                  const Icon(Icons.repeat, color: Colors.white, size: 30),
                ],
              ),
            ),

            // Time and Slider
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Obx(() {
                      return Slider(
                        min: 0,
                        max:
                            controller.duration.value.inMilliseconds.toDouble() > 0
                                ? controller.duration.value.inMilliseconds.toDouble()
                                : 1,
                        value: controller.position.value.inMilliseconds.toDouble().clamp(
                          0,
                          controller.duration.value.inMilliseconds.toDouble(),
                        ),
                        onChanged: (value) {
                          final newDuration = Duration(milliseconds: value.toInt());
                          controller.player.seek(newDuration);
                        },
                      );
                    }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatTime(controller.position.value.inSeconds.toDouble()),
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          _formatTime(controller.duration.value.inSeconds.toDouble()),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  String _formatTime(double seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toInt().toString().padLeft(2, '0');
    return "$mins:$secs";
  }
}
