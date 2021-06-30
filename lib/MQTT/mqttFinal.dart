import 'dart:ffi';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

Future<MqttServerClient> myConnect() async {
  MqttServerClient client =
      MqttServerClient.withPort('beta.masterofthings.com', 'flutter_client', 1883);
  client.logging(on: true);
  client.onConnected = onConnected;
  client.onDisconnected = onDisconnected;
  client.onSubscribed = onSubscribed;
  client.onSubscribeFail = onSubscribeFail;
  client.pongCallback = pong;

  final connMessage = MqttConnectMessage()
      .authenticateAs('iti2021_projects', 'iti2021_projects')
      .keepAliveFor(60)
      .withWillTopic('iti/2021/AutomatedAttendance/mobile')
      .withWillMessage('{"beacons":[{"id":"d6", "rssi":70}, {"id":"b8", "rssi":80},]},"stId":"1"}')
      .startClean()
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
  const pubTopic = 'topic/test';
  final builder = MqttClientPayloadBuilder();
  builder.addString('{"beacons":[{"id":"d6", "rssi":70}, {"id":"b8", "rssi":80},]},"stId":"1"}');
  client.publishMessage(pubTopic, MqttQos.atMostOnce, builder.payload!);

  return client;
}

void publishMePlz(MqttServerClient client){
  const pubTopic = 'topic/test';
  final builder = MqttClientPayloadBuilder();
  builder.addString('Hello MQTT');
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
