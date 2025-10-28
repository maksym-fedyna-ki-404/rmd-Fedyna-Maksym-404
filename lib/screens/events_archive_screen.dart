import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../services/events_repository.dart';
import 'event_detail_screen.dart';

class EventsArchiveScreen extends StatefulWidget {
  const EventsArchiveScreen({super.key});

  @override
  State<EventsArchiveScreen> createState() => _EventsArchiveScreenState();
}

class _EventsArchiveScreenState extends State<EventsArchiveScreen> {
  static const Color primary = Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
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
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    color: primary,
                  ),
                  const SizedBox(width: 8),
                  Icon(FontAwesomeIcons.archive, color: primary, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Архів подій',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primary),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Event>>(
                future: _loadCompletedEvents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final events = snapshot.data ?? [];
                  if (events.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.archive, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'Немає завершених подій',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: events.length,
                    itemBuilder: (context, index) => _buildEventCard(events[index], context),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Event>> _loadCompletedEvents() async {
    final repo = Provider.of<EventsRepository>(context, listen: false);
    final all = await repo.fetchEvents(excludeCompleted: false);
    
    print('📚 Загалом івентів: ${all.length}');
    
    final now = DateTime.now();
    final completed = all.where((e) {
      final isStatusCompleted = e.status == EventStatus.completed;
      final isPast = e.endDate.isBefore(now);
      print('   ${e.title}: status=${e.status}, endDate=${e.endDate.toIso8601String()}, isStatusCompleted=$isStatusCompleted, isPast=$isPast');
      return isStatusCompleted || isPast;
    }).toList()
      ..sort((a, b) => b.endDate.compareTo(a.endDate));
    
    print('✅ Знайдено завершених івентів: ${completed.length}');
    
    return completed;
  }

  Widget _buildEventCard(Event event, BuildContext context) {
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
        leading: Icon(FontAwesomeIcons.checkCircle, color: Colors.green, size: 20),
        title: Text(event.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.location, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            Text(
              '${event.startDate.day}.${event.startDate.month}.${event.startDate.year}',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)),
        ),
      ),
    );
  }
}
