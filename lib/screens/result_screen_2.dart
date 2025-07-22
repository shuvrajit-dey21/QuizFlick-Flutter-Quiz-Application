import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app_project/screens/category_screen_2.dart';
import 'package:get/get.dart';
import 'dart:math';
import '/controllers/data_controller.dart';
import '/controllers/result_controller.dart';
import 'package:share_plus/share_plus.dart';

class ResultScreen extends StatelessWidget {
  ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    this.isDailyQuiz = false,
  });

  final int score;
  final int totalQuestions;
  final bool isDailyQuiz;

  @override
  Widget build(BuildContext context) {
    final DataController dataController = Get.find<DataController>();
    Get.put(ResultController(score: score, totalQuestions: totalQuestions));

    // Update user stats when result screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dataController.updateQuizStats(score, totalQuestions, isDailyQuiz: isDailyQuiz);
    });

    int perc = (score / totalQuestions * 100).round();
    String msg = '';
    if (perc >= 80) {
      msg = 'Congratulations!';
    } else if (perc < 80 && perc >= 35) {
      msg = 'Well played';
    } else {
      msg = 'Nice try';
    }

    // Share functionality
    void shareResults() {
      final String shareText = '''
🎯 Quiz Results 🎯

Player: ${dataController.userName.value}
Category: ${dataController.category.value}
Score: $score/$totalQuestions (${perc}%)
$msg

🏆 My Stats:
• Total Score: ${dataController.totalScore.value}
• Games Played: ${dataController.gamesPlayed.value}
• Coins: ${dataController.coins.value}
• Rank: #${dataController.rank.value}

Challenge me in this amazing Quiz App! 🚀
      ''';

      SharePlus.instance.share(
        ShareParams(
          text: shareText,
          subject: 'My Quiz Results',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/result_image.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: GetBuilder<ResultController>(
              builder: (controller) {
                return ConfettiWidget(
                  confettiController: controller.confettiController,
                  blastDirection: -pi / 2,
                  blastDirectionality: BlastDirectionality.explosive,
                  maxBlastForce: 20,
                  minBlastForce: 8,
                  emissionFrequency: 0.2,
                  numberOfParticles: 8,
                  gravity: 0.08,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple,
                  ],
                );
              },
            ),
          ),
          GetBuilder<ResultController>(
            builder: (controller) {
              return AnimatedBuilder(
                animation: controller.animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: controller.animation.value,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '$msg\n${dataController.userName.value}\nYour Score:',
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 250,
                                width: 250,
                                child: CircularProgressIndicator(
                                  strokeWidth: 10,
                                  value: score /
                                      totalQuestions, // Calculate percentage based on total questions
                                  color: Colors.green,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    score.toString(),
                                    style: const TextStyle(
                                      fontSize: 80,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${(score / totalQuestions * 100).round()}%', // Calculate percentage based on total questions
                                    style: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FloatingActionButton(
              onPressed: () => shareResults(),
              backgroundColor: Colors.green,
              child: Icon(Icons.share, color: Colors.white),
            ),
            FloatingActionButton(
              onPressed: () {
                Get.offAll(CategoryScreen());
              },
              backgroundColor: Colors.blue,
              child: Icon(Icons.refresh, color: Colors.white),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
