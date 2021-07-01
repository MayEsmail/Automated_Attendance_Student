import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:students/Common_Widgets/rounded_button.dart';
import 'package:students/MQTT/mqttFinal.dart';
import 'package:students/constants.dart';

TextStyle customTextStyle =
    TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StudentMQTT obj = new StudentMQTT();
  bool scanning_enabled = false;
  List myBeacons = ['AC:23:3F:2C:D2:D6', 'AC:23:3F:2C:D2:B8'];
  Future<void> scanningToggler() async {
    MqttServerClient client = await obj.getClient();
    print(client);
    obj.publishMessage(client,
        '{"beacons": [{"id": "U Za3bola","rssi": 70}, {"id": "b8","rssi": 80}],"stId": "1"}');
    // myConnect();
    // if (client != null) {
    //   obj.publishMessage(client);
    // }
    return;
    // Map<String, List<int>> beaconsList = Map();
    String devicesName = "Test";
    FlutterBlue flutterBlue = FlutterBlue.instance;
    setState(() {
      scanning_enabled = !scanning_enabled;
    });
    if (scanning_enabled) {
      print('Scanning...');

      // Start scanning
      flutterBlue.startScan();
      // Listen to scan results
      flutterBlue.scanResults.listen((results) {
        // do something with scan results
        for (ScanResult r in results) {
          // if (r.device.name != "") beaconsList[r.device.name] = [r.rssi];
          devicesName +=
              'Name: ${r.device.name}. AdData: ${r.advertisementData}. RSSI: ${r.rssi}';
          print(
              'Name: ${r.device.name}. AdData: ${r.advertisementData}. RSSI: ${r.rssi}');
        }
      });
    }
    // Stop scanning
    else
      flutterBlue.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          scanning_enabled
              ? Scanning_Info(
                  icon: Icons.check_rounded,
                  color: Colors.green,
                  activity: "Automated attendacne is active")
              : Scanning_Info(
                  icon: Icons.signal_cellular_nodata,
                  color: Colors.redAccent[700],
                  activity: "Automated attendacne is not active",
                ),
          Padding(padding: const EdgeInsets.only(bottom: 20.0)),
          SizedBox(
            width: 200.0,
            child: RoundedButton(
              text: scanning_enabled ? 'Turn off' : 'Turn on',
              onPressed: scanningToggler,
              color: Colors.grey[700],
              splash: kPrimaryColor,
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
            'Current Session',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24,
                color: kPrimaryColor,
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
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'Subject',
                  textAlign: TextAlign.left,
                  style: customTextStyle,
                ),
                Text(
                  'Instructor',
                  style: customTextStyle,
                ),
                Text(
                  'Room',
                  style: customTextStyle,
                ),
                Text(
                  'Floor',
                  style: customTextStyle,
                ),
                Text(
                  'From',
                  style: customTextStyle,
                ),
                Text(
                  'To',
                  style: customTextStyle,
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
              alignment: Alignment.center,
              child: Text(
                'You have attended 55 minutes out of 60 minutes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: kPrimaryColor,
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

class Scanning_Info extends StatelessWidget {
  const Scanning_Info(
      {Key? key,
      required this.icon,
      required this.color,
      required this.activity})
      : super(key: key);
  final icon;
  final color;
  final activity;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              size: 60,
              color: color,
            ),
          ),
          Flexible(
            child: Text(
              activity,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
