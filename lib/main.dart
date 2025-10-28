import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/screens.dart';
import 'services/services.dart';
import 'providers/providers.dart';
import 'config/supabase_config.dart';
import 'services/connectivity_service.dart';
import 'services/mqtt_service.dart';
import 'services/events_repository.dart';
import 'screens/splash_screen.dart';
import 'screens/mqtt_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Приховуємо debug повідомлення про overflow
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return Container(
      color: Colors.transparent,
      child: const SizedBox.shrink(),
    );
  };
  
  // Завантажуємо .env файл
  await SupabaseConfig.load();
  
  // Ініціалізуємо Supabase з змінними з .env
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  
  runApp(const VolunteerEventApp());
}

class VolunteerEventApp extends StatelessWidget {
  const VolunteerEventApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            AuthService(SupabaseUserRepository(Supabase.instance.client)),
          ),
        ),
        ChangeNotifierProvider(create: (_) => ConnectivityService()),
        ChangeNotifierProvider(create: (_) => MqttService()),
        Provider(create: (_) => EventsRepository(Supabase.instance.client)),
      ],
      child: MaterialApp(
        title: 'Волонтерські івенти Львова',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E7D32), // Основний зелений
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'Roboto',
          // Брендові кольори
          primaryColor: const Color(0xFF2E7D32), // Зелений
          secondaryHeaderColor: const Color(0xFFFF7043), // Помаранчевий
          focusColor: const Color(0xFF42A5F5), // Синій
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/main': (context) => const MainScreen(),
          '/notifications': (context) => const NotificationsScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/profile-edit': (context) => const ProfileEditScreen(),
          '/privacy': (context) => const PrivacyScreen(),
          '/help': (context) => const HelpScreen(),
          '/mqtt': (context) => const MqttScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}