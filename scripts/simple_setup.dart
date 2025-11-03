import 'dart:io';

void main() async {
  print('🔧 Просте налаштування проекту...');
  
  // Перевіряємо чи існує .env файл
  final envFile = File('.env');
  if (!envFile.existsSync()) {
    print('❌ Файл .env не знайдено!');
    print('📋 Створюємо .env файл з прикладу...');
    
    // Створюємо .env файл з env.example
    final envExample = File('env.example');
    if (envExample.existsSync()) {
      final content = await envExample.readAsString();
      await envFile.writeAsString(content);
      print('✅ Файл .env створено з env.example');
    } else {
      print('❌ Файл env.example також не знайдено!');
      exit(1);
    }
  } else {
    print('✅ Файл .env знайдено');
  }
  
  // Встановлюємо Flutter залежності
  print('📦 Встановлюємо Flutter залежності...');
  final flutterResult = await Process.run('flutter', ['pub', 'get']);
  if (flutterResult.exitCode != 0) {
    print('❌ Помилка встановлення Flutter залежностей:');
    print(flutterResult.stderr);
  } else {
    print('✅ Flutter залежності встановлено');
  }
  
  print('🎉 Просте налаштування завершено!');
  print('📝 Важливо: Відредагуйте .env файл та встановіть правильні Supabase credentials');
  print('📝 Формат DATABASE_URL: postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres');
  print('📝 Потім запустіть: dart run scripts/setup_db.dart для повного налаштування');
}
