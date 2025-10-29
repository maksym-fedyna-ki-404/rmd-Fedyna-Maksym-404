import 'dart:convert';
/// Статуси івентів
enum EventStatus {
  upcoming('Майбутній'),
  ongoing('Триває'),
  completed('Завершений'),
  cancelled('Скасований');

  const EventStatus(this.displayName);
  final String displayName;
}

/// Модель івенту
class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String category;
  final String? imageUrl;
  final int maxParticipants;
  final int currentParticipants;
  final EventStatus status;
  final List<String> requirements;
  final String organizer;
  final String contactInfo;
  final double? latitude;
  final double? longitude;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.category,
    this.imageUrl,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.status,
    required this.requirements,
    required this.organizer,
    required this.contactInfo,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'location': location,
      'category': category,
      'image_url': imageUrl,
      'max_participants': maxParticipants,
      'current_participants': currentParticipants,
      'status': _statusToString(status),
      'requirements': requirements,
      'organizer': organizer,
      'contact_info': contactInfo,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startDate: _parseDate(json['start_date']),
      endDate: _parseDate(json['end_date']),
      location: json['location'] as String,
      category: json['category'] as String,
      imageUrl: json['image_url'] as String?,
      maxParticipants: (json['max_participants'] as num).toInt(),
      currentParticipants: (json['current_participants'] as num).toInt(),
      status: _statusFromString(json['status'] as String),
      requirements: _parseStringList(json['requirements']),
      organizer: json['organizer'] as String,
      contactInfo: json['contact_info'] as String,
      latitude: _parseNullableDouble(json['latitude']),
      longitude: _parseNullableDouble(json['longitude']),
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is DateTime) return value;
    final s = (value ?? '').toString();
    return DateTime.parse(s);
  }

  static double? _parseNullableDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    final s = value.toString();
    if (s.isEmpty) return null;
    return double.tryParse(s);
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return const [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    // Якщо прийшла JSON-строка (наприклад з CSV: "[\"A\",\"B\"]")
    try {
      final decoded = value is String ? value : value.toString();
      if (decoded.trim().isEmpty) return const [];
      final parsed = decoded.startsWith('[')
          ? (jsonDecode(decoded) as List)
          : <dynamic>[];
      return parsed.map((e) => e.toString()).toList();
    } catch (_) {
      return const [];
    }
  }

  static EventStatus _statusFromString(String s) {
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

  static String _statusToString(EventStatus status) {
    switch (status) {
      case EventStatus.upcoming:
        return 'upcoming';
      case EventStatus.ongoing:
        return 'ongoing';
      case EventStatus.completed:
        return 'completed';
      case EventStatus.cancelled:
        return 'cancelled';
    }
  }

  /// Чи є івент майбутнім
  bool get isUpcoming => status == EventStatus.upcoming && 
      startDate.isAfter(DateTime.now());

  /// Чи є івент завершеним
  bool get isCompleted => status == EventStatus.completed || 
      endDate.isBefore(DateTime.now());

  /// Чи є івент активним зараз
  bool get isOngoing => status == EventStatus.ongoing ||
      (startDate.isBefore(DateTime.now()) && endDate.isAfter(DateTime.now()));

  /// Час до початку івенту
  Duration? get timeUntilStart {
    if (isCompleted) return null;
    final now = DateTime.now();
    if (startDate.isAfter(now)) {
      return startDate.difference(now);
    }
    return null;
  }

  /// Час до завершення івенту
  Duration? get timeUntilEnd {
    if (isCompleted) return null;
    final now = DateTime.now();
    if (endDate.isAfter(now)) {
      return endDate.difference(now);
    }
    return null;
  }

  /// Форматований час до початку
  String get formattedTimeUntilStart {
    final duration = timeUntilStart;
    if (duration == null) return '';
    
    if (duration.inDays > 0) {
      return '${duration.inDays}д ${duration.inHours % 24}г';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}г ${duration.inMinutes % 60}хв';
    } else {
      return '${duration.inMinutes}хв';
    }
  }

  /// Форматований час до завершення
  String get formattedTimeUntilEnd {
    final duration = timeUntilEnd;
    if (duration == null) return '';
    
    if (duration.inDays > 0) {
      return '${duration.inDays}д ${duration.inHours % 24}г';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}г ${duration.inMinutes % 60}хв';
    } else {
      return '${duration.inMinutes}хв';
    }
  }

  /// Рівень заповненості
  double get fillLevel => currentParticipants / maxParticipants;

  /// Чи є вільні місця
  bool get hasAvailableSpots => currentParticipants < maxParticipants;
}
