import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class EventsListScreen extends StatelessWidget {
  const EventsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Мокові дані для демонстрації
    final events = [
      {
        'title': 'Прибирання парку Шевченка',
        'description': 'Допоможемо прибрати парк та зробити його чистішим для всіх львів\'ян',
        'date': '15 грудня, 10:00',
        'location': 'Парк ім. Т.Г. Шевченка, Львів',
      },
      {
        'title': 'Допомога притулку для тварин',
        'description': 'Потрібна допомога з годуванням та доглядом за безпритульними тваринами',
        'date': '18 грудня, 14:00',
        'location': 'Притулок "Друзі тварин", Львів',
      },
      {
        'title': 'Роздача їжі бездомним',
        'description': 'Допоможемо роздати гарячу їжу тим, хто цього найбільше потребує',
        'date': '20 грудня, 12:00',
        'location': 'Центр міста, Львів',
      },
      {
        'title': 'Навчання дітей англійської',
        'description': 'Допоможемо дітям з вивченням англійської мови у неформальній атмосфері',
        'date': '22 грудня, 16:00',
        'location': 'Бібліотека ім. Франка, Львів',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          const PageHeader(
            title: 'Волонтерські івенти',
            subtitle: 'Знайдіть івент, який вас цікавить',
          ),
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return EventCard(
                  title: event['title']!,
                  description: event['description']!,
                  date: event['date']!,
                  location: event['location']!,
                  onTap: () {
                    // Навігація до деталей івента
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Відкриваємо ${event['title']}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
