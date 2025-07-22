import 'package:flutter/material.dart';
import 'package:flutter_quiz_app_project/screens/result_screen_2.dart';
import 'package:flutter_quiz_app_project/widgets/next_button.dart';
import 'package:get/get.dart';
import '/controllers/quiz_controller.dart';
import '/controllers/timer_controller.dart'; // Import the TimerController
import '/widgets/answer_card.dart';

class QuizScreen extends StatelessWidget {
  QuizScreen({super.key, this.isDailyQuiz = false});

  final bool isDailyQuiz;

  @override
  Widget build(BuildContext context) {
    final QuizController quizController = Get.put(QuizController());
    final TimerController timerController = Get.put(TimerController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      body: Obx(() {
        if (quizController.questions.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final question =
            quizController.questions[quizController.questionIndex.value];
        bool isLastQuestion = quizController.questionIndex.value ==
            quizController.questions.length - 1;

        int qNo = quizController.questionIndex.value + 1;

        return Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/quiz_screen.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            // scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            value: timerController.progress,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                timerController.timerColor),
                            backgroundColor: Colors.grey[300],
                          ),
                        ),
                        Text(
                          '${timerController.remainingSeconds.value}s',
                          style: TextStyle(
                            fontSize: 22,
                            color: timerController.timerColor,
                          ),
                        ),
                      ],
                    );
                  }),
                  SizedBox(
                    height: 25,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        child: Expanded(
                          child: Text(
                            '$qNo. ${question.question}',
                            style: const TextStyle(
                              fontSize: 21,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: question.options.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap:
                                    quizController.selectedAnswerIndex.value ==
                                            null
                                        ? () => quizController.pickAnswer(index)
                                        : null,
                                child: AnswerCard(
                                  currentIndex: index,
                                  question: question.options[index],
                                  isSelected: quizController
                                          .selectedAnswerIndex.value ==
                                      index,
                                  selectedAnswerIndex:
                                      quizController.selectedAnswerIndex.value,
                                  correctAnswerIndex:
                                      question.correctAnswerIndex,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      isLastQuestion
                          ? RectangularButton(
                              onPressed: quizController
                                          .selectedAnswerIndex.value !=
                                      null
                                  ? () {
                                      Get.to(() => ResultScreen(
                                            score: quizController.score.value,
                                            totalQuestions:
                                                quizController.questions.length,
                                            isDailyQuiz: isDailyQuiz,
                                          ));
                                    }
                                  : null,
                              label: 'Finish',
                            )
                          : RectangularButton(
                              onPressed:
                                  quizController.selectedAnswerIndex.value !=
                                          null
                                      ? () {
                                          quizController.goToNextQuestion();
                                          timerController
                                              .resetTimer(); // Reset the timer for the next question
                                        }
                                      : null,
                              label: 'Next',
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
