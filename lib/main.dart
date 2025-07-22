import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/screens/splash_screen.dart';
import 'controllers/theme_provider.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        // themeMode: ThemeMode.dark,
        // theme: ThemeData.dark().copyWith(),
        themeMode: themeController.themeMode,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: SplashScreen(),
      );
    });
  }
}
