import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  // Завантаження змінних з .env файлу
  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }

  // Отримання URL з .env файлу або fallback значення
  static String get supabaseUrl {
    return dotenv.env['SUPABASE_URL'] ?? 'https://your-project.supabase.co';
  }

  // Отримання anon key з .env файлу або fallback значення
  static String get supabaseAnonKey {
    return dotenv.env['SUPABASE_ANON_KEY'] ?? 'your-anon-key-here';
  }

  // Отримання DATABASE_URL для Prisma
  static String get databaseUrl {
    return dotenv.env['DATABASE_URL'] ?? '';
  }

  // Перевірка чи завантажені змінні
  static bool get isLoaded => dotenv.env.isNotEmpty;

  // Перевірка чи всі необхідні змінні налаштовані
  static bool get isConfigured => 
      supabaseUrl.isNotEmpty && 
      supabaseAnonKey.isNotEmpty && 
      databaseUrl.isNotEmpty;

  // Отримання всіх змінних для налагодження
  static Map<String, String> get allEnvVars => dotenv.env;

  // Демонстраційні значення (fallback)
  static const String demoUrl = 'https://your-project.supabase.co';
  static const String demoAnonKey = 'your-anon-key-here';
  
  // Повертає true якщо використовуються демо значення
  static bool get isUsingDemoValues => 
      supabaseUrl == demoUrl || supabaseAnonKey == demoAnonKey;
}
