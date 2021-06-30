import 'package:flutter/material.dart';
import 'Lecture.dart';
import '../constants.dart';

class Schedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var days = [
      'Saturday',
      'Sunday',
      'Monday',
      'Tuesday',
      'Widnesday',
      'Thrusday',
      'Friday'
    ];
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: (GridView.count(
          crossAxisCount: 2,
          childAspectRatio: ((size.width / 2) / 255),
          scrollDirection: Axis.vertical,
          children: List.generate(30, (index) {
            return Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: kPrimaryColor),
              ),
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  Center(
                      child: Text(
                    days[index % 7] + ' 12-12-2021',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )),
                  SizedBox(
                    height: 5,
                  ),
                  Lecture(
                    lectureName: Text(
                      'Introduction to programming',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Lecture(
                    lectureName: Text(
                      'C programming Language',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Lecture(
                    lectureName: Text(
                      'Big data analytics platforms using Hadoop',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }))),
    );
  }
}
