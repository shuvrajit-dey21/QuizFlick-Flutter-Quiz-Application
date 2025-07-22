import 'package:flutter/material.dart';
import 'package:flutter_quiz_app_project/controllers/data_controller.dart';
import 'package:flutter_quiz_app_project/screens/category_screen_2.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animationOffset;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animationOffset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Welcome'),
      // ),
      // drawer: SideNav(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff1a2285),
              Color(0xff666ed2),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: 350,
              child: SlideTransition(
                position: _animationOffset,
                child: Card(
                  elevation: 70,
                  color: Colors.white,
                  margin: EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 300,
                          child: Image(
                            image: AssetImage('assets/welcome_img.png'),
                            width: 500,
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(fontSize: 20, color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Hello, Welcome to QuizFlick. ',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  // decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(
                                text: '\nBy continuing, you agree to our ',
                                style: TextStyle(fontSize: 15),
                              ),
                              TextSpan(
                                text: 'privacy policy',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(
                                text: ' and ',
                                style: TextStyle(fontSize: 15),
                              ),
                              TextSpan(
                                text: 'terms and conditions',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: '.'),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            _showNameInputDialog(context);
                          },
                          child: SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: Card(
                              color: Color.fromARGB(255, 0, 255, 8),
                              child: Center(
                                child: Text(
                                  'Get Started',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showNameInputDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Your Name'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: "Name"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Get.put(DataController());
                Get.find<DataController>().initUsername(nameController.text);
                Get.offAll(CategoryScreen());
              },
            ),
          ],
        );
      },
    );
  }
}
