import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_animations/simple_animations.dart';

import 'welcome_screen_2.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlayAnimationBuilder<double>(
              tween: Tween(begin: 50.0, end: 350.0), // set tween
              duration: const Duration(seconds: 3),
              onCompleted: () {
                Get.off(() => WelcomeScreen());
              }, // set duration
              builder: (context, value, _) {
                return SizedBox(
                    width: value,
                    height: value,
                    // apply animated value from builder function parameter
                    // color: Colors.green,
                    child: Image.asset(
                      'assets/QuizFlick_splash_img.png',
                      width: 20,
                      height: 20,
                    ));
              },
            ),
            // Hero(
            //   tag: 'logoAnimation',
            //   child:  Image.asset(
            //     'assets/Quiz_app_logo.jpg',
            //     width: 20,
            //     height: 20,
            //   )
            //   ,
            // ),
            const SizedBox(height: 45),
            const Text(
              'Enhance Your Knowledge!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cursive',
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
