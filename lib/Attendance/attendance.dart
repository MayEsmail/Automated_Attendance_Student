import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:students/MQTT/MQTTManager.dart';
import 'package:students/login/login.dart';

import '../constants.dart';
// import 'AttendanceModel.dart';

class Attendance extends StatefulWidget {
  @override
  AttendanceState createState() => new AttendanceState();
}

class AttendanceState extends State<Attendance> {
  List dummyData = [
    {"title": "", "id": ""}
  ];

  Future<bool> getSchedule() async {
    // Future<AttendanceModel> getData() async {
    final response = await http.post(
      Uri.parse('https://beta.masterofthings.com/GetAppReadingValueList'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "AppId": 49,
        "ConditionList": [
          {"Reading": "track", "Condition": "e", "Value": trackId},
        ],
        "Auth": {"Key": "2cbTYJUc1hN0zWGe1624465017336attendance"},
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

  // late Future<AttendanceModel> data;
  Future<String> getData() async {
    // Future<AttendanceModel> getData() async {
    final response = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/albums"));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      this.setState(() {
        dummyData = convert.jsonDecode(response.body);
        // print(dummyData);
      });
      // print(data[1]["title"]);
      return "Success!";
      // return AttendanceModel.fromJson(convert.jsonDecode(response.body)[0]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    // this.data = this.getData();
    this.getData();
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
            itemCount: dummyData == null ? 0 : dummyData.length,
            itemBuilder: (BuildContext context, int index) {
              return new Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(dummyData[index]["title"],
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                )),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Text(dummyData[index]["id"].toString() + "%",
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
      ],
    );
  }
}
