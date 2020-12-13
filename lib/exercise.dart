import 'package:camera/camera.dart';
import 'package:exercise_app/timerscreen.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'inference.dart';

class Exercise extends StatelessWidget {

  final List<CameraDescription> cameras;
  final String title;
  final String model;
  final List<String> exerciseList;
  final String videoId;

  const Exercise({this.cameras, this.title, this.model, this.exerciseList,this.videoId});

  @override
  Widget build(BuildContext context) {

    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: videoId, // id youtube video
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        backgroundColor: Color(0xff31873f),
        title: Text('WorkPlus'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff31873f),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  color: Colors.grey.shade700,
                  child: Column(
                    children: [
                      YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.blueAccent,
                      ),
                      SizedBox(height: 24.0),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.deepOrange.shade300,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 24.0),
                      Text(
                        'Calories burnt  :  400cal/10mins',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Time    :  30mins',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Class  :  Cardio',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          Spacer(),
                          RaisedButton(
                            onPressed: () => _onSelect(context, title),
                            color: Color(0xff31873f),
                            child: Text(
                              "Start Session",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'History',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.deepOrange.shade300,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 24.0),
                      Text(
                        'Calories burnt   :   3767cals',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Time spent       :   476mins',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
                SizedBox(height: 14.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSelect(BuildContext context, String exerciseName) async {

    if(exerciseName == 'Skipping' ||exerciseName == 'Running' || exerciseName == 'Jumping' || exerciseName =='Jogging' || exerciseName == 'Plank'){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TimerScreen(
            cameras: cameras,
            title: exerciseName,
            model: "assets/models/posenet_mv1_075_float_from_checkpoints.tflite",
            customModel: exerciseName,
          ),
        ),
      );
    }
    else{
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InferencePage(
            cameras: cameras,
            title: exerciseName,
            model: "assets/models/posenet_mv1_075_float_from_checkpoints.tflite",
            customModel: exerciseName,
          ),
        ),
      );
    }
  }
}
