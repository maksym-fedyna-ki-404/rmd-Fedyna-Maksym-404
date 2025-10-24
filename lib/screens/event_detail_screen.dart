import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/event.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _isLiked = false;
  bool _isRegistered = false;

  @override
  void initState() {
    super.initState();
    // Симулюємо перевірку чи користувач вже зареєстрований
    _isRegistered = widget.event.currentParticipants > 15;
  }

  @override
  Widget build(BuildContext context) {
    // Брендові кольори
    const Color primary = Color(0xFF2E7D32);
    const Color secondary = Color(0xFFFF7043);
    const Color accent = Color(0xFF42A5F5);

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
                      widget.event.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleLike,
                    icon: Icon(
                      _isLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                      color: _isLiked ? Colors.red : primary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Контент
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Статус івенту
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getStatusIcon(widget.event.status),
                                color: _getStatusColor(widget.event.status),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                widget.event.status.displayName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _getStatusColor(widget.event.status),
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
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  widget.event.category,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: accent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (widget.event.isUpcoming) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.clock,
                                    color: secondary,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'До початку: ${widget.event.formattedTimeUntilStart}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Опис
                    _buildSection(
                      title: 'Опис',
                      icon: FontAwesomeIcons.infoCircle,
                      child: Text(
                        widget.event.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Дата та час
                    _buildSection(
                      title: 'Дата та час',
                      icon: FontAwesomeIcons.calendar,
                      child: Column(
                        children: [
                          _buildInfoRow(
                            icon: FontAwesomeIcons.calendar,
                            label: 'Дата',
                            value: '${widget.event.startDate.day}.${widget.event.startDate.month}.${widget.event.startDate.year}',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            icon: FontAwesomeIcons.clock,
                            label: 'Час',
                            value: '${widget.event.startDate.hour.toString().padLeft(2, '0')}:${widget.event.startDate.minute.toString().padLeft(2, '0')} - ${widget.event.endDate.hour.toString().padLeft(2, '0')}:${widget.event.endDate.minute.toString().padLeft(2, '0')}',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            icon: FontAwesomeIcons.locationDot,
                            label: 'Локація',
                            value: widget.event.location,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Учасники
                    _buildSection(
                      title: 'Учасники',
                      icon: FontAwesomeIcons.users,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Зареєстровано',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '${widget.event.currentParticipants}/${widget.event.maxParticipants}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: widget.event.fillLevel,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(primary),
                            minHeight: 8,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.event.hasAvailableSpots 
                                ? 'Залишилось ${widget.event.maxParticipants - widget.event.currentParticipants} місць'
                                : 'Івент повний',
                            style: TextStyle(
                              fontSize: 12,
                              color: widget.event.hasAvailableSpots ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Вимоги
                    _buildSection(
                      title: 'Вимоги',
                      icon: FontAwesomeIcons.listCheck,
                      child: Column(
                        children: widget.event.requirements.map((requirement) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.check,
                                  size: 14,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    requirement,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Організатор
                    _buildSection(
                      title: 'Організатор',
                      icon: FontAwesomeIcons.userTie,
                      child: Column(
                        children: [
                          _buildInfoRow(
                            icon: FontAwesomeIcons.building,
                            label: 'Організація',
                            value: widget.event.organizer,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            icon: FontAwesomeIcons.phone,
                            label: 'Контакт',
                            value: widget.event.contactInfo,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Кнопки дій
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    const Color primary = Color(0xFF2E7D32);
    const Color secondary = Color(0xFFFF7043);
    
    if (widget.event.isCompleted) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          children: [
            Icon(
              FontAwesomeIcons.checkCircle,
              color: Colors.green,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'Івент завершено',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Дякуємо за участь!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    if (!widget.event.hasAvailableSpots) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red[200]!),
        ),
        child: Column(
          children: [
            Icon(
              FontAwesomeIcons.userSlash,
              color: Colors.red,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'Івент повний',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'На жаль, всі місця зайняті',
              style: TextStyle(
                fontSize: 14,
                color: Colors.red[500],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Кнопка реєстрації/скасування
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isRegistered ? _cancelRegistration : _registerForEvent,
            icon: Icon(
              _isRegistered ? FontAwesomeIcons.userMinus : FontAwesomeIcons.userPlus,
              color: Colors.white,
            ),
            label: Text(
              _isRegistered ? 'Скасувати реєстрацію' : 'Зареєструватися',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isRegistered ? Colors.red : primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // Додаткові кнопки
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _shareEvent,
                icon: const Icon(FontAwesomeIcons.share),
                label: const Text('Поділитися'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primary,
                  side: BorderSide(color: primary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _openLocation,
                icon: const Icon(FontAwesomeIcons.mapLocationDot),
                label: const Text('На карті'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: secondary,
                  side: BorderSide(color: secondary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    const Color primary = Color(0xFF2E7D32);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isLiked ? 'Додано до улюблених' : 'Видалено з улюблених'),
        backgroundColor: _isLiked ? Colors.red : Colors.grey,
      ),
    );
  }

  void _registerForEvent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Підтвердження реєстрації'),
        content: Text('Ви впевнені, що хочете зареєструватися на "${widget.event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Скасувати'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isRegistered = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Успішно зареєстровано на ${widget.event.title}!'),
                  backgroundColor: const Color(0xFF2E7D32),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
            ),
            child: const Text('Підтвердити'),
          ),
        ],
      ),
    );
  }

  void _cancelRegistration() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Скасування реєстрації'),
        content: Text('Ви впевнені, що хочете скасувати реєстрацію на "${widget.event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Скасувати'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isRegistered = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Реєстрацію скасовано'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Підтвердити'),
          ),
        ],
      ),
    );
  }

  void _shareEvent() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Поділяємося "${widget.event.title}"'),
        backgroundColor: const Color(0xFF42A5F5),
      ),
    );
  }

  void _openLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Відкриваємо локацію: ${widget.event.location}'),
        backgroundColor: const Color(0xFFFF7043),
      ),
    );
  }

  IconData _getStatusIcon(EventStatus status) {
    switch (status) {
      case EventStatus.upcoming:
        return FontAwesomeIcons.clock;
      case EventStatus.ongoing:
        return FontAwesomeIcons.play;
      case EventStatus.completed:
        return FontAwesomeIcons.checkCircle;
      case EventStatus.cancelled:
        return FontAwesomeIcons.xmarkCircle;
    }
  }

  Color _getStatusColor(EventStatus status) {
    switch (status) {
      case EventStatus.upcoming:
        return const Color(0xFFFF7043);
      case EventStatus.ongoing:
        return const Color(0xFF42A5F5);
      case EventStatus.completed:
        return Colors.green;
      case EventStatus.cancelled:
        return Colors.red;
    }
  }
}