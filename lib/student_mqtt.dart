import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

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

// void publishMessage(String message, MqttServerClient client) {
//   final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
//   builder.addString(message);

//   print('MQTTClientWrapper::Publishing message $message to topic ${Constants.topicName}');
//   client.publishMessage('Dart/Mqtt_client/testtopic', MqttQos.exactlyOnce, builder.payload);
// }

// myp@ss123456789w0rd
// Future<void> publish(MqttServerClient client) async {
//   const pubTopic = 'topic/test';

//     final builder = MqttClientPayloadBuilder();
//   builder.addString('Hello MQTT');
//   // client.publishMessage(pubTopic, MqttQos.atLeastOnce, "{builder.payload}");
//   client.publishMessage(
//       'Dart/Mqtt_client/testtopic', MqttQos.exactlyOnce, builder.payload);
// }

Future<MqttServerClient> connect() async {
  MqttServerClient client =
      MqttServerClient.withPort('broker.emqx.io', 'flutter_client', 1883);
  client.logging(on: true);
  client.onConnected = onConnected;
  client.onDisconnected = onDisconnected;
  // client.onUnsubscribed = onUnsubscribed;
  client.onSubscribed = onSubscribed;
  client.onSubscribeFail = onSubscribeFail;
  client.pongCallback = pong;

  final connMessage = MqttConnectMessage()
      .authenticateAs('username', 'password')
      .keepAliveFor(60)
      .withWillTopic('willtopic')
      .withWillMessage('Will message')
      .startClean()
      .withWillQos(MqttQos.atLeastOnce);
  client.connectionMessage = connMessage;
  try {
    await client.connect();
  } catch (e) {
    print('Exception: $e');
    client.disconnect();
  }

  client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    print('Received message:${c}>');
    // final MqttPublishMessage message = c[0].payload;
    // final payload =
    // MqttPublishPayload.bytesToStringAsString(message.payload.message);

    // print('Received message:$payload from topic: ${c[0].topic}>');
  });
  return client;
}