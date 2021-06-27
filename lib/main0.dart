/**
 * From here
 * https://pub.dev/packages/beacons_plugin/example
 */
// import 'dart:async';
// import 'dart:io' show Platform;

// import 'package:beacons_plugin/beacons_plugin.dart';
// import 'package:flutter/material.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String _beaconResult = 'Not Scanned Yet.';
//   int _nrMessaggesReceived = 0;
//   var isRunning = false;

//   final StreamController<String> beaconEventsController =
//       StreamController<String>.broadcast();

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }

//   @override
//   void dispose() {
//     beaconEventsController.close();
//     super.dispose();
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     if (Platform.isAndroid) {
//       //Prominent disclosure
//       await BeaconsPlugin.setDisclosureDialogMessage(
//           title: "Need Location Permission",
//           message: "This app collects location data to work with beacons.");

//       //Only in case, you want the dialog to be shown again. By Default, dialog will never be shown if permissions are granted.
//       //await BeaconsPlugin.clearDisclosureDialogShowFlag(false);
//     }

//     BeaconsPlugin.listenToBeacons(beaconEventsController);

//     await BeaconsPlugin.addRegion("Eddystone", "80124d1f3364e60d3192");
//     // await BeaconsPlugin.addRegion(
//     //     "BeaconType2", "6a84c716-0f2a-1ce9-f210-6a63bd873dd9");

//     beaconEventsController.stream.listen(
//         (data) {
//           if (data.isNotEmpty) {
//             setState(() {
//               _beaconResult = data;
//               _nrMessaggesReceived++;
//             });
//             print("Beacons DataReceived: " + data);
//           }
//         },
//         onDone: () {},
//         onError: (error) {
//           print("Error: $error");
//         });

//     //Send 'true' to run in background
//     await BeaconsPlugin.runInBackground(true);

//     if (Platform.isAndroid) {
//       BeaconsPlugin.channel.setMethodCallHandler((call) async {
//         if (call.method == 'scannerReady') {
//           await BeaconsPlugin.startMonitoring();
//           setState(() {
//             isRunning = true;
//           });
//         }
//       });
//     } else if (Platform.isIOS) {
//       await BeaconsPlugin.startMonitoring();
//       setState(() {
//         isRunning = true;
//       });
//     }

//     if (!mounted) return;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Monitoring Beacons'),
//         ),
//         body: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text("TEST THIS BITCH" + '$_beaconResult'),
//               Padding(
//                 padding: EdgeInsets.all(10.0),
//               ),
//               Text('$_nrMessaggesReceived'),
//               SizedBox(
//                 height: 20.0,
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (isRunning) {
//                     await BeaconsPlugin.stopMonitoring();
//                   } else {
//                     initPlatformState();
//                     await BeaconsPlugin.startMonitoring();
//                   }
//                   setState(() {
//                     isRunning = !isRunning;
//                   });
//                 },
//                 child: Text(isRunning ? 'Stop Scanning' : 'Start Scanning',
//                     style: TextStyle(fontSize: 20)),
//               ),
//               SizedBox(
//                 height: 20.0,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

/** Basic*/

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String devices = "Test";
  FlutterBlue flutterBlue = FlutterBlue.instance;
  // final flutterReactiveBle = FlutterReactiveBle();
  void startListeneing(int stopScan) {
    if (stopScan % 2 != 1) {
      print('Scanning...');
      // Start scanning
      flutterBlue.startScan(timeout: Duration(seconds: 4));
      // Listen to scan results
      flutterBlue.scanResults.listen((results) {
        // do something with scan results
        for (ScanResult r in results) {
          devices += '${r.device.name} found! rssi: ${r.rssi}';
          print('${r.device.name} found! rssi: ${r.rssi}');
        }
      });
    }

    // Stop scanning
    else
      flutterBlue.stopScan();
  }

  void _incrementCounter() {
    startListeneing(_counter);
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have clicked  the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '$devices',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
