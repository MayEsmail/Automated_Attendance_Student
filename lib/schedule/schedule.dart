import 'dart:convert';

import 'package:flutter/material.dart';
import 'Lecture.dart';
import 'package:students/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Schedule extends StatelessWidget {
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
        dummyData = res["Result"];
        // trackId = res["Result"][0]["track_id"];
        print(dummyData);
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
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Widnesday',
    'Thrusday',
    'Friday'
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    getSchedule();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: (GridView.count(
          crossAxisCount: 2,
          childAspectRatio: ((size.width / 2) / 255),
          scrollDirection: Axis.vertical,
          children: List.generate(dummyData.length + 1, (index) {
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
