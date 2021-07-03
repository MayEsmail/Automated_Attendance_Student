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

class LoginScreen extends StatefulWidget {
  static var client;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController studentIDController = new TextEditingController();

  TextEditingController passwordController = new TextEditingController();

  MQTTManager MQTTObj = new MQTTManager();

  bool clicked = false, authenticated = true;

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
      LoginScreen.client = await MQTTObj.getClient();
      clicked = true;
    }
    MQTTObj.listeningToSub(LoginScreen.client, "/login/1/sub");
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
            Center(
              child: !authenticated
                  ? Text(
                      "Id or password incorrect",
                      style: TextStyle(color: Colors.red),
                    )
                  : null,
            ),
            SizedBox(
              height: 26,
            ),
            RoundedButton(
              text: "Login",
              onPressed: () {
                String id = studentIDController.text;
                String password = passwordController.text;

                authentiacateStudentREST(id, password).then((value) {
                  print(value);
                  if (value) {
                    if (mounted)
                      this.setState(() {
                        authenticated = true;
                      });
                    globalUserID = id.toLowerCase();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => mainPage()));
                  } else {
                    if (mounted)
                      this.setState(() {
                        authenticated = false;
                      });
                  }
                });
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
