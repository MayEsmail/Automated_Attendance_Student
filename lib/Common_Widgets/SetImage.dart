import 'package:flutter/material.dart';

import '../constants.dart';

class SetImage extends StatelessWidget {
  const SetImage({
    Key? key,
    required this.size,
    required this.path,
    required this.width,
    required this.height,
  }) : super(key: key);

  final Size size;
  final String path;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width*width,
      height: size.height*height,
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(path),
            fit: BoxFit.fill
          ),
        ),
      ),
    );
  }
}

