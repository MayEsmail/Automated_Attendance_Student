import 'package:flutter/material.dart';
import 'package:students/Common_Widgets/CustomAppBar.dart';
import 'package:students/login/login.dart';
import 'Attendance/attendance.dart';
import 'package:students/widgets/home/home.dart';
import 'Common_Widgets/CustomAppBar.dart';
import 'constants.dart';
import 'login/login.dart';
import 'schedule/schedule.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar('', AppBar().preferredSize),
        body: LoginScreen(),
      ),
    ));
  }
}
