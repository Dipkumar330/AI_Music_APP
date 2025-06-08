import 'package:ai_music/ui/quiz/quiz_controller.dart';
import 'package:ai_music/utils/size_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioQuizPage extends StatefulWidget {
  const AudioQuizPage({super.key});

  @override
  State<AudioQuizPage> createState() => _AudioQuizPageState();
}

class _AudioQuizPageState extends State<AudioQuizPage> {
  final controller = Get.put(QuizController());

  @override
  void initState() {
    controller.player = AudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    controller.disposeCall();
    controller.player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFA678F2),
      // appBar: AppBar(
      //   title: const Text(
      //     "AI Music Quiz",
      //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      //   ),
      //   backgroundColor: Color(0xFFA678F2),
      // ),
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
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "AI Music Quiz",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Obx(() {
                final question = controller.questions[controller.currentQuestionIndex.value];

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Question ${controller.currentQuestionIndex.value + 1} of ${controller.questions.length}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value:
                            (controller.currentQuestionIndex.value + 1) /
                            controller.questions.length,
                        backgroundColor: Colors.grey[300],
                        color: Color(0xFF6D4AFF),
                        minHeight: 6,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Play'),
                            onPressed: controller.playAudio,
                          ),
                          const SizedBox(width: 10),
                          Obx(() {
                            return ElevatedButton.icon(
                              icon: Icon(
                                controller.isPlaying.value ? Icons.pause : Icons.play_circle,
                              ),
                              label: Text(controller.isPlaying.value ? 'Pause' : 'Resume'),
                              onPressed:
                                  controller.audioPlayed.value
                                      ? controller.togglePauseResume
                                      : null,
                            );
                          }),
                          const SizedBox(width: 10),
                          Obx(() {
                            return ElevatedButton.icon(
                              icon: const Icon(Icons.replay),
                              label: const Text('Replay'),
                              onPressed: controller.audioPlayed.value ? controller.playAudio : null,
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        question.question,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(question.options.length, (i) {
                        return RadioListTile<int>(
                          title: Text(question.options[i], style: TextStyle(color: Colors.white)),
                          value: i,
                          groupValue: controller.selectedAnswer.value,
                          activeColor: Colors.white,
                          onChanged: (value) {
                            controller.selectAnswer(value!);
                          },
                        );
                      }),
                      const Spacer(),
                      ElevatedButton(
                        onPressed:
                            (controller.selectedAnswer.value != null &&
                                    controller.audioPlayed.value)
                                ? controller.nextQuestion
                                : null,
                        child: Text(
                          controller.currentQuestionIndex.value < controller.questions.length - 1
                              ? 'Next'
                              : 'Finish',
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
