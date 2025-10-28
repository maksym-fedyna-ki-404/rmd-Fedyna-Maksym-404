import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event.dart';
import '../models/user_stats.dart';

class EventsRepository {
  final SupabaseClient _db;
  EventsRepository(this._db);

  Future<List<Event>> fetchEvents({bool excludeCompleted = false}) async {
    var query = _db.from('events').select();
    
    if (excludeCompleted) {
      query = query.not('status', 'eq', 'completed');
    }
    
    final res = await query.order('start_date', ascending: true);

    return (res as List)
        .map((e) => _fromRow(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Event>> fetchUserUpcoming(String userId) async {
    try {
      final res = await _db
          .from('registrations')
          .select('events(*)')
          .eq('user_id', userId);

      print('🎫 fetchUserUpcoming для userId: $userId, знайдено: ${(res as List).length} записів');

      final rows = (res as List)
          .map((r) => r['events'] as Map<String, dynamic>?)
          .where((e) => e != null)
          .cast<Map<String, dynamic>>()
          .toList();
      
      print('✅ Оброблено ${rows.length} івентів');
      
      final events = rows.map(_fromRow).toList();
      final upcoming = events.where((e) => e.startDate.isAfter(DateTime.now())).toList();
      
      print('🎯 Майбутніх івентів: ${upcoming.length}');
      
      return upcoming;
    } catch (e) {
      print('❌ Помилка fetchUserUpcoming: $e');
      return [];
    }
  }

  Future<void> toggleFavorite(String userId, String eventId, bool makeFav) async {
    if (makeFav) {
      await _db.from('favorites').insert({'user_id': userId, 'event_id': eventId});
    } else {
      await _db.from('favorites').delete().match({'user_id': userId, 'event_id': eventId});
    }
  }

  Future<Set<String>> fetchFavorites(String userId) async {
    final res = await _db.from('favorites').select('event_id').eq('user_id', userId);
    return (res as List).map((e) => e['event_id'] as String).toSet();
  }

  Future<bool> isRegistered(String userId, String eventId) async {
    final res = await _db
        .from('registrations')
        .select('id')
        .eq('user_id', userId)
        .eq('event_id', eventId)
        .maybeSingle();
    return res != null;
  }

  Future<bool> register(String userId, String eventId) async {
    try {
      // Спробуємо вставити і повернути запис для підтвердження
      final inserted = await _db
          .from('registrations')
          .insert({'user_id': userId, 'event_id': eventId})
          .select('id')
          .maybeSingle();

      // Якщо запис вже існує (unique (user_id, event_id)), не падаємо
      if (inserted == null) {
        // Перевіримо, можливо вже зареєстрований
        final already = await isRegistered(userId, eventId);
        if (!already) return false;
      }

      // Оновлюємо лічильник (не критично при збої)
      await _db.rpc('increment_participants', params: {'p_event_id': eventId}).catchError((_) {});
      return true;
    } catch (e) {
      // Якщо у відповідь помилка RLS/унікальності
      try {
        final already = await isRegistered(userId, eventId);
        if (already) return true;
      } catch (_) {}
      rethrow;
    }
  }

  Future<bool> unregister(String userId, String eventId) async {
    try {
      final res = await _db
          .from('registrations')
          .delete()
          .match({'user_id': userId, 'event_id': eventId})
          .select('id');
      await _db.rpc('decrement_participants', params: {'p_event_id': eventId}).catchError((_) {});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserStats> fetchUserStats(String userId) async {
    try {
      // 1) Першочергово намагаємося отримати з бекенду агреговані значення
      final rpc = await _db.rpc('get_user_stats', params: {'uid': userId});
      if (rpc is List && rpc.isNotEmpty) {
        final row = rpc.first as Map<String, dynamic>;
        return UserStats(
          totalEventsAttended: (row['total_events'] as num?)?.toInt() ?? 0,
          totalHoursVolunteered: (row['total_hours'] as num?)?.toInt() ?? 0,
          currentStreak: (row['current_streak'] as num?)?.toInt() ?? 0,
          longestStreak: (row['longest_streak'] as num?)?.toInt() ?? 0,
          categories: List<String>.from(row['categories'] as List? ?? const []),
          joinDate: DateTime.tryParse(row['join_date']?.toString() ?? '') ?? DateTime.now(),
          backendLevelName: row['level_name'] as String?,
          backendLevelEmoji: row['level_emoji'] as String?,
          backendProgressToNext: (row['progress_to_next'] as num?)?.toInt(),
          backendProgressPercentage: (row['progress_percentage'] as num?)?.toDouble(),
        );
      }
    } catch (_) {
      // Якщо RPC недоступний, падаємо на фолбек нижче
    }

    // 2) Фолбек: локальний підрахунок на клієнті
    final res = await _db
        .from('registrations')
        .select('created_at, events(start_date, end_date, category)')
        .eq('user_id', userId);

    final List data = res as List? ?? const [];

    int totalEventsAttended = data.length;
    int totalHoursVolunteered = 0;
    int currentStreak = 0; // спрощено
    int longestStreak = 0; // спрощено
    final Map<String, int> categoryCount = {};
    DateTime joinDate = DateTime.now();

    for (final row in data) {
      final createdAtStr = row['created_at'] as String?;
      if (createdAtStr != null) {
        final createdAt = DateTime.parse(createdAtStr);
        if (createdAt.isBefore(joinDate)) {
          joinDate = createdAt;
        }
      }

      final ev = row['events'] as Map<String, dynamic>?;
      if (ev != null) {
        final start = DateTime.tryParse(ev['start_date'] as String? ?? '');
        final end = DateTime.tryParse(ev['end_date'] as String? ?? '');
        if (start != null && end != null && end.isAfter(start)) {
          totalHoursVolunteered += end.difference(start).inHours;
        }
        final category = ev['category'] as String?;
        if (category != null && category.isNotEmpty) {
          categoryCount[category] = (categoryCount[category] ?? 0) + 1;
        }
      }
    }

    final categories = categoryCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topCategories = categories.take(5).map((e) => e.key).toList();

    return UserStats(
      totalEventsAttended: totalEventsAttended,
      totalHoursVolunteered: totalHoursVolunteered,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      categories: topCategories,
      joinDate: joinDate,
    );
  }

  Event _fromRow(Map<String, dynamic> row) {
    return Event(
      id: row['id'] as String,
      title: row['title'] as String,
      description: row['description'] as String,
      startDate: DateTime.parse(row['start_date'] as String),
      endDate: DateTime.parse(row['end_date'] as String),
      location: row['location'] as String,
      category: row['category'] as String,
      imageUrl: row['image_url'] as String?,
      maxParticipants: row['max_participants'] as int,
      currentParticipants: row['current_participants'] as int,
      status: _statusFromString(row['status'] as String),
      requirements: List<String>.from(row['requirements'] as List? ?? const []),
      organizer: row['organizer'] as String,
      contactInfo: row['contact_info'] as String,
      latitude: (row['latitude'] as num?)?.toDouble(),
      longitude: (row['longitude'] as num?)?.toDouble(),
    );
  }

  EventStatus _statusFromString(String s) {
    switch (s) {
      case 'upcoming':
        return EventStatus.upcoming;
      case 'ongoing':
        return EventStatus.ongoing;
      case 'completed':
        return EventStatus.completed;
      case 'cancelled':
        return EventStatus.cancelled;
      default:
        return EventStatus.upcoming;
    }
  }
}


