import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_quiz_app_project/screens/category_screen_2.dart';
import 'package:get/get.dart';
// import 'dart:math';
// import '/controllers/data_controller.dart';

class ResultController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late ConfettiController confettiController;
  late AnimationController animationController;
  late Animation<double> animation;

  final int score;
  final int totalQuestions;

  ResultController({required this.score, required this.totalQuestions});

  @override
  void onInit() {
    super.onInit();
    confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    // Animation for scaling up the score display
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOutBack,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      animationController.forward();
      if (score / totalQuestions >= 0.8) {
        confettiController.play();
      }
    });
  }

  @override
  void onClose() {
    confettiController.dispose();
    animationController.dispose();
    super.onClose();
  }
}
