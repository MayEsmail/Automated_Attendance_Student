import 'package:flutter/material.dart';

import '../constants.dart';

class LoginButton extends StatelessWidget{    
  const LoginButton({
    key,
  }): super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return (SizedBox(
        width: size.width*0.46,
        height: 40,
        child: ElevatedButton(
          child: Text(
            "Login",
            style: TextStyle(fontSize: 14,color: Colors.white)
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(kPrimaryColor), 
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              )
            ),
          ),
          onPressed: (){}
        ),
      )
    );
  }

}