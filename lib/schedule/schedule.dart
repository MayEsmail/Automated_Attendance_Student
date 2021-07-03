import 'dart:convert';

import 'package:flutter/material.dart';
import 'Lecture.dart';
import 'package:students/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

// {
// date: {from:{}, from:{}, from:{}},
// date: {from:{}, from:{}, from:{}},
// date: {from:{}, from:{}, from:{}},
// }
class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  var scheduleMap = new Map();

  Future<bool> getSchedule() async {
    // Future<AttendanceModel> getData() async {
    final response = await http.post(
      Uri.parse('https://beta.masterofthings.com/GetAppReadingValueList'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "AppId": 64,
        "ConditionList": [
          {"Reading": "track", "Condition": "e", "Value": trackId},
        ],
        "Auth": {"Key": "EGqZsciBhtw50o7o1625134162529schedule"},
      }),
    );
    if (response.statusCode == 200) {
      var res = {};
      res["Result"] = convert.jsonDecode(response.body)["Result"];
      if (res["Result"].length > 0) {
        // this.setState(() {
        dummyData = res["Result"];
        for (int i = 0; i < res["Result"].length; i++) {
          var sessionObj = dummyData[i]["from"];
          if (scheduleMap.containsKey(dummyData[i]["date"])) {
            var tempMap = scheduleMap[dummyData[i]["date"]];
            tempMap[sessionObj] = dummyData[i];
            if (mounted) {
              this.setState(() {
                scheduleMap[dummyData[i]["date"]] = tempMap;
              });
            }
          } else {
            if (mounted) {
              this.setState(() {
                scheduleMap[dummyData[i]["date"]] = {sessionObj: dummyData[i]};
              });
            }
          }
        }
        // });
        // print(scheduleMap);
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  late List dummyData = [
    {
      "course": "",
      "date": "",
      "from": "",
      "to": "",
      "room": "",
      "floor": "",
      "instructor_name": ""
    }
  ];

  var days = [
    'Monday',
    'Tuesday',
    'Widnesday',
    'Thrusday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    this.getSchedule();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var scheduleSortedKeys = scheduleMap.keys.toList()..sort();
    print(scheduleSortedKeys);
    // getSchedule();
    print(scheduleMap);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: (GridView.count(
          crossAxisCount: 2,
          childAspectRatio: ((size.width / 2) / 255),
          scrollDirection: Axis.vertical,
          children: List.generate(scheduleMap.keys.length, (index) {
            var day = scheduleMap[scheduleSortedKeys[index]];
            var sortedKeys = day.keys.toList()..sort();
            var course;
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
                    days[DateTime.parse(scheduleSortedKeys[index].toString())
                                    .weekday -
                                1]
                            .toString() +
                        " " +
                        scheduleSortedKeys[index].toString(),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )),
                  SizedBox(
                    height: 5,
                  ),
                  for (int i = 0; i < sortedKeys.length; i++)
                    Lecture(
                      lectureName: Text(
                        day[sortedKeys[i]]["course"] +
                            ' [${day[sortedKeys[i]]["from"]} - ${day[sortedKeys[i]]["to"]}]',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  //   day.keys.length > 0
                  //       ? Lecture(
                  //           lectureName: Text(
                  //             day[sortedKeys[1]]["course"],
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //         )
                  //       : Container(),
                  //   day.keys.length > 1
                  //       ? Lecture(
                  //           lectureName: Text(
                  //             day[sortedKeys[2]]["course"],
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //         )
                  //       : Container(),
                ],
              ),
            );
          }))),
    );
  }
}
