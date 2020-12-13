import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'exercise_data.dart';

class BndBox extends StatefulWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final String customModel;
  final String title;

  BndBox({
    this.results,
    this.previewH,
    this.previewW,
    this.screenH,
    this.screenW,
    this.customModel,
    this.title,
  });

  @override
  _BndBoxState createState() => _BndBoxState();
}

class _BndBoxState extends State<BndBox> {
  Map<String, List<double>> inputArr;
  int _counter;
  FlutterTts flutterTts;
  double per;
  double lowerRange, upperRange;
  bool midCount, isCorrectPosture;
  Timer _timer;
  int _start=60;

  void setRangeBasedOnModel() {
    if (widget.customModel == exerciseList[0]) {
      upperRange = 300;
      lowerRange = 500;
    } else if (widget.customModel == exerciseList[1]) {
      upperRange = 500;
      lowerRange = 700;
    }
    else if(widget.customModel == exerciseList[4]){
      upperRange = 100;
      lowerRange = 5;
    }
    else if(widget.customModel == exerciseList[2]) {
      upperRange = 40;
      lowerRange = 0;
    }
  }

  @override
  void initState() {
    super.initState();
    inputArr = new Map();
    _counter = 0;
    per = 0.0;
    startTimer();
    midCount = false;
    isCorrectPosture = false;
    setRangeBasedOnModel();
    flutterTts = new FlutterTts();
    flutterTts.speak("Your Workout Has Started");
  }

  void resetCounter() {
    setState(() {
      _counter = 0;
      per = 0.0;
    });
    flutterTts.speak("Your Workout has been Reset");
  }

  void incrementCounter() {
    setState(() {
      _counter++;
    });
    flutterTts.speak(_counter.toString());
  }

  void setMidCount(bool f) {
    //when midcount is activated
    if (f && !midCount) {
      flutterTts.speak("Perfect!");
    }
    setState(() {
      midCount = f;
    });
  }

