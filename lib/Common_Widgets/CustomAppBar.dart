import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final pageTitle;
  final bool logStatus;
  @override
  final Size preferredSize;

  CustomAppBar(this.pageTitle, this.preferredSize, this.logStatus) : super();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Row(
        children: [
          Image.asset(
            "assets/images/logo.png",
            width: 30,
            fit: BoxFit.fitHeight,
          ),
          VerticalDivider(
            thickness: 1,
            color: Color(0xFFF6F4F4),
          ),
          Flexible(
              child: Text("Information Technology Institute",
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ))),
          Center(
            child: this.logStatus ? null : null,
          ),
        ],
      ),
    );
  }
}
