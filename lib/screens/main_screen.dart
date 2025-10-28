import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'events_list_screen.dart';
import 'events_map_screen.dart';
import 'profile_screen.dart';
import 'dashboard_screen.dart';
import 'upcoming_events_screen.dart';
import '../providers/providers.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const EventsListScreen(),
    const UpcomingEventsScreen(),
    const EventsMapScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Ініціалізуємо AuthProvider при запуску головної сторінки
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).initialize();
      // Перевіряємо аргументи
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      if (args != null && args['tab'] != null) {
        setState(() => _currentIndex = args['tab'] as int);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: const Color(0xFF2E7D32), // Брендовий зелений
            unselectedItemColor: Colors.grey[600],
            showSelectedLabels: false, // Приховуємо підписи для вибраного табу
            showUnselectedLabels: false, // Приховуємо підписи для невибраних табів
            items: const [
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.home, size: 20),
                label: 'Головна',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.list, size: 20),
                label: 'Заходи',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.calendarCheck, size: 20),
                label: 'Мої події',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.map, size: 20),
                label: 'Карта',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.user, size: 20),
                label: 'Профіль',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
