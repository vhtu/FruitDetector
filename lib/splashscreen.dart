import 'package:catanddog/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: Home(),
      title: Text(
        'iFruit',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30.0,
          color: Colors.white,
        ),
      ),
      image: Image.asset(
        'assets/fruits.png',
      ),
      backgroundColor: Colors.black,
      photoSize: 50.0,
      loaderColor: Color(0xFFEEDA28),
    );
  }
}
