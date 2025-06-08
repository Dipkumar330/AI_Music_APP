import 'package:ai_music/utils/loader_component.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class QuizController extends GetxController {
  var player = AudioPlayer();
  final questions = <QuestionModel>[].obs;
  final currentQuestionIndex = 0.obs;
  final selectedAnswer = RxnInt();
  final score = 0.obs;
  final isPlaying = false.obs;
  final audioPlayed = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadQuestions();
  }

  void loadQuestions() {
    questions.assignAll([
      QuestionModel(
        question: 'Which instrument is playing?',
        options: ['Piano', 'Guitar', 'Violin', 'Flute'],
        correctAnswerIndex: 0,
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      ),
      QuestionModel(
        question: 'Which genre does this music belong to?',
        options: ['Jazz', 'Rock', 'EDM', 'Hip Hop'],
        correctAnswerIndex: 0,
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      ),
      QuestionModel(
        question: 'Identify the mood of this music.',
        options: ['Sad', 'Happy', 'Tense', 'Relaxed'],
        correctAnswerIndex: 3,
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      ),
      QuestionModel(
        question: 'What is the tempo of this music?',
        options: ['Slow', 'Medium', 'Fast', 'Very fast'],
        correctAnswerIndex: 2,
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      ),
      QuestionModel(
        question: 'Which era is this song likely from?',
        options: ['70s', '80s', '90s', '2000s'],
        correctAnswerIndex: 1,
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
      ),
      QuestionModel(
        question: 'What type of vocals are used?',
        options: ['Male', 'Female', 'None', 'Robot'],
        correctAnswerIndex: 0,
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
      ),
      QuestionModel(
        question: 'How many instruments are playing?',
        options: ['One', 'Two', 'Three', 'More than three'],
        correctAnswerIndex: 3,
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
      ),
      QuestionModel(
        question: 'Is this music live or studio recorded?',
        options: ['Live', 'Studio', 'Both', 'Not sure'],
        correctAnswerIndex: 1,
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
      ),
      QuestionModel(
        question: 'Which culture does this music represent?',
        options: ['African', 'Asian', 'Western', 'Middle Eastern'],
        correctAnswerIndex: 2,
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3',
      ),
      QuestionModel(
        question: 'Which instrument leads this piece?',
        options: ['Drums', 'Violin', 'Flute', 'Guitar'],
        correctAnswerIndex: 3,
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3',
      ),
    ]);
  }

  Future<void> playAudio() async {
    try {
      showLoader();
      await player.setUrl(questions[currentQuestionIndex.value].audioUrl);
      isPlaying.value = true;
      audioPlayed.value = true;
      dismissLoader();
      await player.play();

      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          isPlaying.value = false;
        }
      });
    } catch (e) {
      // Get.snackbar('Error', 'Audio failed: $e');
    }
  }

  void togglePauseResume() async {
    if (isPlaying.value) {
      await player.pause();
    } else {
      await player.play();
    }
    isPlaying.toggle();
  }

  void selectAnswer(int index) {
    selectedAnswer.value = index;
  }

  Future<void> nextQuestion() async {
    if (selectedAnswer.value == questions[currentQuestionIndex.value].correctAnswerIndex) {
      score.value++;
    }

    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      selectedAnswer.value = null;
      audioPlayed.value = false;
      isPlaying.value = false;
      await player.stop();
    } else {
      audioPlayed.value = false;
      isPlaying.value = false;
      await player.stop();
      Get.defaultDialog(
        title: "Quiz Complete",
        middleText: "Your score: ${score.value}/${questions.length}",
        onConfirm: () {
          Get.back();
          restartQuiz();
        },
        textConfirm: "Restart",
      );
    }
  }

  void restartQuiz() {
    currentQuestionIndex.value = 0;
    selectedAnswer.value = null;
    score.value = 0;
    audioPlayed.value = false;
    isPlaying.value = false;
  }

  void disposeCall() {
    currentQuestionIndex.value = 0;
    selectedAnswer.value = null;
    score.value = 0;
    audioPlayed.value = false;
    isPlaying.value = false;
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}

class QuestionModel {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String audioUrl;

  QuestionModel({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.audioUrl,
  });
}
