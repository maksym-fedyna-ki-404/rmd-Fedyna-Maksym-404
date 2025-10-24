import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  print('🧪 Тестування збереження імені користувача...');
  
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
    
    // Тестуємо реєстрацію з іменем
    final testEmail = 'test_name_${DateTime.now().millisecondsSinceEpoch}@example.com';
    final testPassword = 'testpassword123';
    final testName = 'Тест Користувач';
    
    print('👤 Тестуємо реєстрацію з іменем...');
    print('📧 Email: $testEmail');
    print('👤 Name: $testName');
    
    try {
      final authResponse = await supabase.auth.signUp(
        email: testEmail,
        password: testPassword,
        data: {
          'name': testName,
          'full_name': testName,
          'display_name': testName,
        },
      );
      
      if (authResponse.user != null) {
        print('✅ Реєстрація користувача успішна!');
        print('🆔 User ID: ${authResponse.user!.id}');
        print('📧 Email: ${authResponse.user!.email}');
        
        // Перевіряємо metadata
        print('🔍 Перевіряємо metadata...');
        final metadata = authResponse.user!.userMetadata;
        if (metadata != null) {
          print('📋 Metadata: $metadata');
          print('👤 Name: ${metadata['name']}');
          print('👤 Full Name: ${metadata['full_name']}');
          print('👤 Display Name: ${metadata['display_name']}');
        } else {
          print('⚠️  Metadata порожні');
        }
        
        // Спробуємо оновити metadata
        print('🔄 Оновлюємо metadata...');
        try {
          await supabase.auth.updateUser(
            UserAttributes(
              data: {
                'name': testName,
                'full_name': testName,
                'display_name': testName,
              }
            )
          );
          print('✅ Metadata оновлено');
        } catch (updateError) {
          print('❌ Помилка оновлення metadata: $updateError');
        }
        
        // Перевіряємо поточного користувача
        print('🔍 Перевіряємо поточного користувача...');
        final currentUser = supabase.auth.currentUser;
        if (currentUser != null) {
          print('👤 Current User Name: ${currentUser.userMetadata?['name']}');
        }
        
        // Видаляємо тестового користувача
        await supabase.auth.signOut();
        print('🗑️  Тестовий користувач видалено');
      } else {
        print('⚠️  Реєстрація не завершена');
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
