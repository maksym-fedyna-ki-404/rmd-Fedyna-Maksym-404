import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsMapScreen extends StatefulWidget {
  const EventsMapScreen({super.key});

  @override
  State<EventsMapScreen> createState() => _EventsMapScreenState();
}

class _EventsMapScreenState extends State<EventsMapScreen> {
  // Брендові кольори
  static const Color primary = Color(0xFF2E7D32);
  static const Color secondary = Color(0xFFFF7043);
  static const Color accent = Color(0xFF42A5F5);

  // Контролер карти
  GoogleMapController? _mapController;

  // Центр карти (Львів)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(49.8397, 24.0297),
    zoom: 12.0,
  );

  // Мокові дані для демонстрації
  final List<Map<String, dynamic>> events = [
    {
      'title': 'Прибирання парку Шевченка',
      'date': '15 грудня, 10:00',
      'location': 'Парк ім. Т.Г. Шевченка, Львів',
      'lat': 49.8397,
      'lng': 24.0297,
      'description': 'Допоможемо прибрати парк та зробити його чистішим',
      'category': 'Екологія',
    },
    {
      'title': 'Допомога притулку для тварин',
      'date': '18 грудня, 14:00',
      'location': 'Притулок "Друзі тварин", Львів',
      'lat': 49.8300,
      'lng': 24.0100,
      'description': 'Потрібна допомога з годуванням та доглядом за тваринами',
      'category': 'Допомога тваринам',
    },
    {
      'title': 'Роздача їжі бездомним',
      'date': '20 грудня, 12:00',
      'location': 'Центр міста, Львів',
      'lat': 49.8419,
      'lng': 24.0315,
      'description': 'Допоможемо роздати гарячу їжу тим, хто цього потребує',
      'category': 'Соціальна допомога',
    },
    {
      'title': 'Навчання дітей англійської',
      'date': '22 грудня, 16:00',
      'location': 'Бібліотека ім. Франка, Львів',
      'lat': 49.8444,
      'lng': 24.0264,
      'description': 'Допоможемо дітям з вивченням англійської мови',
      'category': 'Освіта',
    },
  ];

  // Маркери для карти
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    _markers = events.map((event) {
      return Marker(
        markerId: MarkerId(event['title']),
        position: LatLng(event['lat'], event['lng']),
        infoWindow: InfoWindow(
          title: event['title'],
          snippet: event['description'],
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          _getMarkerColor(event['category']),
        ),
      );
    }).toSet();
  }

  double _getMarkerColor(String category) {
    switch (category) {
      case 'Екологія':
        return BitmapDescriptor.hueGreen;
      case 'Допомога тваринам':
        return BitmapDescriptor.hueOrange;
      case 'Соціальна допомога':
        return BitmapDescriptor.hueRed;
      case 'Освіта':
        return BitmapDescriptor.hueBlue;
      default:
        return BitmapDescriptor.hueViolet;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _showEventsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Заголовок
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Івенти на карті',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            // Список івентів
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
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
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          FontAwesomeIcons.mapPin,
                          color: primary,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        event['title'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event['location'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            event['date'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () => _openInAppleMaps(event['lat'], event['lng']),
                        icon: Icon(
                          FontAwesomeIcons.locationArrow,
                          color: accent,
                          size: 16,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _goToEvent(event['lat'], event['lng']);
                      },
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

  void _goToEvent(double lat, double lng) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(lat, lng),
        16.0,
      ),
    );
  }

  void _openInAppleMaps(double lat, double lng) async {
    final url = 'https://maps.apple.com/?q=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // Заголовок та кнопка
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Івенти на карті',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  IconButton(
                    onPressed: _showEventsBottomSheet,
                    icon: Icon(
                      FontAwesomeIcons.list,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ),
            // Карта
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: _initialPosition,
                    markers: _markers,
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: true,
                    mapToolbarEnabled: false,
                    onTap: (LatLng position) {
                      // Можна додати функціональність для додавання нових івентів
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}