import 'dart:io';

void main() async {
  print('🔍 Тестування підключення до Supabase...');
  
  try {
    // Читаємо .env файл
    final envFile = File('.env');
    if (!envFile.existsSync()) {
      print('❌ Файл .env не знайдено!');
      exit(1);
    }
    
    final envContent = await envFile.readAsString();
    final lines = envContent.split('\n');
    
    String? supabaseUrl;
    String? supabaseAnonKey;
    
    for (final line in lines) {
      if (line.startsWith('SUPABASE_URL=')) {
        supabaseUrl = line.substring('SUPABASE_URL='.length).trim();
      } else if (line.startsWith('SUPABASE_ANON_KEY=')) {
        supabaseAnonKey = line.substring('SUPABASE_ANON_KEY='.length).trim();
      }
    }
    
    print('📍 Supabase URL: $supabaseUrl');
    print('🔑 Anon Key: ${supabaseAnonKey?.substring(0, 20)}...');
    
    if (supabaseUrl == null || supabaseAnonKey == null) {
      print('❌ Відсутні Supabase credentials в .env файлі');
      exit(1);
    }
    
    if (supabaseUrl.contains('your-project') || supabaseAnonKey.contains('your-anon-key')) {
      print('❌ Використовуються placeholder значення!');
      print('📝 Оновіть .env файл з реальними Supabase credentials');
      exit(1);
    }
    
    print('✅ Supabase credentials налаштовані правильно');
    print('🎉 Тестування завершено успішно!');
    print('📝 Тепер ви можете запустити Flutter додаток');
    
  } catch (e) {
    print('❌ Помилка: $e');
    exit(1);
  }
}
