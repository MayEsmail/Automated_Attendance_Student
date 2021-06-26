import 'package:flutter/material.dart';
import 'package:student/constants.dart';
import 'schedule/schedule.dart';
import './login/login.dart';
void main()=>runApp(MyApp());
class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIdx=0;
  bool isLoggedIn=true;
  Widget render(idx){
    if(idx==0)return(Text('Home '));
    else if(idx==1)return(Text('Attendance '));
    else return Schedule();
  }
  @override
  Widget build(BuildContext context) {
    return(MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/iti.png"),
                  fit: BoxFit.fill
                ), 
              ),
            ),
          ),
          ),
          body: isLoggedIn?render(_currentIdx):LoginScreen(),
          bottomNavigationBar:isLoggedIn?(BottomNavigationBar(
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
          ],
          onTap: (index){
            setState(() {
              _currentIdx=index;
            });
          },
          )):null,
        ),
    )
    );
  } 
}

