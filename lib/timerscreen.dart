import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'chooseExercise.dart';
import 'inference.dart';

class TimerScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final title;
  final model;
  final customModel;

  const TimerScreen({
    this.cameras,
    this.title,
    this.model,
    this.customModel,
  });

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 10),
          () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => InferencePage(
            cameras: widget.cameras,
            title: widget.title,
            model: "assets/models/posenet_mv1_075_float_from_checkpoints.tflite",
            customModel: widget.title,
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
          "Workout starts in 10sec",
          style: TextStyle(
            fontSize: 30.0,
            color: Color(0xff31873f),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
