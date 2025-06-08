import 'package:ai_music/model/music_list_model.dart';
import 'package:ai_music/ui/bottombar/music/playlist/playlist_card.dart';
import 'package:ai_music/ui/common_component/common_textfield.dart';
import 'package:ai_music/utils/app_common/colors_cost.dart';
import 'package:ai_music/utils/app_common/fonts.dart';
import 'package:ai_music/utils/app_common/string_const.dart';
import 'package:ai_music/utils/size_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ai_controller.dart';

class AiScreen extends StatelessWidget {
  final AiController controller = Get.put(AiController());

  AiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppBar(
          leading: BackButton(color: AppColors.whiteColor),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "AI Music",
            style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: AppFonts.poppinsBold),
          ),
        ),
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 20),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Obx(() {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            // padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                10.sizeBoxH,
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      controller.data[index].keys.first,
                                      style: TextStyle(
                                        fontFamily: AppFonts.poppinsSemiBold,
                                        color: AppColors.whiteColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: PlaylistCard(
                                    shadow: false,
                                    musicListModel: MusicListModel(
                                      songName: controller.data[index].values.last?.song ?? "",
                                      imageName: AppStrings.defaultImage,
                                      mp3File: controller.data[index].values.first?.mp3,
                                      artistName: controller.data[index].values.first?.artist,
                                    ),
                                  ),
                                ),
                                10.sizeBoxH,
                                Container(width: 100, color: AppColors.whiteColor, height: 1),
                              ],
                            ),
                          );
                        },
                        itemCount: controller.data.length,
                      );
                    }),
                  ),
                ),

                30.sizeBoxH,

                // Prompt Cards
                SizedBox(
                  height: 70,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.prompts.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final prompt = controller.prompts[index];
                      return GestureDetector(
                        onTap: () => controller.setPrompt(prompt['title']!),
                        child: Container(
                          // width: 160,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prompt['title']!,
                                style: const TextStyle(fontFamily: AppFonts.poppinsBold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                prompt['subtitle']!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: AppFonts.poppinsRegular,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Input Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CommonTextField(
                          controller: controller.searchMusicTextController,
                          hintText: "Tell AI to design a playlist.",
                          textInputAction: TextInputAction.search,
                          onSubmit: (v) async {
                            await controller.musicGenerateAPiCall(
                              controller.searchMusicTextController.text,
                            );
                          },
                        ),

                        // Container(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        //   decoration: BoxDecoration(
                        //     border: Border.all(color: Colors.white),
                        //     borderRadius: BorderRadius.circular(32),
                        //   ),
                        //   child:
                        //
                        //   const Text(
                        //     "Tell AI to design a playlist.",
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //       fontFamily: AppFonts.poppinsRegular,
                        //     ),
                        //   ),
                        // ),
                      ),
                      const SizedBox(width: 10),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () async {
                            if (controller.searchMusicTextController.text.isNotEmpty) {
                              await controller.musicGenerateAPiCall(
                                controller.searchMusicTextController.text,
                              );
                            }
                          },
                          icon: Icon(Icons.search, color: Colors.deepPurple),
                        ),
                      ),
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
