import 'package:flutter/material.dart';
import 'rounded_container.dart';

import '../constants.dart';
class MyPasswordField extends StatelessWidget {
  final ValueChanged<String>onChanged;
  const MyPasswordField({
    Key? key, 
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
    child: TextField(
      obscureText: true,
      onChanged: onChanged,
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
          );
  }
}