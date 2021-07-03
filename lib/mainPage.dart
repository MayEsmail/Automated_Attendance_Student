import 'package:flutter/material.dart';
import 'package:students/Common_Widgets/CustomAppBar.dart';
import 'Attendance/attendance.dart';
import 'Home/Home.dart';
import 'constants.dart';
import 'login/login.dart';
import 'schedule/schedule.dart';

class mainPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<mainPage> {
  int _currentIdx = 0;
  bool loggedIn = true;
  Widget render(idx) {
    if (idx == 0)
      return HomePage();
    else if (idx == 1)
      return Attendance();
    else if (idx == 2)
      return Schedule();
    else {
      setState(() {
        loggedIn = false;
      });
      return LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar('', AppBar().preferredSize, true),
        body: render(_currentIdx),
        bottomNavigationBar: loggedIn
            ? (BottomNavigationBar(
                currentIndex: _currentIdx,
                iconSize: 30,
                selectedItemColor: kPrimaryColor,
                selectedFontSize: 16,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    title: Text('Home'),
                    backgroundColor: Colors.grey[400],
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.notes),
                    title: Text('Attendance'),
                    backgroundColor: Colors.grey[400],
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.schedule),
                    title: Text('Schedule'),
                    backgroundColor: Colors.grey[400],
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.logout),
                    title: Text('Logout'),
                    backgroundColor: Colors.grey[400],
                  ),
                ],
                onTap: (index) {
                  setState(() {
                    _currentIdx = index;
                  });
                },
              ))
            : null,
      ),
    ));
  }
}
