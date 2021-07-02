import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:students/constants.dart';

class MQTTManager {
  Future<MqttServerClient> getClient() async {
    MqttServerClient client =
        MqttServerClient.withPort(BROKER, 'flutter_client', PORT);
    client.logging(on: true);

    final connMessage = MqttConnectMessage()
        .authenticateAs(USERNAME, PASSWORD)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    client.connectionMessage = connMessage;
    try {
      await client.connect();
    } catch (e) {
      print('[-] CANT CONNECT TO THIS CLIENT YA GMA3A\nException: $e');
      client.disconnect();
    }

    return client;
  }

  void listeningToSub(MqttServerClient client, String topic) {
    subscribeToTopic(client, "${TOPIC}/${topic}");
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);
      print(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      print('');
    });
    print(
        'EXAMPLE::OnConnected client callback - Client connection was sucessful');
    client.unsubscribe("${TOPIC}/${topic}");
  }

  void publishMessage(MqttServerClient client, String message, String topic) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(Uri.encodeComponent(message));
    client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
  }

  void subscribeToTopic(MqttServerClient client, String topic) {
    print("Subscriped to topic" + topic);
    client.subscribe(topic, MqttQos.atMostOnce);
    // client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    //   print('Received message');
    // });
  }

  void listenToSubTopic(MqttServerClient client) {
    print("Listening to topic");
    print(client.published);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      print('Received message');
    });
  }

  void listenOnPublished(MqttServerClient client) {
    client.published!.listen((MqttPublishMessage message) {
      print("RECIECED MESSAGE KMA YNB8Y");
      print(message);
    });
  }

  void FUNCTIONKAMLA(MqttServerClient client) {
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('EMQX client connected');
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        print('ANA GOWA LINE 61');

        // final MqttPublishMessage message = c[0].payload;
        // final payload =
        //     MqttPublishPayload.bytesToStringAsString(message.payload.message);

        print('Received message:${c[0].payload} from topic: ${c[0].topic}>');
      });

      client.published!.listen((MqttPublishMessage message) {
        print('ANA GOWA LINE 71');
        // final payload =
        //     MqttPublishPayload.bytesToStringAsString(message.payload.message);
        print(
            'Published message: ${message.payload} to topic: ${message.variableHeader!.topicName}');
      });
    }
  }
}

Future<MqttServerClient> myConnect() async {
  MqttServerClient client = MqttServerClient.withPort(
      'beta.masterofthings.com', 'flutter_client', 1883);
  client.logging(on: true);
  // client.onConnected = onConnected;
  // client.onDisconnected = onDisconnected;
  // client.onSubscribed = onSubscribed;
  // client.onSubscribeFail = onSubscribeFail;
  // client.pongCallback = pong;

  final connMessage = MqttConnectMessage()
      .authenticateAs('iti2021_projects', 'iti2021_projects')
      //     .keepAliveFor(60)
      //     .withWillTopic('iti/2021/AutomatedAttendance/mobile')
      //     .withWillMessage('U BESO')
      //     .startClean()
      .withWillQos(MqttQos.atMostOnce);
  client.connectionMessage = connMessage;
  try {
    await client.connect();
  } catch (e) {
    print('Exception: $e');
    client.disconnect();
  }
// ​
//   client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
//     final MqttPublishMessage message = "hello";
//     final payload = MqttPublishPayload.bytesToStringAsString(message);
// ​
//     print('Received message:$payload from topic: ${c[0].topic}>');
//   });
  const pubTopic = 'iti/2021/AutomatedAttendance/mobile';
  final builder = MqttClientPayloadBuilder();
  // var encodedMsg = utf8.encode(
  //     '{"beacons":[{"id":"z3bola", "rssi":70}, {"id":"b8", "rssi":80},]},"stId":"1"}');
  var encodedMsg =
      '{\"beacons\":[{\"id\":\"z3boljjja\", \"rssi\":70}, {\"id\":\"b8\", \"rssi\":80},]},\"stId\":\"1\"}';
  builder.addString(Uri.encodeComponent(encodedMsg));
  client.publishMessage(pubTopic, MqttQos.atMostOnce, builder.payload!);
  return client;
}

// connection succeeded
void onConnected() {
  print('Connected');
}

// unconnected
void onDisconnected() {
  print('Disconnected');
}

// subscribe to topic succeeded
void onSubscribed(String topic) {
  print('Subscribed topic: $topic');
}

