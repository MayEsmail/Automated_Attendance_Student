import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

TextStyle customTextStyle =
    TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold);

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Flexible(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.check_rounded,
                    size: 60,
                    color: Colors.green,
                  ),
                ),
                Flexible(
                  child: Text(
                    'Automated attendacne is active',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.only(bottom: 20.0)),
          SizedBox(
            width: 200.0,
            child: OutlinedButton(
              onPressed: () {
                print("DAMN");
              },
              child: Text(
                'Turn on',
                style: TextStyle(fontSize: 25),
              ),
              style: OutlinedButton.styleFrom(
                shape: StadiumBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: 10,
            ),
            child: Divider(
              color: Colors.black,
              thickness: 1.7,
            ),
          ),
          Text(
            'Current Session Info',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24,
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold),
          ),
          Padding(padding: const EdgeInsets.only(bottom: 20.0)),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 120,
                color: Colors.green,
              ),
              Column(children: [
                Text(
                  'Subject',
                  textAlign: TextAlign.left,
                  style: customTextStyle,
                ),
                Text(
                  'Instructor',
                  textAlign: TextAlign.left,
                  style: customTextStyle,
                ),
                Text(
                  'Room',
                  style: customTextStyle,
                  textAlign: TextAlign.left,
                ),
                Text(
                  'Floor',
                  style: customTextStyle,
                  textAlign: TextAlign.left,
                ),
                Text(
                  'From',
                  style: customTextStyle,
                  textAlign: TextAlign.left,
                ),
                Text(
                  'To',
                  style: customTextStyle,
                  textAlign: TextAlign.left,
                ),
              ])
            ],
          ),
          VerticalDivider(
            color: Colors.black,
            thickness: 6,
            width: 20,
            indent: 10,
            endIndent: 10,
          ),
          Flexible(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'You have attended 55 minutes out of 60 minutes',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
