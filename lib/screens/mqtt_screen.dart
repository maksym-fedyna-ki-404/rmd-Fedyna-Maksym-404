import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../services/mqtt_service.dart';

class MqttScreen extends StatelessWidget {
  const MqttScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // Хедер
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: const [
                  _BackButton(),
                  Expanded(
                    child: Text(
                      'MQTT Датчик температури',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Consumer<MqttService>(
                  builder: (context, mqtt, _) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: mqtt.isConnected ? null : () async {
                                  try {
                                    await mqtt.connect();
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Помилка підключення: $e')),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Підключитись'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: mqtt.isConnected ? mqtt.disconnect : null,
                                child: const Text('Відключитись'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Статус:'),
                                  Text(
                                    mqtt.isConnected ? 'Підключено' : 'Відключено',
                                    style: TextStyle(
                                      color: mqtt.isConnected ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              StreamBuilder<String>(
                                stream: mqtt.temperatureStream,
                                builder: (context, snapshot) {
                                  final raw = snapshot.data;
                                  String displayValue = '-';
                                  String unit = '°C';
                                  String sensorId = '';
                                  String timeStr = '';

                                  if (raw != null) {
                                    try {
                                      final data = jsonDecode(raw);
                                      if (data is Map<String, dynamic>) {
                                        final v = data['value'];
                                        if (v is num) {
                                          displayValue = v.toStringAsFixed(2);
                                        } else if (v is String) {
                                          displayValue = double.parse(v).toStringAsFixed(2);
                                        }
                                        if (data['unit'] is String) unit = data['unit'] as String;
                                        if (data['sensorId'] is String) sensorId = data['sensorId'] as String;
                                        if (data['timestamp'] != null) {
                                          final ts = data['timestamp'];
                                          DateTime? dt;
                                          if (ts is int) {
                                            // очікуємо мілісекунди
                                            dt = DateTime.fromMillisecondsSinceEpoch(ts);
                                          } else if (ts is String) {
                                            dt = DateTime.tryParse(ts);
                                          }
                                          if (dt != null) {
                                            timeStr = '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                                          }
                                        }
                                      }
                                    } catch (_) {
                                      // не JSON — спробуємо як число
                                      try {
                                        displayValue = double.parse(raw).toStringAsFixed(2);
                                      } catch (_) {
                                        displayValue = raw;
                                      }
                                    }
                                  }

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Text('Температура'),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            displayValue,
                                            style: const TextStyle(
                                              fontSize: 48,
                                              fontWeight: FontWeight.bold,
                                              color: primary,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            unit,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (sensorId.isNotEmpty || timeStr.isNotEmpty) ...[
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if (sensorId.isNotEmpty)
                                              Text('Датчик: $sensorId', style: TextStyle(color: Colors.grey[700])),
                                            if (sensorId.isNotEmpty && timeStr.isNotEmpty)
                                              Text('  •  ', style: TextStyle(color: Colors.grey[400])),
                                            if (timeStr.isNotEmpty)
                                              Text(timeStr, style: TextStyle(color: Colors.grey[700])),
                                          ],
                                        ),
                                      ],
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        OutlinedButton(
                          onPressed: mqtt.isConnected ? () => mqtt.publish('25.3') : null,
                          child: const Text('Надіслати тестову температуру (25.3)'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF2E7D32);
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back),
      color: primary,
    );
  }
}


