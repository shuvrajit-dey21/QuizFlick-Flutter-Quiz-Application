import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var _themeMode = ThemeMode.light.obs;

  ThemeMode get themeMode => _themeMode.value;

  void toggleTheme() {
    if (_themeMode.value == ThemeMode.light) {
      _themeMode.value = ThemeMode.dark;
    } else {
      _themeMode.value = ThemeMode.light;
    }
  }
}
