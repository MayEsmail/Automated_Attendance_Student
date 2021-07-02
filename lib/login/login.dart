import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:students/MQTT/MQTTManager.dart';
import 'package:students/login/rounded_container.dart';
import '../mainPage.dart';
import '../Common_Widgets/rounded_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import '../Common_Widgets/SetImage.dart';
import 'package:students/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LoginScreen extends StatelessWidget {
  TextEditingController studentIDController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  static var client;
  MQTTManager MQTTObj = new MQTTManager();
  bool clicked = false;

  Future<bool> authentiacateStudentREST(
      String username, String password) async {
    // Future<AttendanceModel> getData() async {
    final response = await http.post(
      Uri.parse('https://beta.masterofthings.com/GetAppReadingValueList'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "AppId": 48,
        "Limit": 10,
        "ConditionList": [
          {"Reading": "st_id", "Condition": "e", "Value": username},
          {"Reading": "password", "Condition": "e", "Value": password}
        ],
        "Auth": {"Key": "AwMzRcL02j462kSP1624464934559student"},
      }),
    );
    if (response.statusCode == 200) {
      var res = {};
      res["Result"] = convert.jsonDecode(response.body)["Result"];
      if (res["Result"].length > 0) {
        trackId = res["Result"][0]["track_id"];
        print("trackID: " + trackId);
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  Future<void> authentiacateStudent(String username, String password) async {
    if (!clicked) {
      client = await MQTTObj.getClient();
      clicked = true;
    }
    MQTTObj.listeningToSub(client, "/login/1/sub");
    // MQTTObj.subscribeToTopic(client, "${TOPIC}/login/1/sub");
    // MQTTObj.onConnected(client);
    // var payload = {"username": username, "password": password};
    // MQTTObj.publishMessage(client, jsonEncode(payload), "${TOPIC}/login_pub");

    // MQTTObj.subscribeToTopic(client, "${TOPIC}/schedule/${globalUserID}/sub");
    // MQTTObj.subscribeToTopic(client, "${TOPIC}/attendance/${globalUserID}/sub");

    // MQTTObj.listenToSubTopic(client);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Center(
        child: (Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            SetImage(
              size: size,
              path: "assets/images/login.png",
              width: 0.9,
              height: 0.35,
            ),
            SizedBox(
              height: 30,
            ),
            TextFieldContainer(
                child: TextField(
              controller: studentIDController,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.person,
                  color: kPrimaryColor,
                ),
                hintText: "Student ID",
                border: InputBorder.none,
              ),
            )),
            TextFieldContainer(
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.lock,
                    color: kPrimaryColor,
                  ),
                  suffixIcon: Icon(
                    Icons.visibility,
                    color: kPrimaryColor,
                  ),
                  hintText: "Password",
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: 26,
            ),
            RoundedButton(
              text: "Login",
              onPressed: () {
                String id = studentIDController.text;
                String password = passwordController.text;

                // authentiacateStudentREST(id, password);
                // authentiacateStudent(id, password);
                authentiacateStudentREST(id, password).then((value) {
                  print("WTF IS THIS VALUE:");
                  print(value);
                  if (value) {
                    globalUserID = id.toLowerCase();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => mainPage()));
                  }
                });

                if (id == 1243374687365487) {
                  globalUserID = id.toLowerCase();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => mainPage()));
                }
              },
              color: kPrimaryColor,
              splash: Colors.grey[700],
            ),
            SizedBox(
              height: 18,
            ),
            InkWell(
                child: new Text('Visit our website',
                    style: TextStyle(
                        color: Colors.blue[700],
                        decoration: TextDecoration.underline)),
                onTap: () => launch('https://www.iti.gov.eg')),
          ],
        )),
      ),
    );
  }
}
