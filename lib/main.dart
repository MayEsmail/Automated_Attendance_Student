import 'package:flutter/material.dart';
import 'package:student/Common_Widgets/CustomAppBar.dart';
import 'package:student/login/login.dart';
import 'Attendance/attendance.dart';
import 'Home/Home.dart';
import 'constants.dart';
import 'schedule/schedule.dart';

void main()=>runApp(MyApp());
class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return(MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar('',AppBar().preferredSize),
          body: LoginScreen(),
        ),
    )
    );
  } 
}

