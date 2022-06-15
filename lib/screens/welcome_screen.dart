// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sized_box_for_whitespace, unused_local_variable, avoid_print, deprecated_member_use, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, missing_required_param

import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = "welcome_screen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 2,
      ),
    );
    animation = ColorTween(begin: Colors.black, end: Colors.cyan[900])
        .animate(controller);
    controller.forward();
    animation.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          controller.reverse(from: 1.0);
        } else if (status == AnimationStatus.dismissed) {
          controller.forward(from: 0.0);
        }
      },
    );
    controller.addListener(
      () {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: "logo",
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                AnimatedTextKit(
                  pause: Duration(
                    seconds: 1,
                  ),
                  repeatForever: true,
                  animatedTexts: [
                    FlickerAnimatedText(
                      "Flash Chat",
                      textStyle: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            Shadow(
                              blurRadius: 15.0,
                              color: Colors.white,
                              offset: Offset(
                                0,
                                0,
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: "Log In",
              colour: Colors.lightBlueAccent,
              onPress: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              title: "Register",
              colour: Colors.blueAccent,
              onPress: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
