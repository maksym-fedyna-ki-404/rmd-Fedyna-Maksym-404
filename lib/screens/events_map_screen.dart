import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventsMapScreen extends StatelessWidget {
  const EventsMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Мокові дані для демонстрації
    final events = [
      {
        'title': 'Прибирання парку Шевченка',
        'date': '15 грудня, 10:00',
        'location': 'Парк ім. Т.Г. Шевченка, Львів',
        'lat': 49.8397,
        'lng': 24.0297,
      },
      {
        'title': 'Допомога притулку для тварин',
        'date': '18 грудня, 14:00',
        'location': 'Притулок "Друзі тварин", Львів',
        'lat': 49.8300,
        'lng': 24.0100,
      },
      {
        'title': 'Роздача їжі бездомним',
        'date': '20 грудня, 12:00',
        'location': 'Центр міста, Львів',
        'lat': 49.8500,
        'lng': 24.0300,
      },
      {
        'title': 'Навчання дітей англійської',
        'date': '22 грудня, 16:00',
        'location': 'Бібліотека ім. Франка, Львів',
        'lat': 49.8400,
        'lng': 24.0200,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: const Text(
              'Івенти на карті',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.map,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Карта буде доступна після налаштування',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Google Maps API',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Icon(
                              FontAwesomeIcons.locationDot,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(event['title'] as String),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(event['date'] as String),
                                Text(event['location'] as String),
                              ],
                            ),
                            trailing: Text(
                              '${event['lat']}, ${event['lng']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
