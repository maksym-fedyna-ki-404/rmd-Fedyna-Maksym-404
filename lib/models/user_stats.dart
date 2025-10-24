import 'package:flutter/material.dart';

/// Рівні рейтингової системи
enum UserLevel {
  beginner('Новачок', 0, 5, '🌱'),
  volunteer('Волонтер', 5, 10, '🤝'),
  helper('Помічник', 10, 20, '💪'),
  champion('Чемпіон', 20, 50, '🏆'),
  hero('Герой', 50, 100, '🦸'),
  legend('Легенда', 100, 999, '👑');

  const UserLevel(this.name, this.minEvents, this.maxEvents, this.emoji);
  
  final String name;
  final int minEvents;
  final int maxEvents;
  final String emoji;
  
  static UserLevel getLevelByEvents(int eventsCount) {
    for (final level in UserLevel.values) {
      if (eventsCount >= level.minEvents && eventsCount < level.maxEvents) {
        return level;
      }
    }
    return UserLevel.legend;
  }
  
  int getProgressToNextLevel(int currentEvents) {
    if (this == UserLevel.legend) return 0;
    return maxEvents - currentEvents;
  }
  
  double getProgressPercentage(int currentEvents) {
    if (this == UserLevel.legend) return 1.0;
    final progress = currentEvents - minEvents;
    final total = maxEvents - minEvents;
    return progress / total;
  }
}

/// Статистика користувача
class UserStats {
  final int totalEventsAttended;
  final int totalHoursVolunteered;
  final int currentStreak;
  final int longestStreak;
  final List<String> categories;
  final DateTime joinDate;
  
  const UserStats({
    required this.totalEventsAttended,
    required this.totalHoursVolunteered,
    required this.currentStreak,
    required this.longestStreak,
    required this.categories,
    required this.joinDate,
  });
  
  UserLevel get currentLevel => UserLevel.getLevelByEvents(totalEventsAttended);
  
  int get progressToNextLevel => currentLevel.getProgressToNextLevel(totalEventsAttended);
  
  double get progressPercentage => currentLevel.getProgressPercentage(totalEventsAttended);
}
