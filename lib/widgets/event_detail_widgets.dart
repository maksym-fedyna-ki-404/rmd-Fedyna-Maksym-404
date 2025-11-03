import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/event.dart';

class EventHeader extends StatelessWidget {
  final Event event;
  final bool isLiked;
  final VoidCallback onBack;
  final VoidCallback onToggleLike;
  
  const EventHeader({
    super.key,
    required this.event,
    required this.isLiked,
    required this.onBack,
    required this.onToggleLike,
  });

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF2E7D32);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back), color: primary),
          Expanded(
            child: Text(event.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primary), textAlign: TextAlign.center),
          ),
          IconButton(
            onPressed: onToggleLike,
            icon: Icon(isLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart, color: isLiked ? Colors.red : primary),
          ),
        ],
      ),
    );
  }
}

class EventImageSection extends StatelessWidget {
  final Event event;
  
  const EventImageSection({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    const Color accent = Color(0xFF42A5F5);
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(color: accent.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: event.imageUrl != null
          ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(event.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(FontAwesomeIcons.image, size: 48, color: accent.withOpacity(0.5))))
          : Center(child: Icon(FontAwesomeIcons.calendar, size: 64, color: accent.withOpacity(0.5))),
    );
  }
}

class EventInfoSection extends StatelessWidget {
  final Event event;
  
  const EventInfoSection({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF2E7D32);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(icon: FontAwesomeIcons.clock, label: 'Початок', value: '${event.startDate.day}.${event.startDate.month}.${event.startDate.year} ${event.startDate.hour}:${event.startDate.minute.toString().padLeft(2, '0')}'),
        const SizedBox(height: 8),
        _InfoRow(icon: FontAwesomeIcons.hourglassEnd, label: 'Закінчення', value: '${event.endDate.day}.${event.endDate.month}.${event.endDate.year} ${event.endDate.hour}:${event.endDate.minute.toString().padLeft(2, '0')}'),
        const SizedBox(height: 8),
        _InfoRow(icon: FontAwesomeIcons.mapMarkerAlt, label: 'Місце', value: event.location),
        const SizedBox(height: 8),
        _InfoRow(icon: FontAwesomeIcons.tag, label: 'Категорія', value: event.category),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF2E7D32);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 16, color: primary),
      const SizedBox(width: 8),
      Expanded(child: Text('$label: $value', style: TextStyle(fontSize: 14, color: Colors.grey[700]))),
    ]);
  }
}

class EventDescriptionSection extends StatelessWidget {
  final Event event;
  
  const EventDescriptionSection({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF2E7D32);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(FontAwesomeIcons.infoCircle, color: primary, size: 20), const SizedBox(width: 12), Text('Опис', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary))]),
      const SizedBox(height: 12),
      Text(event.description, style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5)),
    ]);
  }
}

class EventRequirementsSection extends StatelessWidget {
  final Event event;
  
  const EventRequirementsSection({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF2E7D32);
    const Color secondary = Color(0xFFFF7043);
    if (event.requirements.isEmpty) return const SizedBox();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(FontAwesomeIcons.listCheck, color: primary, size: 20), const SizedBox(width: 12), Text('Що потрібно взяти', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary))]),
      const SizedBox(height: 12),
      Wrap(spacing: 8, runSpacing: 8, children: event.requirements.map((req) {
        return Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: secondary.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: secondary.withOpacity(0.3))), child: Text(req, style: TextStyle(color: secondary, fontWeight: FontWeight.w600)));
      }).toList()),
    ]);
  }
}

