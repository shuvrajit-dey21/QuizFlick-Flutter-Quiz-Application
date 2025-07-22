import 'package:get/get.dart';

class WelcomeController extends GetxController {
  var userName = ''.obs;

  void setName(String name) {
    userName.value = name;
  }
}
