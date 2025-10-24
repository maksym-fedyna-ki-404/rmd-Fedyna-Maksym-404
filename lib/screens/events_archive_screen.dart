import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/event.dart';
import 'event_detail_screen.dart';

class EventsArchiveScreen extends StatefulWidget {
  const EventsArchiveScreen({super.key});

  @override
  State<EventsArchiveScreen> createState() => _EventsArchiveScreenState();
}

class _EventsArchiveScreenState extends State<EventsArchiveScreen> {
  // Брендові кольори
  static const Color primary = Color(0xFF2E7D32);
  static const Color secondary = Color(0xFFFF7043);
  static const Color accent = Color(0xFF42A5F5);

  // Мокові дані завершених івентів
  final List<Event> completedEvents = [
    Event(
      id: '5',
      title: 'Прибирання міського парку',
      description: 'Успішно прибрали парк та зробили його чистішим',
      startDate: DateTime.now().subtract(const Duration(days: 7)),
      endDate: DateTime.now().subtract(const Duration(days: 7, hours: -4)),
      location: 'Міський парк, Львів',
      category: 'Екологія',
      maxParticipants: 40,
      currentParticipants: 35,
      status: EventStatus.completed,
      requirements: ['Робочі рукавички', 'Добрий настрій'],
      organizer: 'Еко-Львів',
      contactInfo: '+380 67 123 4567',
      latitude: 49.8397,
      longitude: 24.0297,
    ),
    Event(
      id: '6',
      title: 'Допомога дитячому будинку',
      description: 'Провели день з дітьми та привезли необхідні речі',
      startDate: DateTime.now().subtract(const Duration(days: 14)),
      endDate: DateTime.now().subtract(const Duration(days: 14, hours: -3)),
      location: 'Дитячий будинок №3, Львів',
      category: 'Соціальна допомога',
      maxParticipants: 25,
      currentParticipants: 20,
      status: EventStatus.completed,
      requirements: ['Любов до дітей', 'Позитивний настрій'],
      organizer: 'Дитячий будинок №3',
      contactInfo: '+380 67 234 5678',
      latitude: 49.8300,
      longitude: 24.0100,
    ),
    Event(
      id: '7',
      title: 'Навчання літніх людей комп\'ютеру',
      description: 'Допомогли літнім людям освоїти базові навички роботи з комп\'ютером',
      startDate: DateTime.now().subtract(const Duration(days: 21)),
      endDate: DateTime.now().subtract(const Duration(days: 21, hours: -2)),
      location: 'Центр соціальних послуг, Львів',
      category: 'Освіта',
      maxParticipants: 15,
      currentParticipants: 12,
      status: EventStatus.completed,
      requirements: ['Терпіння', 'Знання комп\'ютера'],
      organizer: 'Центр соціальних послуг',
      contactInfo: '+380 67 345 6789',
      latitude: 49.8500,
      longitude: 24.0300,
    ),
    Event(
      id: '8',
      title: 'Роздача теплого одягу',
      description: 'Роздали теплий одяг бездомним перед зимовим сезоном',
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now().subtract(const Duration(days: 30, hours: -3)),
      location: 'Центр міста, Львів',
      category: 'Соціальна допомога',
      maxParticipants: 20,
      currentParticipants: 18,
      status: EventStatus.completed,
      requirements: ['Співчуття', 'Готовність допомогти'],
      organizer: 'Львівська благодійність',
      contactInfo: '+380 67 456 7890',
      latitude: 49.8400,
      longitude: 24.0200,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // Кастомний хедер
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
                children: [
                  Icon(
                    FontAwesomeIcons.archive,
                    color: primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Архів подій',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${completedEvents.length} івентів',
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
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
                      icon: FontAwesomeIcons.checkCircle,
                      title: 'Завершено',
                      value: '${completedEvents.length}',
                      color: Colors.green,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: _buildStatItem(
                      icon: FontAwesomeIcons.clock,
                      title: 'Годин',
                      value: '${completedEvents.length * 3}',
                      color: accent,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: _buildStatItem(
                      icon: FontAwesomeIcons.users,
                      title: 'Учасників',
                      value: '${completedEvents.fold(0, (sum, event) => sum + event.currentParticipants)}',
                      color: secondary,
                    ),
                  ),
                ],
              ),
            ),
            // Список завершених івентів
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: completedEvents.length,
                itemBuilder: (context, index) {
                  final event = completedEvents[index];
                  return _buildCompletedEventCard(event);
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
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedEventCard(Event event) {
    final daysAgo = DateTime.now().difference(event.endDate).inDays;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          borderRadius: BorderRadius.circular(12),
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
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            FontAwesomeIcons.checkCircle,
                            size: 12,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Завершено',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  event.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.calendar,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${event.endDate.day}.${event.endDate.month}.${event.endDate.year}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      FontAwesomeIcons.clock,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${event.startDate.hour.toString().padLeft(2, '0')}:${event.startDate.minute.toString().padLeft(2, '0')} - ${event.endDate.hour.toString().padLeft(2, '0')}:${event.endDate.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.locationDot,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        event.location,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Text(
                      daysAgo == 0 
                          ? 'Сьогодні'
                          : daysAgo == 1 
                              ? 'Вчора'
                              : '$daysAgo днів тому',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.users,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${event.currentParticipants} учасників',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        event.category,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: accent,
                        ),
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
  }
}
