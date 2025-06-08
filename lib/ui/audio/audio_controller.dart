import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

import '../../utils/snackbar_util.dart';

class LyricLine {
  final Duration time;
  final String text;

  LyricLine({required this.time, required this.text});
}

class AudioController extends GetxController {
  final player = AudioPlayer();
  final isPlaying = false.obs;
  final lyrics = <LyricLine>[].obs;
  final currentLineIndex = 0.obs;

  final String audioUrl =
      'https://ai-music-app-v2.s3.ap-southeast-2.amazonaws.com/song_1.mp3'; // Replace with your audio file ID

  final String lrcUrl =
      'https://ai-music-app-v2.s3.ap-southeast-2.amazonaws.com/+a01835d8-e3d1-4dd4-ad1b-144193f7df03.lrc'; // Replace with your LRC file ID

  @override
  void onInit() {
    super.onInit();
    loadAudioAndLyrics();
  }

  Future<void> loadAudioAndLyrics() async {
    // Load lyrics
    final lrcResponse = await http.get(Uri.parse(lrcUrl));
    if (lrcResponse.statusCode == 200) {
      parseLrc(lrcResponse.body);
    } else {
      SnackBarUtil.showSnackBar(
        context: Get.context!,
        type: SnackType.error,
        message: 'Failed to load lyrics',
      );
    }

    // Load audio
    await player.setUrl(audioUrl);

    // Sync lyrics
    player.positionStream.listen((pos) => updateCurrentLyric(pos));
  }

  void parseLrc(String content) {
    final lines = content.split('\n');
    final parsed = <LyricLine>[];

    for (var line in lines) {
      final regex = RegExp(r'\[(\d{2}):(\d{2})\.(\d{2,3})\](.*)');
      final match = regex.firstMatch(line);
      if (match != null) {
        final minutes = int.parse(match.group(1)!);
        final seconds = int.parse(match.group(2)!);
        final millis = int.parse(match.group(3)!.padRight(3, '0'));
        final text = match.group(4)!.trim();
        final time = Duration(minutes: minutes, seconds: seconds, milliseconds: millis);
        parsed.add(LyricLine(time: time, text: text));
      }
    }

    parsed.sort((a, b) => a.time.compareTo(b.time));
    lyrics.assignAll(parsed);
  }

  void updateCurrentLyric(Duration position) {
    for (int i = 0; i < lyrics.length; i++) {
      if (i + 1 < lyrics.length && position >= lyrics[i].time && position < lyrics[i + 1].time) {
        currentLineIndex.value = i;
        return;
      }
    }
    if (lyrics.isNotEmpty && position >= lyrics.last.time) {
      currentLineIndex.value = lyrics.length - 1;
    }
  }

  Future<void> playAudio() async {
    if (isPlaying.value) {
      await player.pause();
      isPlaying.value = false;
    } else {
      await player.play();
      isPlaying.value = true;
    }
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
