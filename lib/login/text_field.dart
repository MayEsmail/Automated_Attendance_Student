import 'package:flutter/material.dart';
import 'rounded_container.dart';

import '../constants.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        decoration: InputDecoration(
          icon: Icon(
            Icons.person,
            color: kPrimaryColor,
          ),
          hintText: "Student ID",
          border: InputBorder.none,
        ),
      )
    );
  }
}

