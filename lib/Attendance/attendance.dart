import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../constants.dart';
// import 'AttendanceModel.dart';

class Attendance extends StatefulWidget {
  @override
  AttendanceState createState() => new AttendanceState();
}

class AttendanceState extends State<Attendance> {
  var attendance = new Map();
  var mapKeys = {};
  List dummyData = [
    {"title": "", "id": ""}
  ];

  Future<bool> getAttendance() async {
    print("SEND IT " + trackId);
    try {
      final response = await http.post(
        Uri.parse('https://beta.masterofthings.com/GetAppReadingValueList'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "AppId": 49,
          "ConditionList": [
            {"Reading": "st_id", "Condition": "e", "Value": globalUserID},
            {"Reading": "course", "Condition": "m", "Value": null}
          ],
          "Auth": {"Key": "2cbTYJUc1hN0zWGe1624465017336attendance"},
        }),
      );
      if (response.statusCode == 200) {
        var res = {};
        res["Result"] = convert.jsonDecode(response.body)["Result"];
        if (res["Result"].length > 0) {
          for (int i = 0; i < res["Result"].length; i++) {
            if (attendance.containsKey(res["Result"][i]["course"])) {
              if (mounted) {
                this.setState(() {
                  attendance[res["Result"][i]["course"]][0] +=
                      res["Result"][i]["percent"];
                  attendance[res["Result"][i]["course"]][1]++;
                });
              }
            } else {
              if (mounted) {
                this.setState(() {
                  attendance[res["Result"][i]["course"]] = [
                    res["Result"][i]["percent"],
                    1
                  ];
                });
              }
            }
          }
          // dummyData = res["Result"];
          print(attendance);
          return true;
        }
        return false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    // this.data = this.getData();
    this.getAttendance();
  }

  @override
  Widget build(BuildContext context) {
    // MQTTManager MQTTObj = new MQTTManager();

    // MQTTObj.publishMessage(
    //     LoginScreen.client, globalUserID, TOPIC + "attendance_pub");
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          color: Colors.grey[800],
          child: ListTile(
            // leading: Text('ID'),
            title: Text('Course',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
            trailing: Text('Attendance %',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
        // FutureBuilder<AttendanceModel>(
        //   future: data,
        //   builder: (context, snapshot) {
        //     while (snapshot.hasData) {
        //       print(snapshot.data);
        //       return new Card(
        //         child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Row(
        //             children: [
        //               Expanded(
        //                 child: Text(snapshot.data!.course,
        //                     style: TextStyle(
        //                         // fontWeight: FontWeight.bold,
        //                         )),
        //               ),
        //               Spacer(),
        //               Padding(
        //                 padding: const EdgeInsets.only(right: 30.0),
        //                 child: Text(snapshot.data!.percentage.toString(),
        //                     style: TextStyle(
        //                       fontWeight: FontWeight.bold,
        //                     )),
        //               ),
        //             ],
        //           ),
        //         ),
        //       );
        //       // Text(snapshot.data!.course);
        //     }
        //     // else if (snapshot.hasError) {
        //     //   return Text("${snapshot.error}");
        //     // }

        //     // By default, show a loading spinner.
        //     return CircularProgressIndicator();
        //   },
        // ),
        Expanded(
          child: ListView.builder(
            // ignore: unnecessary_null_comparison
            itemCount: attendance == null ? 0 : attendance.length,
            itemBuilder: (BuildContext context, int index) {
              return new Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(attendance.keys.toList()[index],
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                )),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Text(
                            (attendance[attendance.keys.toList()[index]][0] /
                                        attendance[
                                            attendance.keys.toList()[index]][1])
                                    .toStringAsFixed(1) +
                                "%",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        attendance.length == 0
            ? Container(
                child: Center(
                child: CircularProgressIndicator(),
              ))
            : Container(),
      ],
    );
  }
}
