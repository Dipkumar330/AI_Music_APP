import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'audio_controller.dart';

class AudioPlayerScreen extends StatelessWidget {
  final controller = Get.put(AudioController());
  final scrollController = ScrollController();

  AudioPlayerScreen({super.key}) {
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
      appBar: AppBar(title: Text('Music Player with Lyrics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            children: [
              ElevatedButton(
                onPressed: controller.playAudio,
                child: Text(controller.isPlaying.value ? 'Pause' : 'Play'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: controller.lyrics.length,
                  itemBuilder: (context, index) {
                    final isCurrent = index == controller.currentLineIndex.value;
                    return Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: AnimatedDefaultTextStyle(
                        duration: Duration(milliseconds: 300),
                        style: TextStyle(
                          fontSize: isCurrent ? 20 : 16,
                          color: isCurrent ? Colors.blueAccent : Colors.grey[700],
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        ),
                        child: Text(controller.lyrics[index].text),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                final line =
                    controller.lyrics.isNotEmpty &&
                            controller.currentLineIndex.value < controller.lyrics.length
                        ? controller.lyrics[controller.currentLineIndex.value].text
                        : '';
                return AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Text(line, textAlign: TextAlign.center),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
