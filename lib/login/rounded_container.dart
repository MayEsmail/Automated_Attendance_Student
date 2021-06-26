import 'package:flutter/material.dart';

import '../constants.dart';

class TextFieldContainer extends StatelessWidget{
    final Widget child;
    
    const TextFieldContainer({
      key,
      required this.child,
    }): super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: size.width*0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: kPrimaryColor),
        boxShadow: [
          BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 3,
        blurRadius: 4,
        offset: Offset(0, 4), // changes position of shadow
      ),
      ],
    ),
      child: child,
    );
  }

}