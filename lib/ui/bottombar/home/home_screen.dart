import 'dart:async';
import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:ai_music/ui/bottombar/bottombar_controller.dart';
import 'package:ai_music/ui/bottombar/home/widgets/artist_card.dart';
import 'package:ai_music/ui/bottombar/home/widgets/music_card.dart';
import 'package:ai_music/ui/bottombar/music/ai_screen.dart';
import 'package:ai_music/utils/app_common/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../quiz/quiz_screen.dart';
import 'controller/home_controller.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AfterLayoutMixin {
  final controller = Get.put(HomeController());
  final BottombarController bottombarController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16), // Search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(AiScreen());
                        },
                        child: const TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: "Search for..",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    // const Icon(Icons.tune, color: Colors.blue),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Special Offer Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  image: DecorationImage(
                    image: AssetImage("assets/images/offer.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("25% OFF*", style: TextStyle(fontFamily: AppFonts.poppinsBold)),
                    SizedBox(height: 6),
                    Text(
                      "Today’s Special",
                      style: TextStyle(fontSize: 22, fontFamily: AppFonts.poppinsBold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Get a Discount for Every\nCourse Order only Valid for\nToday.!",
                      style: TextStyle(fontSize: 14, fontFamily: AppFonts.poppinsBold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Musics",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => bottombarController.selectedIndex.value = 1,
                    child: Text(
                      "See All",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // Horizontal Course Cards
              SizedBox(
                height: 240.h,
                child: Obx(() {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: min(bottombarController.musicList.length, 4),
                    itemBuilder: (context, index) {
                      return MusicCard(musicListModel: bottombarController.musicList[index]);
                    },
                  );
                }),
              ),

              const SizedBox(height: 20),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎵 AI Music Quiz',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Think you know music? Try our quiz and let AI challenge your skills!',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AudioQuizPage()),
                          );
                        },
                        icon: Icon(Icons.play_arrow, color: Colors.white),
                        label: Text(
                          'Start Quiz',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // Top Mentors
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Top Artist",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Row(children: [Text("SEE ALL", style: TextStyle(color: Colors.white)), Icon(Icons.arrow_right, color: Colors.white)]),
                ],
              ),
              const SizedBox(height: 12),

              // Horizontal Mentor Cards
              SizedBox(
                height: 160.h,
                child: Obx(
                  () => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: bottombarController.artistList.length,
                    itemBuilder: (context, index) {
                      return ArtistCard(artistListModel: bottombarController.artistList[index]);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
