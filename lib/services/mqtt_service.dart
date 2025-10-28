import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService extends ChangeNotifier {
  final String broker;
  final String clientId;
  final int port;
  final String topic;

  late final MqttServerClient _client;
  final StreamController<String> _temperatureController = StreamController.broadcast();

  bool _connected = false;
  bool get isConnected => _connected;
  Stream<String> get temperatureStream => _temperatureController.stream;

  MqttService({
    this.broker = 'broker.hivemq.com',
    this.clientId = 'flutter_volunteer_event_client',
    this.port = 1883,
    this.topic = 'sensor/temperature',
  }) {
    _client = MqttServerClient(broker, clientId)
      ..port = port
      ..logging(on: false)
      ..keepAlivePeriod = 20
      ..onDisconnected = _onDisconnected
      ..onConnected = _onConnected;
  }

  Future<void> connect() async {
    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    _client.connectionMessage = connMessage;

    try {
      await _client.connect();
    } catch (e) {
      _client.disconnect();
      rethrow;
    }

    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      _client.subscribe(topic, MqttQos.atMostOnce);
      _client.updates?.listen((messages) {
        final rec = messages.first.payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(rec.payload.message);
        _temperatureController.add(payload);
      });
    }
  }

  Future<void> publish(String payload) async {
    if (!_connected) return;
    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);
    _client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
  }

  void _onConnected() {
    _connected = true;
    notifyListeners();
  }

  void _onDisconnected() {
    _connected = false;
    notifyListeners();
  }

  Future<void> disconnect() async {
    _client.disconnect();
  }

  @override
  void dispose() {
    _temperatureController.close();
    super.dispose();
  }
}