  Color getCounterColor() {
    if (isCorrectPosture) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  Positioned _createPositionedBlobs(double x, double y) {
    return Positioned(
      height: 5,
      width: 40,
      left: x,
      top: y,
      child: Container(
        color: getCounterColor(),
      ),
    );
  }

  List<Widget> _renderHelperBlobs() {
    List<Widget> listToReturn = <Widget>[];
    listToReturn.add(_createPositionedBlobs(0, upperRange));
    listToReturn.add(_createPositionedBlobs(0, lowerRange));
    return listToReturn;
  }

  //region Core
  bool _postureAccordingToExercise(Map<String, List<double>> poses) {
    if (widget.customModel == exerciseList[1]) {
      return poses['leftShoulder'][1] < upperRange &&
          poses['rightShoulder'][1] < upperRange;
    }
    if (widget.customModel == exerciseList[0]) {
      return poses['leftShoulder'][1] < upperRange &&
          poses['rightShoulder'][1] < upperRange &&
          poses['rightKnee'][1] > lowerRange &&
          poses['leftKnee'][1] > lowerRange;
    }
    if (widget.customModel == exerciseList[4]) {
      double diffLeft = poses['leftWrist'][1] - poses['leftAnkle'][1];
      double diffRight = poses['rightWrist'][1] - poses['rightAnkle'][1];
      if((diffLeft<=upperRange && diffLeft>=lowerRange) || (diffRight<=upperRange && diffRight>=lowerRange)){
        return true;
      }
      else{
        return false;
      }
    }

    if (widget.customModel == exerciseList[2]) {
      double diff = poses['leftShoulder'][1] - poses['rightShoulder'][1];
      if(diff>=lowerRange && diff<=upperRange){
        return true;
      }
      else{
        return false;
      }
    }
  }

  _checkCorrectPosture(Map<String, List<double>> poses) {
    if (_postureAccordingToExercise(poses)) {
      if (!isCorrectPosture) {
        setState(() {
          isCorrectPosture = true;
        });
      }
    } else {
      if (isCorrectPosture) {
        setState(() {
          isCorrectPosture = false;
        });
      }
    }
  }

  Future<void> _countingLogic(Map<String, List<double>> poses) async {
    if (poses != null) {
      //check posture before beginning count
      if ((widget.title == exerciseList[0] || widget.title==exerciseList[1]) && isCorrectPosture &&
          poses['leftShoulder'][1] > upperRange &&
          poses['rightShoulder'][1] > upperRange) {
        setMidCount(true);
      }

      if(widget.title == exerciseList[4] && isCorrectPosture){
        setMidCount(true);
      }

      if ((widget.title == exerciseList[0] || widget.title==exerciseList[1]) && midCount &&
          poses['leftShoulder'][1] < upperRange &&
          poses['rightShoulder'][1] < upperRange) {
        incrementCounter();
        setMidCount(false);
      }

      if (widget.title == exerciseList[4]&& midCount ) {
        incrementCounter();
        setMidCount(false);
      }

      //check the posture when not in midcount
      if (!midCount) {
        _checkCorrectPosture(poses);
      }
    }
  }

  void startTimer() {

    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  //endregion

  @override
  Widget build(BuildContext context) {
    List<Widget> _renderKeypoints() {
      var lists = <Widget>[];
      widget.results.forEach((re) {
        var list = re["keypoints"].values.map<Widget>((k) {
          var _x = k["x"];
          var _y = k["y"];
          var scaleW, scaleH, x, y;

          if (widget.screenH / widget.screenW >
              widget.previewH / widget.previewW) {
            scaleW = widget.screenH / widget.previewH * widget.previewW;
            scaleH = widget.screenH;
            var difW = (scaleW - widget.screenW) / scaleW;
            x = (_x - difW / 2) * scaleW;
            y = _y * scaleH;
          } else {
            scaleH = widget.screenW / widget.previewW * widget.previewH;
            scaleW = widget.screenW;
            var difH = (scaleH - widget.screenH) / scaleH;
            x = _x * scaleW;
            y = (_y - difH / 2) * scaleH;
          }

          inputArr[k['part']] = [x, y];

          // To solve mirror problem on front camera
          if (x > 320) {
            var temp = x - 320;
            x = 320 - temp;
          } else {
            var temp = 320 - x;
            x = 320 + temp;
          }
          //print("${x},${y}");
          return Positioned(
            left: x - 275,
            top: y - 50,
            width: 100,
            height: 15,
            child: Container(
              child: Text(
                //"(${(x - 275).toStringAsFixed(0)},${(y - 50).toStringAsFixed(0)})",
                "● ${k['part']}",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12.0,
                ),
              ),
            ),
          );
        }).toList();

        _countingLogic(inputArr);
        per = widget.results[0]['score'];
        if((per * 100) > 90.0){
          flutterTts.speak("Doing Good");
        }

        inputArr.clear();
        lists..addAll(list);
      });
      return lists;
    }

    return Stack(children: <Widget>[
      Stack(
        children: _renderHelperBlobs(),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          (widget.title == 'Skipping' || widget.title == 'Running' || widget.title == 'Jumping' || widget.title =='Jogging' || widget.title == 'Plank')
              ? Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Container(
                      height: 100,
                      width: 100,
                      child: FittedBox(
                        child: FloatingActionButton(
                          backgroundColor: Colors.green,
                          onPressed: (){},
                          child: Text(
                            '${_start.toString()}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Container(
                      height: 100,
                      width: 100,
                      child: FittedBox(
                        child: FloatingActionButton(
                          backgroundColor: getCounterColor(),
                          onPressed: resetCounter,
                          child: Text(
                            '${_counter.toString()}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          Padding(
            padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 25.0),
            child: Text(
              "Accuracy: ${(per * 100).toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      Stack(
        children: _renderKeypoints(),
      ),
    ]);
  }
}
