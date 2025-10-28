import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import '../widgets/widgets.dart';
import '../models/event.dart';
import '../services/events_repository.dart';
import 'event_detail_screen.dart';

class EventsListScreen extends StatefulWidget {
  const EventsListScreen({super.key});

  @override
  State<EventsListScreen> createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
  // Брендові кольори
  static const Color primary = Color(0xFF2E7D32);
  
  // Список лайкнутих івентів (ID)
  Set<String> likedEvents = {};
  
  List<Event> events = const [];

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
              child: FutureBuilder<List<Event>>(
                future: _loadData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Помилка: ${snapshot.error}'));
                  }
                  if (events.isEmpty) {
                    return Center(child: Text('Немає івентів'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return EventCard(
                        title: event.title,
                        description: event.description,
                        date: _formatDate(event.startDate),
                        location: event.location,
                        isLiked: likedEvents.contains(event.id),
                        isCompleted: event.isCompleted,
                        onTap: () => _navigateToEventDetail(event),
                        onLikeToggle: () => _toggleLike(event.id),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Event>> _loadData() async {
    final repo = Provider.of<EventsRepository>(context, listen: false);
    final userId = Supabase.instance.client.auth.currentUser?.id;
    
    // Завантажуємо івенти (без completed)
    events = await repo.fetchEvents(excludeCompleted: true);
    
    // Завантажуємо лайки
    if (userId != null) {
      likedEvents = await repo.fetchFavorites(userId);
    }
    
    return events;
  }

  String _formatDate(DateTime date) {
    final months = [
      'січня', 'лютого', 'березня', 'квітня', 'травня', 'червня',
      'липня', 'серпня', 'вересня', 'жовтня', 'листопада', 'грудня'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _navigateToEventDetail(Event event) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailScreen(event: event),
      ),
    );
    // Оновлюємо список після повернення
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _toggleLike(String eventId) async {
    final repo = Provider.of<EventsRepository>(context, listen: false);
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    
    final isLiked = likedEvents.contains(eventId);
    final makeFav = !isLiked;
    
    // Оновлюємо UI
    setState(() {
      if (makeFav) {
        likedEvents.add(eventId);
      } else {
        likedEvents.remove(eventId);
      }
    });
    
    // Зберігаємо в Supabase
    await repo.toggleFavorite(userId, eventId, makeFav);
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
                        final eventId = likedEvents.elementAt(index);
                        final event = events.firstWhere((e) => e.id == eventId);
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