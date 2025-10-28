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
