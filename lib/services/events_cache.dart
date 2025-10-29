import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event.dart';

class EventsCache {
  static const String _cacheKey = 'cached_events';
  static const String _cacheTimestampKey = 'events_cache_timestamp';

  // Зберігаємо події локально
  static Future<void> cacheEvents(List<Event> events) async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = events.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_cacheKey, eventsJson);
    await prefs.setInt(_cacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  // Отримуємо кешовані події
  static Future<List<Event>> getCachedEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getStringList(_cacheKey);
    
    if (eventsJson == null) return [];
    
    return eventsJson
        .map((json) => Event.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();
  }

  // Перевіряємо чи є актуальний кеш (не старіший 1 години)
  static Future<bool> hasFreshCache() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_cacheTimestampKey);
    if (timestamp == null) return false;
    
    final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
    return cacheAge < 3600000; // 1 година
  }

  // Очищаємо кеш
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_cacheTimestampKey);
  }
}