// subscribe to topic failed
void onSubscribeFail(String topic) {
  print('Failed to subscribe $topic');
}

// unsubscribe succeeded
void onUnsubscribed(String topic) {
  print('Unsubscribed topic: $topic');
}

// PING response received
void pong() {
  print('Ping response client callback invoked');
}





// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';
// // import '../models/MQTTAppState.dart';

// class MQTTManager extends ChangeNotifier {
//   // Private instance of client
//   // MQTTAppState _currentState = MQTTAppState();
//   MqttServerClient? _client;
//   late String _identifier;
//   String? _host;
//   String _topic = "";

//   void initializeMQTTClient({
//     required String host,
//     required String identifier,
//   }) {
//     // Save the values
//     // TODO: If already connected throw error
//     // TODO: Remove forced unwrap usage and assertion
//     _identifier = identifier;
//     _host = host;
//     _client = MqttServerClient(_host!, _identifier);
//     _client!.port = 1883;
//     _client!.keepAlivePeriod = 20;
//     _client!.onDisconnected = onDisconnected;
//     _client!.secure = false;
//     _client!.logging(on: true);

//     /// Add the successful connection callback
//     _client!.onConnected = onConnected;
//     _client!.onSubscribed = onSubscribed;
//     _client!.onUnsubscribed = onUnsubscribed;

//     final MqttConnectMessage connMess = MqttConnectMessage()
//         .authenticateAs("iti2021_projects", "iti2021_projects")
//         .withWillTopic(
//             'willtopic') // If you set this you must set a will message
//         .withWillMessage('My Will message')
//         .startClean() // Non persistent session for testing
//         //.authenticateAs(username, password)// Non persistent session for testing
//         .withWillQos(MqttQos.atLeastOnce);
//     print('EXAMPLE::Mosquitto client connecting....');
//     _client!.connectionMessage = connMess;
//   }

//   String? get host => _host;
//   // MQTTAppState get currentState => _currentState;
//   // Connect to the host
//   void connect() async {
//     assert(_client != null);
//     try {
//       print('EXAMPLE::Mosquitto start client connecting....');
//       // _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
//       updateState();
//       await _client!.connect();
//     } on Exception catch (e) {
//       print('EXAMPLE::client exception - $e');
//       disconnect();
//     }
//   }

//   void disconnect() {
//     print('Disconnected');
//     _client!.disconnect();
//   }

//   void publish(String message) {
//     final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
//     builder.addString(message);
//     _client!.publishMessage(_topic, MqttQos.exactlyOnce, builder.payload!);
//   }

//   /// The subscribed callback
//   void onSubscribed(String topic) {
//     print('EXAMPLE::Subscription confirmed for topic $topic');
//     // _currentState
//         // .setAppConnectionState(MQTTAppConnectionState.connectedSubscribed);
//     updateState();
//   }

//   void onUnsubscribed(String? topic) {
//     print('EXAMPLE::onUnsubscribed confirmed for topic $topic');
//     // _currentState.clearText();
//     // _currentState
//     //     .setAppConnectionState(MQTTAppConnectionState.connectedUnSubscribed);
//     updateState();
//   }

//   /// The unsolicited disconnect callback
//   void onDisconnected() {
//     print('EXAMPLE::OnDisconnected client callback - Client disconnection');
//     if (_client!.connectionStatus!.returnCode ==
//         MqttConnectReturnCode.noneSpecified) {
//       print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
//     }
//     // _currentState.clearText();
//     // _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
//     updateState();
//   }

//   /// The successful connect callback
//   void onConnected() {
//     // _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
//     // updateState();
//     print('EXAMPLE::Mosquitto client connected....');
//     _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
//       final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
//       final String pt =
//           MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);
//       // _currentState.setReceivedText(pt);
//       updateState();
//       print(
//           'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
//       print('');
//     });
//     print(
//         'EXAMPLE::OnConnected client callback - Client connection was sucessful');
//   }

//   void subScribeTo(String topic) {
//     // Save topic for future use
//     _topic = topic;
//     _client!.subscribe(topic, MqttQos.atLeastOnce);
//   }

//   /// Unsubscribe from a topic
//   void unSubscribe(String topic) {
//     _client!.unsubscribe(topic);
//   }

//   /// Unsubscribe from a topic
//   void unSubscribeFromCurrentTopic() {
//     _client!.unsubscribe(_topic);
//   }

//   void updateState() {
//     //controller.add(_currentState);
//     notifyListeners();
//   }
// }