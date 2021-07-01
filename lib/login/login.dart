import 'package:flutter/widgets.dart';
import 'package:student/login/rounded_container.dart';
import '../mainPage.dart';
import '../Common_Widgets/rounded_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import '../Common_Widgets/SetImage.dart';
import '../constants.dart';

class LoginScreen extends StatelessWidget{
  TextEditingController studentIDController =new TextEditingController();
  TextEditingController passwordController =new TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Center(
        child: (Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            SetImage(size: size,path: "assets/images/login.png",width: 0.9,height: 0.35,),
            SizedBox(height: 30,),
            TextFieldContainer(
              child: TextField(
              controller: studentIDController ,
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
                controller: passwordController ,
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
            SizedBox(height: 26,),
            RoundedButton(text: "Login",onPressed: (){
              String id=studentIDController.text;
              String password=passwordController.text;
              if(id.toLowerCase()=="1"&&password=="1"){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>mainPage()));
              }},
              color: kPrimaryColor, splash: Colors.grey[700],),
            SizedBox(
              height: 18,
            ),
            InkWell(
              child: new Text('Visit our website',style:TextStyle(color: Colors.blue[700],decoration: TextDecoration.underline)),
              onTap: () => launch('https://www.iti.gov.eg')
            ),
        ],)
        ),
      ),
    );
  }
}

