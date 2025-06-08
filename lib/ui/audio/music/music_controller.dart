import 'package:ai_music/utils/snackbar_util.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class LyricLine {
  final Duration time;
  final String text;

  LyricLine({required this.time, required this.text});
}

class MusicController extends GetxController {
  final player = AudioPlayer();
  final isPlaying = false.obs;
  final lyrics = <LyricLine>[].obs;
  final currentLineIndex = 0.obs;

  var isFavorite = false.obs;
  var currentPosition = 0.0.obs;
  var totalDuration = 240.0.obs; // in seconds
  Rx<Duration> duration = Rx<Duration>(Duration.zero);
  Rx<Duration> position = Rx<Duration>(Duration.zero);

  final String audioUrl =
      'https://drive.google.com/uc?export=download&id=19d2AT-JHJq4opivx9WJzOclAEbBhVS5p'; // Replace with your audio file ID

  final String lrcUrl =
      'https://drive.google.com/uc?export=download&id=1Kr_lZxH4rmJSqGNw23F4n7fHL6YKmOR1'; // Replace with your LRC file ID

  void togglePlayPause() {
    isPlaying.value = !isPlaying.value;
    playAudio();
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }

  void updatePosition(double value) {
    currentPosition.value = value;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }

  Future<void> loadAudioAndLyrics(audioUrl, String? lrcUrl) async {
    // Load lyrics
    if (lrcUrl != null && lrcUrl.isNotEmpty) {
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
    }

    // Load audio
    await player.setUrl(audioUrl);

    duration.value = player.duration ?? Duration.zero;

    if (lrcUrl != null) {
      // Sync lyrics
      player.positionStream.listen((pos) => updateCurrentLyric(pos));
    }
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
    if (!isPlaying.value) {
      await player.pause();
      // isPlaying.value = false;
    } else {
      await player.play();
      // isPlaying.value = true;
    }
  }
}
