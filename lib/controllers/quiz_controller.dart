import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/models/question.dart';
import '/controllers/data_controller.dart';

class QuizController extends GetxController {
  var questions = <Question>[].obs;
  var questionIndex = 0.obs;
  var selectedAnswerIndex = Rxn<int>();
  var score = 0.obs;
  // dynamic category;

  // QuizController(
  //     // this.category,
  //     );

  DataController dataController = Get.find<DataController>();

  @override
  void onInit() {
    super.onInit();

    loadQuestions();
  }

  Future<void> loadQuestions() async {
    if (dataController.category.value == 'General Knowledge') {
      String data = await DefaultAssetBundle.of(Get.context!)
          .loadString('assets/questions.json');
      final List<dynamic> jsonResult = json.decode(data);
      questions.value = jsonResult.map((e) => Question.fromJson(e)).toList();
    } else if (dataController.category.value == 'Science') {
      String data = await DefaultAssetBundle.of(Get.context!)
          .loadString('assets/science_questions.json');
      final List<dynamic> jsonResult = json.decode(data);
      questions.value = jsonResult.map((e) => Question.fromJson(e)).toList();
    } else if (dataController.category.value == 'History') {
      String data = await DefaultAssetBundle.of(Get.context!)
          .loadString('assets/history_questions.json');
      final List<dynamic> jsonResult = json.decode(data);
      questions.value = jsonResult.map((e) => Question.fromJson(e)).toList();
    } else if (dataController.category.value == 'Geography') {
      String data = await DefaultAssetBundle.of(Get.context!)
          .loadString('assets/geography_questions.json');
      final List<dynamic> jsonResult = json.decode(data);
      questions.value = jsonResult.map((e) => Question.fromJson(e)).toList();
    } else if (dataController.category.value == 'Computer') {
      String data = await DefaultAssetBundle.of(Get.context!)
          .loadString('assets/computer_questions.json');
      final List<dynamic> jsonResult = json.decode(data);
      questions.value = jsonResult.map((e) => Question.fromJson(e)).toList();
    }

    // Shuffle and pick 10 questions
    questions.shuffle(Random());
    questions.value = questions.take(10).toList();

    questions.forEach(_shuffleOptionsAndCorrectAnswer);
  }

  void pickAnswer(int value) {
    selectedAnswerIndex.value = value;
    final question = questions[questionIndex.value];
    if (selectedAnswerIndex.value == question.correctAnswerIndex) {
      score.value++;
    }
  }

  void goToNextQuestion() {
    if (questionIndex.value < questions.length - 1) {
      questionIndex.value++;
      selectedAnswerIndex.value = null;
    }
  }

  void _shuffleOptionsAndCorrectAnswer(Question question) {
    // final originalOptions = List<String>.from(question.options);
    final originalCorrectAnswer = question.options[question.correctAnswerIndex];
    question.options.shuffle();
    question.correctAnswerIndex =
        question.options.indexOf(originalCorrectAnswer);
  }
}
