import 'package:flutter/material.dart';
import 'package:students/Common_Widgets/CustomAppBar.dart';
import 'package:students/login/login.dart';
import 'Common_Widgets/CustomAppBar.dart';
import 'login/login.dart';

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
        appBar: CustomAppBar('', AppBar().preferredSize, false),
        body: LoginScreen(),
      ),
    ));
  }
}
