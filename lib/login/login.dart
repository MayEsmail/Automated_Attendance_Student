import '../Common_Widgets/rounded_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'password_field.dart';
import 'text_field.dart';
import '../Common_Widgets/SetImage.dart';
import '../constants.dart';

class LoginScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Center(
      child: (Column(
        mainAxisAlignment:MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            child:Text("Login", style: TextStyle(fontWeight: FontWeight.w600,color: Colors.grey[600], fontSize: 22),),
            width: size.width*0.9,
            height: 30,
          ),
          SetImage(size: size,path: "../assets/images/login.png",width: 0.9,height: 0.35,),
          SizedBox(height: 15,),
          MyTextField(),
          MyPasswordField(onChanged: (value){},),
          SizedBox(height: 26,),
          RoundedButton(text: "Login",onPressed: (){},color: kPrimaryColor, splash: Colors.grey[700],),
          SizedBox(
            height: 18,
          ),
          InkWell(
            child: new Text('Visit our website',style:TextStyle(color: Colors.blue[700],decoration: TextDecoration.underline)),
            onTap: () => launch('https://www.iti.gov.eg')
          ),
      ],)
      ),
    );
  }
}

