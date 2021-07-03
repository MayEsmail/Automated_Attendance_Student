import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:students/MQTT/MQTTManager.dart';
import 'package:students/login/login.dart';
import '../Common_Widgets/rounded_button.dart';
import 'package:students/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

TextStyle customTextStyle =
    TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // static var client;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  Future<bool> _checkDeviceBluetoothIsOn() async {
    return (await flutterBlue.isOn);
  }

  Future<bool> _checkDeviceLocationIsOn() async {
    return (await Permission.locationWhenInUse.serviceStatus.isEnabled);
  }

  ShowBluetoothDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
                "Bluetooth is off, Please turn it on to take your attendance!"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              )
            ],
          );
        });
  }

  bool scanning_enabled = false;
  List myBeacons = ['AC:23:3F:2C:D2:D6', 'AC:23:3F:2C:D2:B8'];
  MQTTManager MQTTObj = new MQTTManager();
  var curSessionInfo = new Map();
  var mapKeys = {};
  List dummyData = [
    {"title": "", "id": ""}
  ];
  Future<bool> getSessionData() async {
    DateTime dateToday =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    String currentDate = dateToday.toString().split(" ")[0];
    int currHour = DateTime.now().hour, currMinute = DateTime.now().minute;
    double currTime = currHour + currMinute / 60;
    try {
      final response = await http.post(
        Uri.parse('https://beta.masterofthings.com/GetAppReadingValueList'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "AppId": 64,
          "ConditionList": [
            {"Reading": "track", "Condition": "e", "Value": trackId},
            {"Reading": "date", "Condition": "e", "Value": currentDate}
          ],
          "Auth": {"Key": "EGqZsciBhtw50o7o1625134162529schedule"},
        }),
      );
      if (response.statusCode == 200) {
        var res = {};
        res["Result"] = convert.jsonDecode(response.body)["Result"];
        if (res["Result"].length > 0) {
          dummyData = res["Result"];
          for (int i = 0; i < dummyData.length; i++) {
            // print(dummyData[i]);
            if (13 >= dummyData[i]["from"] - .2 && 13 <= dummyData[i]["to"]) {
              if (mounted) {
                this.setState(() {
                  curSessionInfo = dummyData[i];
                });
              }
            }
          }
          return true;
        }
        // print(scheduleMap);
        return false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  var timer;
  Future<void> scanningToggler() async {
    if (mounted) {
      setState(() {
        scanning_enabled = !scanning_enabled;
      });
    }
    if (scanning_enabled) {
      print('Scanning...');
      // Start scanning
      Map<String, List<int>> readings = Map();
      timer = new Timer.periodic(const Duration(seconds: 35), (timer) {
        flutterBlue.startScan(timeout: Duration(seconds: 30));
        var now, lastSendingMinute = -1;
        // Listen to scan results
        flutterBlue.scanResults.listen((results) {
          // do something with scan results
          for (ScanResult r in results) {
            if (myBeacons.contains(r.device.id.toString())) {
              print(r.device.id.toString());
              if (!readings.containsKey(r.device.id.toString()))
                readings[r.device.id.toString()] = [];
              readings[r.device.id.toString()]?.add(r.rssi);
            }
            now = DateTime.now();
            // print(readings);
            if (now.minute % 5 == 0 && now.minute != lastSendingMinute) {
              lastSendingMinute = now.minute;
              var payload = {};
              payload["beacons"] = [];
              readings.forEach((k, v) {
                //k is beacon name, v is the list of values
                var mean = v.reduce((a, b) => a + b) / v.length;
                print(mean);
                payload["beacons"]!.add({"id": k, "rssi": mean});
              });
              print(jsonEncode(payload));
              payload["stId"] = 1;
              MQTTObj.publishMessage(
                  LoginScreen.client, jsonEncode(payload), "${TOPIC}/mobile");
              readings.clear();
              //send to platform
            }
          }
        });
      }); //(const Duration(seconds: 1), doStuffCallback);
    }
    // Stop scanning
    else {
      timer.cancel();
      flutterBlue.stopScan();
    }
  }

  @override
  Widget build(BuildContext context) {
    getSessionData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          scanning_enabled
              ? Scanning_Info(
                  icon: Icons.check_rounded,
                  color: Colors.green,
                  activity: "Automated attendacne is active")
              : Scanning_Info(
                  icon: Icons.signal_cellular_nodata,
                  color: Colors.redAccent[700],
                  activity: "Automated attendacne is not active",
                ),
          Padding(padding: const EdgeInsets.only(bottom: 20.0)),
          SizedBox(
            width: 200.0,
            child: RoundedButton(
              text: scanning_enabled ? 'Turn off' : 'Turn on',
              onPressed: () {
                _checkDeviceBluetoothIsOn().then((value) => {
                      if (value)
                        {scanningToggler()}
                      else
                        {
                          if (!scanning_enabled)
                            {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text(
                                          "Bluetooth is off, Please turn it on to take your attendance!"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        )
                                      ],
                                    );
                                  })
                            }
                          else
                            scanningToggler()
                        }
                    });
              },
              color: Colors.grey[700],
              splash: kPrimaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: 10,
            ),
            child: Divider(
              color: Colors.black,
              thickness: 1.7,
            ),
          ),
          Text(
            'Current Session',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24,
                color: kPrimaryColor,
                fontWeight: FontWeight.bold),
          ),
          Padding(padding: const EdgeInsets.only(bottom: 20.0)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 120,
                  color: Colors.green,
                ),
                Flexible(
                  child: curSessionInfo.length > 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Text(
                                'Course' + ": ${curSessionInfo["course"]}",
                                textAlign: TextAlign.left,
                                style: customTextStyle,
                              ),
                              Text(
                                'Instructor' +
                                    ": ${curSessionInfo["instructor_name"]}",
                                style: customTextStyle,
                              ),
                              Text(
                                'Room' + ": ${curSessionInfo["room"]}",
                                style: customTextStyle,
                              ),
                              Text(
                                'Floor' + ": ${curSessionInfo["floor"]}",
                                style: customTextStyle,
                              ),
                              Text(
                                'From' + ": ${curSessionInfo["from"]}",
                                style: customTextStyle,
                              ),
                              Text(
                                'To' + ": ${curSessionInfo["to"]}",
                                style: customTextStyle,
                              ),
                            ])
                      : Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Container(
                              child: Center(
                            child: CircularProgressIndicator(),
                          )),
                        ),
                )
              ],
            ),
          ),
          VerticalDivider(
            color: Colors.black,
            thickness: 6,
            width: 20,
            indent: 10,
            endIndent: 10,
          ),
          Flexible(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AwesomeDialog {}

class Scanning_Info extends StatelessWidget {
  const Scanning_Info(
      {Key? key,
      required this.icon,
      required this.color,
      required this.activity})
      : super(key: key);
  final icon;
  final color;
  final activity;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              size: 60,
              color: color,
            ),
          ),
          Flexible(
            child: Text(
              activity,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
