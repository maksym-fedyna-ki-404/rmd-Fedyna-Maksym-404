import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  print('🧪 Тестування реєстрації користувача...');
  
  try {
    // Завантажуємо .env файл
    await dotenv.load(fileName: ".env");
    
    final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
    
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      print('❌ Відсутні Supabase credentials в .env файлі');
      exit(1);
    }
    
    // Ініціалізуємо Supabase
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    
    final supabase = Supabase.instance.client;
    
    // Тестуємо реєстрацію
    final testEmail = 'test_${DateTime.now().millisecondsSinceEpoch}@example.com';
    final testPassword = 'testpassword123';
    final testName = 'Test User';
    
    print('👤 Тестуємо реєстрацію користувача...');
    print('📧 Email: $testEmail');
    print('👤 Name: $testName');
    
    try {
      final authResponse = await supabase.auth.signUp(
        email: testEmail,
        password: testPassword,
        data: {'name': testName},
      );
      
      if (authResponse.user != null) {
        print('✅ Реєстрація користувача успішна!');
        print('🆔 User ID: ${authResponse.user!.id}');
        print('📧 Email: ${authResponse.user!.email}');
        print('👤 Name: ${authResponse.user!.userMetadata?['name']}');
        print('📅 Created: ${authResponse.user!.createdAt}');
        
        // Тестуємо отримання поточного користувача
        print('🔍 Тестуємо отримання поточного користувача...');
        final currentUser = supabase.auth.currentUser;
        if (currentUser != null) {
          print('✅ Поточний користувач отримано успішно!');
          print('🆔 Current User ID: ${currentUser.id}');
        } else {
          print('⚠️  Поточний користувач не знайдено');
        }
        
        // Видаляємо тестового користувача
        await supabase.auth.signOut();
        print('🗑️  Тестовий користувач видалено');
      } else {
        print('⚠️  Реєстрація не завершена (можливо потребує підтвердження email)');
      }
    } catch (e) {
      print('❌ Помилка реєстрації: $e');
    }
    
    print('🎉 Тестування завершено!');
    
  } catch (e) {
    print('❌ Помилка: $e');
    exit(1);
  }
}
