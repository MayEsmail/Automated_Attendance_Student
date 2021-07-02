import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:students/constants.dart';

class StudentMQTT {
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
    print(client);
    return client;
  }

  void publishMessage(MqttServerClient client, String message, String topic) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(Uri.encodeComponent(message));
    client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
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

void publishMePlz(MqttServerClient client) {
  const pubTopic = 'iti/2021/AutomatedAttendance/mobile';
  final builder = MqttClientPayloadBuilder();
  builder.addString(
      '{\"beacons":[{"id":"z3bola", "rssi":70}, {"id":"b8", "rssi":80},]},"stId":"1"}');
  client.publishMessage(pubTopic, MqttQos.atMostOnce, builder.payload!);
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
