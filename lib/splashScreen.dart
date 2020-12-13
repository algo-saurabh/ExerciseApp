import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'chooseExercise.dart';

class SplashScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const SplashScreen({
    this.cameras,
  });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => ChooseExercise(
            cameras: widget.cameras,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Work Plus",
          style: TextStyle(
            fontSize: 50.0,
            color: Color(0xff31873f),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
