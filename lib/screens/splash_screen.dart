import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../services/connectivity_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final connectivity = Provider.of<ConnectivityService>(context, listen: false);
    try {
      // Захист від зависань: максимум 3 секунди на ініціалізацію
      await Future.any([
        connectivity.initialize(),
        Future.delayed(const Duration(milliseconds: 300)), // не блокуємо UI
      ]);

      await Future.any([
        auth.initialize(),
        Future.delayed(const Duration(seconds: 3)),
      ]);

      if (!mounted) return;

      final isOnline = connectivity.isOnline;
      final isLogged = auth.isLoggedIn;

      if (isLogged) {
        if (!isOnline) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Немає підключення до інтернету. Деякі функції можуть бути недоступні.'),
            ),
          );
        }
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (_) {
      if (!mounted) return;
      // У разі будь-якої помилки — відправляємо на логін
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF2E7D32);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(color: primary),
            SizedBox(height: 16),
            Text('Завантаження...'),
          ],
        ),
      ),
    );
  }
}


