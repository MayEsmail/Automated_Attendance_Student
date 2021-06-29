
import 'package:flutter/material.dart';
import '../constants.dart';

class Lecture extends StatelessWidget {
  final Widget lectureName;
  const Lecture({
    Key? key,
    required this.lectureName,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      margin: EdgeInsets.only(bottom: 10),
      child: lectureName,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(5),
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
    );
  }
}