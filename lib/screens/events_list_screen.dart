import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/widgets.dart';
import '../models/event.dart';
import 'event_detail_screen.dart';

class EventsListScreen extends StatefulWidget {
  const EventsListScreen({super.key});

  @override
  State<EventsListScreen> createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
  // Брендові кольори
  static const Color primary = Color(0xFF2E7D32);
  
  // Список лайкнутих івентів
  final Set<String> likedEvents = {'Прибирання парку Шевченка', 'Допомога притулку для тварин'};

  // Повні мокові дані івентів
  final List<Event> events = [
    Event(
      id: '1',
      title: 'Прибирання парку Шевченка',
      description: 'Допоможемо прибрати парк та зробити його чистішим для всіх львів\'ян. Ми збираємося очистити алеї від сміття, прибрати листя та підготувати парк до зимового сезону.',
      startDate: DateTime(2024, 12, 15, 10, 0),
      endDate: DateTime(2024, 12, 15, 14, 0),
      location: 'Парк ім. Т.Г. Шевченка, Львів',
      category: 'Екологія',
      maxParticipants: 30,
      currentParticipants: 18,
      status: EventStatus.upcoming,
      requirements: [
        'Зручний одяг та взуття',
        'Робочі рукавички',
        'Бажання допомагати',
        'Вік від 16 років'
      ],
      organizer: 'Екологічна організація "Зелений Львів"',
      contactInfo: '+380 50 123 45 67',
      latitude: 49.8397,
      longitude: 24.0297,
    ),
    Event(
      id: '2',
      title: 'Допомога притулку для тварин',
      description: 'Потрібна допомога з годуванням та доглядом за безпритульними тваринами. Ми шукаємо волонтерів для допомоги з вигулом собак, годуванням котів та прибиранням території притулку.',
      startDate: DateTime(2024, 12, 18, 14, 0),
      endDate: DateTime(2024, 12, 18, 18, 0),
      location: 'Притулок "Друзі тварин", Львів',
      category: 'Тварини',
      maxParticipants: 20,
      currentParticipants: 12,
      status: EventStatus.upcoming,
      requirements: [
        'Любов до тварин',
        'Терпіння',
        'Зручний одяг',
        'Досвід роботи з тваринами (бажано)'
      ],
      organizer: 'Притулок "Друзі тварин"',
      contactInfo: '+380 67 234 56 78',
      latitude: 49.8500,
      longitude: 24.0100,
    ),
    Event(
      id: '3',
      title: 'Роздача їжі бездомним',
      description: 'Допоможемо роздати гарячу їжу тим, хто цього найбільше потребує. Ми готуємо гарячі обіди та роздаємо їх бездомним людям у центрі міста.',
      startDate: DateTime(2024, 12, 20, 12, 0),
      endDate: DateTime(2024, 12, 20, 16, 0),
      location: 'Центр міста, Львів',
      category: 'Соціальна допомога',
      maxParticipants: 15,
      currentParticipants: 15,
      status: EventStatus.completed,
      requirements: [
        'Доброзичливість',
        'Терпіння',
        'Зручний одяг',
        'Вік від 18 років'
      ],
      organizer: 'Благодійний фонд "Допомога ближньому"',
      contactInfo: '+380 63 345 67 89',
      latitude: 49.8426,
      longitude: 24.0322,
    ),
    Event(
      id: '4',
      title: 'Навчання дітей англійської',
      description: 'Допоможемо дітям з вивченням англійської мови у неформальній атмосфері. Ми проводимо інтерактивні заняття з англійської мови для дітей віком 8-12 років.',
      startDate: DateTime(2024, 12, 22, 16, 0),
      endDate: DateTime(2024, 12, 22, 18, 0),
      location: 'Бібліотека ім. Франка, Львів',
      category: 'Освіта',
      maxParticipants: 25,
      currentParticipants: 8,
      status: EventStatus.upcoming,
      requirements: [
        'Знання англійської мови (рівень B1+)',
        'Досвід роботи з дітьми',
        'Терпіння та креативність',
        'Вік від 20 років'
      ],
      organizer: 'Освітній центр "Майбутнє"',
      contactInfo: '+380 96 456 78 90',
      latitude: 49.8300,
      longitude: 24.0200,
    ),
    Event(
      id: '5',
      title: 'Медична допомога літнім людям',
      description: 'Допоможемо літнім людям з медичними обстеженнями та консультаціями. Ми надаємо безкоштовні медичні консультації та базові обстеження.',
      startDate: DateTime(2024, 12, 25, 9, 0),
      endDate: DateTime(2024, 12, 25, 15, 0),
      location: 'Поліклініка №3, Львів',
      category: 'Медицина',
      maxParticipants: 40,
      currentParticipants: 22,
      status: EventStatus.upcoming,
      requirements: [
        'Медична освіта або досвід',
        'Доброзичливість',
        'Професійний одяг',
        'Вік від 25 років'
      ],
      organizer: 'Медичний центр "Здоров\'я"',
      contactInfo: '+380 50 567 89 01',
      latitude: 49.8600,
      longitude: 24.0400,
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
                  Expanded(
                    child: Text(
                      'Заходи',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _showWishlistBottomSheet,
                    icon: Icon(
                      FontAwesomeIcons.heart,
                      color: likedEvents.isNotEmpty ? Colors.red : Colors.grey,
                    ),
                  ),
                  IconButton(
                    onPressed: _showArchiveBottomSheet,
                    icon: Icon(
                      FontAwesomeIcons.archive,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Контент
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return EventCard(
                    title: event.title,
                    description: event.description,
                    date: _formatDate(event.startDate),
                    location: event.location,
                    isLiked: likedEvents.contains(event.title),
                    isCompleted: event.isCompleted,
                    onTap: () => _navigateToEventDetail(event),
                    onLikeToggle: () => _toggleLike(event.title),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'січня', 'лютого', 'березня', 'квітня', 'травня', 'червня',
      'липня', 'серпня', 'вересня', 'жовтня', 'листопада', 'грудня'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _navigateToEventDetail(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailScreen(event: event),
      ),
    );
  }

  void _toggleLike(String eventTitle) {
    setState(() {
      if (likedEvents.contains(eventTitle)) {
        likedEvents.remove(eventTitle);
      } else {
        likedEvents.add(eventTitle);
      }
    });
  }

  void _showWishlistBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Заголовок
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.heart,
                    color: Colors.red,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Улюблені івенти',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Список улюблених івентів
            Expanded(
              child: likedEvents.isEmpty
                  ? _buildEmptyWishlist()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: likedEvents.length,
                      itemBuilder: (context, index) {
                        final eventTitle = likedEvents.elementAt(index);
                        final event = events.firstWhere((e) => e.title == eventTitle);
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
                          child: ListTile(
                            leading: Icon(
                              FontAwesomeIcons.heart,
                              color: Colors.red,
                              size: 20,
                            ),
                            title: Text(
                              event.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.location,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  _formatDate(event.startDate),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () => _navigateToEventDetail(event),
                              icon: Icon(
                                FontAwesomeIcons.arrowRight,
                                color: primary,
                                size: 16,
                              ),
                            ),
                            onTap: () => _navigateToEventDetail(event),
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

  void _showArchiveBottomSheet() {
    final completedEvents = events.where((event) => event.isCompleted).toList();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Заголовок
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.archive,
                    color: primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Архів івентів',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Список завершених івентів
            Expanded(
              child: completedEvents.isEmpty
                  ? _buildEmptyArchive()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: completedEvents.length,
                      itemBuilder: (context, index) {
                        final event = completedEvents[index];
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
                          child: ListTile(
                            leading: Icon(
                              FontAwesomeIcons.checkCircle,
                              color: Colors.green,
                              size: 20,
                            ),
                            title: Text(
                              event.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.location,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  _formatDate(event.startDate),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () => _navigateToEventDetail(event),
                              icon: Icon(
                                FontAwesomeIcons.arrowRight,
                                color: primary,
                                size: 16,
                              ),
                            ),
                            onTap: () => _navigateToEventDetail(event),
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

  Widget _buildEmptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.heart,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Немає улюблених івентів',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Додайте івенти до улюблених,\nщоб вони з\'явилися тут',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyArchive() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.archive,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Немає завершених івентів',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Тут з\'являться івенти,\nякі ви вже відвідали',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}