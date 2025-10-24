import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/event.dart';
import 'event_detail_screen.dart';

class UpcomingEventsScreen extends StatelessWidget {
  const UpcomingEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF2E7D32);
    const Color secondary = Color(0xFFFF7043);
    const Color accent = Color(0xFF42A5F5);

    // Мокові дані зареєстрованих івентів
    final registeredEvents = [
      Event(
        id: '1',
        title: 'Прибирання парку Шевченка',
        description: 'Допоможемо прибрати парк та зробити його чистішим для всіх львів\'ян',
        startDate: DateTime.now().add(const Duration(days: 3, hours: 2)),
        endDate: DateTime.now().add(const Duration(days: 3, hours: 6)),
        location: 'Парк ім. Т.Г. Шевченка, Львів',
        category: 'Екологія',
        maxParticipants: 20,
        currentParticipants: 15,
        status: EventStatus.upcoming,
        requirements: const ['Робочі рукавички', 'Добрий настрій'],
        organizer: 'Екологічна організація "Зелений Львів"',
        contactInfo: 'green.lviv@example.com',
        latitude: 49.8397,
        longitude: 24.0297,
      ),
      Event(
        id: '2',
        title: 'Допомога притулку для тварин',
        description: 'Потрібна допомога з годуванням та доглядом за безпритульними тваринами',
        startDate: DateTime.now().add(const Duration(days: 5, hours: 4)),
        endDate: DateTime.now().add(const Duration(days: 5, hours: 8)),
        location: 'Притулок "Друзі тварин", Львів',
        category: 'Допомога тваринам',
        maxParticipants: 10,
        currentParticipants: 8,
        status: EventStatus.upcoming,
        requirements: const ['Любов до тварин', 'Комфортний одяг'],
        organizer: 'Притулок "Друзі тварин"',
        contactInfo: 'animals@example.com',
        latitude: 49.8300,
        longitude: 24.0100,
      ),
    ];
    
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // Заголовок
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    'Мої події',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ),
            // Статистика
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      icon: FontAwesomeIcons.calendarCheck,
                      title: 'Зареєстровано',
                      value: '${registeredEvents.length}',
                      color: primary,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      icon: FontAwesomeIcons.clock,
                      title: 'Найближчий',
                      value: registeredEvents.isNotEmpty 
                          ? _getTimeUntilNext(registeredEvents.first)
                          : 'Немає',
                      color: secondary,
                    ),
                  ),
                ],
              ),
            ),
            // Список івентів
            Expanded(
              child: registeredEvents.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: registeredEvents.length,
                      itemBuilder: (context, index) {
                        final event = registeredEvents[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EventDetailScreen(event: event),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            event.title,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: primary,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: accent.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            event.formattedTimeUntilStart,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: accent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      event.description,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.locationDot,
                                          size: 14,
                                          color: Colors.grey[500],
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            event.location,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          FontAwesomeIcons.calendar,
                                          size: 14,
                                          color: Colors.grey[500],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _formatDate(event.startDate),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: LinearProgressIndicator(
                                            value: event.fillLevel,
                                            backgroundColor: Colors.grey[300],
                                            valueColor: AlwaysStoppedAnimation<Color>(primary),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${event.currentParticipants}/${event.maxParticipants}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.calendarXmark,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Немає зареєстрованих подій',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Зареєструйтеся на івенти, щоб вони з\'явилися тут',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeUntilNext(Event event) {
    return event.formattedTimeUntilStart;
  }

  String _formatDate(DateTime date) {
    final months = [
      'січня', 'лютого', 'березня', 'квітня', 'травня', 'червня',
      'липня', 'серпня', 'вересня', 'жовтня', 'листопада', 'грудня'
    ];
    
    return '${date.day} ${months[date.month - 1]}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}