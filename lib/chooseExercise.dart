import 'package:camera/camera.dart';
import 'package:exercise_app/abs_workout.dart';
import 'package:exercise_app/cardio_workout.dart';
import 'package:exercise_app/legs_workout.dart';
import 'package:flutter/material.dart';

class ChooseExercise extends StatelessWidget {
  final List<CameraDescription> cameras;
  const ChooseExercise({
    this.cameras,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        backgroundColor: Color(0xff31873f),
        title: Text('WorkPlus'),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xff31873f),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
            ),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
            ),
            label: "History",
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 240.0,
              height: 80.0,
              child: RaisedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LegsWorkout(
                        cameras: cameras,
                      ),
                    ),
                  );
                },
                color: Color(0xff31873f),
                child: Text(
                  "Legs Workout",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Container(
              width: 240.0,
              height: 80.0,
              child: RaisedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AbsWorkout(
                        cameras: cameras,
                      ),
                    ),
                  );
                },
                color: Color(0xff31873f),
                child: Text(
                  "Abs Workout",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Container(
              width: 240.0,
              height: 80.0,
              child: RaisedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardioWorkout(
                        cameras: cameras,
                      ),
                    ),
                  );
                },
                color: Color(0xff31873f),
                child: Text(
                  "Cardio Workout",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
