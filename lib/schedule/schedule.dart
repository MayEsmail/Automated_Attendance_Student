
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:student/constants.dart';

class Schedule extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var days=['Saturday','Sunday','Monday','Tuesday','Widnesday','Thrusday','Friday'];
    Size size=MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: (GridView.count(
        crossAxisCount: 2,
        childAspectRatio: ((size.width/2)/255),
        scrollDirection: Axis.vertical,
        children: List.generate(30, (index){
          return Container(
            margin:EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: kPrimaryColor), 
            ),
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
              Center(
                child:Text(days[index%7]+' 12-12-2021',style: TextStyle(fontWeight: FontWeight.w600),)
              ),
              SizedBox(height: 5,),
              Lecture(lectureName: Text(
                'Introduction to programming', 
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),),
              ),
              Lecture(lectureName: Text(
                'C programming Language', 
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),),
              ),
              Lecture(lectureName: Text(
                'Big data analytics platforms using Hadoop', 
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),),
              ),
              ],
            ),
          );
        })
      )),
    );
  }
}

class Lecture extends StatelessWidget {
  final Widget lectureName;
  const Lecture({
    Key? key,
    required this.lectureName,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      margin: EdgeInsets.only(bottom: 10),
      child: lectureName,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: kPrimaryColor),
        boxShadow: [
          BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 3,
        blurRadius: 4,
        offset: Offset(0, 4), // changes position of shadow
      ),
      ],
    ),
    );
  }
}