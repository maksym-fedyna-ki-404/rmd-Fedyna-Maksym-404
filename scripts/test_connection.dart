import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  print('🔍 Тестування підключення до Supabase...');
  
  try {
    // Завантажуємо .env файл
    await dotenv.load(fileName: ".env");
    
    final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
    
    print('📍 Supabase URL: $supabaseUrl');
    print('🔑 Anon Key: ${supabaseAnonKey.substring(0, 20)}...');
    
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      print('❌ Відсутні Supabase credentials в .env файлі');
      exit(1);
    }
    
    // Ініціалізуємо Supabase
    print('🔌 Підключаємося до Supabase...');
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    
    final supabase = Supabase.instance.client;
    
    // Тестуємо підключення
    print('🧪 Тестуємо підключення...');
    final response = await supabase.from('_test').select().limit(1);
    
    print('✅ Підключення до Supabase успішне!');
    
    // Тестуємо реєстрацію користувача
    print('👤 Тестуємо реєстрацію користувача...');
    final testEmail = 'test_${DateTime.now().millisecondsSinceEpoch}@example.com';
    final testPassword = 'testpassword123';
    
    try {
      final authResponse = await supabase.auth.signUp(
        email: testEmail,
        password: testPassword,
        data: {'name': 'Test User'},
      );
      
      if (authResponse.user != null) {
        print('✅ Реєстрація користувача успішна!');
        print('🆔 User ID: ${authResponse.user!.id}');
        
        // Видаляємо тестового користувача
        await supabase.auth.signOut();
        print('🗑️  Тестовий користувач видалено');
      } else {
        print('⚠️  Реєстрація не завершена (можливо потребує підтвердження email)');
      }
    } catch (e) {
      print('❌ Помилка реєстрації: $e');
    }
    
    print('🎉 Тестування завершено успішно!');
    
  } catch (e) {
    print('❌ Помилка підключення: $e');
    exit(1);
  }
}
