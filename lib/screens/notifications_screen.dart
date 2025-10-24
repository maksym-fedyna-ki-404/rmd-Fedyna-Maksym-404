import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Брендові кольори
  static const Color primary = Color(0xFF2E7D32);
  static const Color secondary = Color(0xFFFF7043);
  static const Color accent = Color(0xFF42A5F5);

  // Мокові дані сповіщень
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Новий івент поблизу',
      'message': 'Прибирання парку Шевченка - завтра о 10:00',
      'time': '2 хвилини тому',
      'type': 'event',
      'isRead': false,
    },
    {
      'title': 'Реєстрація підтверджена',
      'message': 'Ви успішно зареєструвалися на івент "Допомога притулку для тварин"',
      'time': '1 година тому',
      'type': 'registration',
      'isRead': false,
    },
    {
      'title': 'Нагадування про івент',
      'message': 'Івент "Роздача їжі бездомним" почнеться через 2 години',
      'time': '3 години тому',
      'type': 'reminder',
      'isRead': true,
    },
    {
      'title': 'Досягнення розблоковано',
      'message': 'Вітаємо! Ви досягли рівня "Волонтер" 🎉',
      'time': '1 день тому',
      'type': 'achievement',
      'isRead': true,
    },
    {
      'title': 'Івент скасовано',
      'message': 'Івент "Навчання дітей англійської" скасовано через погодні умови',
      'time': '2 дні тому',
      'type': 'cancellation',
      'isRead': true,
    },
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
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    color: primary,
                  ),
                  Expanded(
                    child: Text(
                      'Сповіщення',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        for (var notification in notifications) {
                          notification['isRead'] = true;
                        }
                      });
                    },
                    icon: const Icon(
                      FontAwesomeIcons.checkDouble,
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
                      icon: FontAwesomeIcons.bell,
                      title: 'Нові',
                      value: '${notifications.where((n) => !n['isRead']).length}',
                      color: secondary,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: _buildStatItem(
                      icon: FontAwesomeIcons.list,
                      title: 'Всього',
                      value: '${notifications.length}',
                      color: accent,
                    ),
                  ),
                ],
              ),
            ),
            
            // Список сповіщень
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _buildNotificationCard(notification);
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

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['isRead'] as bool;
    final type = notification['type'] as String;
    
    IconData icon;
    Color iconColor;
    
    switch (type) {
      case 'event':
        icon = FontAwesomeIcons.calendarPlus;
        iconColor = accent;
        break;
      case 'registration':
        icon = FontAwesomeIcons.checkCircle;
        iconColor = Colors.green;
        break;
      case 'reminder':
        icon = FontAwesomeIcons.clock;
        iconColor = secondary;
        break;
      case 'achievement':
        icon = FontAwesomeIcons.trophy;
        iconColor = Colors.amber;
        break;
      case 'cancellation':
        icon = FontAwesomeIcons.xmarkCircle;
        iconColor = Colors.red;
        break;
      default:
        icon = FontAwesomeIcons.bell;
        iconColor = Colors.grey;
    }

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
        border: isRead 
            ? null 
            : Border.all(
                color: primary.withOpacity(0.3),
                width: 1,
              ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              notification['isRead'] = true;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'] as String,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isRead ? Colors.grey[700] : primary,
                              ),
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['message'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notification['time'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
