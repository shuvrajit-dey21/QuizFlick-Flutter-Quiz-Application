// timer_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
// import '../screens/result_screen.dart';
import '../screens/result_screen_2.dart';
import 'quiz_controller.dart';
import 'data_controller.dart';

class TimerController extends GetxController {
  var remainingSeconds = 30.obs; // Set the timer duration

  final int totalDuration = 30; // Total duration in seconds

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        _timer?.cancel();
        onTimeUp();
      }
    });
  }

  void resetTimer() {
    _timer?.cancel();
    remainingSeconds.value = 30; // Reset the timer duration
    // startTimer();

    final QuizController quizController = Get.find<QuizController>();

    if (quizController.questionIndex.value <
        quizController.questions.length - 1) {
      startTimer();
    } else if (quizController.questionIndex.value ==
        quizController.questions.length - 1) {
      // startTimer();
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
        } else {
          _timer?.cancel();
          final dataController = Get.find<DataController>();
          Get.to(() => ResultScreen(
                score: quizController.score.value,
                totalQuestions: quizController.questions.length,
                isDailyQuiz: dataController.isCurrentQuizDaily.value,
              ));
        }
      });
    }
  }

  void onTimeUp() {
    // Define the action to take when the timer is up
    final QuizController quizController = Get.find<QuizController>();
    quizController.goToNextQuestion();
    resetTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  double get progress => remainingSeconds.value / totalDuration;

  Color get timerColor =>
      remainingSeconds.value > 10 ? Colors.green : Colors.red;
}
