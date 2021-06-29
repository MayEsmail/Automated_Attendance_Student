import 'package:flutter/material.dart';

import '../constants.dart';

class RoundedButton extends StatelessWidget{    
  const RoundedButton({
    key,
    required this.color,
    required this.text,
    required this.splash,
    required this.onPressed
  }): super(key: key);
  final color;
  final text;
  final splash;
  final onPressed;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return (SizedBox(
        width: size.width*0.46,
        height: 40,
        child: ElevatedButton(
          child: Text(
            text,
            style: TextStyle(fontSize: 14,color: Colors.white)
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
            overlayColor: MaterialStateProperty.resolveWith(
                (states) {
                  return states.contains(MaterialState.pressed)
                      ? splash
                      : null;
                },
              ), 
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              )
            ),
          ),
          onPressed: onPressed
        ),
      )
    );
  }

}