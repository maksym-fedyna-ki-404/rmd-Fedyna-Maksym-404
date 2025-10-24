import 'dart:io';

void main() async {
  print('🔧 Налаштування бази даних...');
  
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
  }
  
  print('✅ Файл .env знайдено');
  
  // Генеруємо Prisma клієнт
  print('🔨 Генеруємо Prisma клієнт...');
  final generateResult = await Process.run('npx', ['prisma', 'generate']);
  if (generateResult.exitCode != 0) {
    print('❌ Помилка генерації Prisma клієнта:');
    print(generateResult.stderr);
    print('⚠️  Продовжуємо без Prisma міграцій...');
  } else {
    print('✅ Prisma клієнт згенеровано');
  }
  
  // Спробуємо створити міграцію, але не зупиняємося при помилці
  print('📊 Намагаємося створити міграцію бази даних...');
  final migrateResult = await Process.run('npx', ['prisma', 'migrate', 'dev', '--name', 'init']);
  if (migrateResult.exitCode != 0) {
    print('⚠️  Помилка створення міграції (це нормально для першого запуску):');
    print(migrateResult.stderr);
    print('💡 Спробуємо альтернативний спосіб...');
    
    // Спробуємо db push замість migrate
    print('🔄 Використовуємо db push...');
    final pushResult = await Process.run('npx', ['prisma', 'db', 'push']);
    if (pushResult.exitCode != 0) {
      print('⚠️  Помилка db push:');
      print(pushResult.stderr);
      print('📝 Можливо, потрібно налаштувати DATABASE_URL в .env файлі');
    } else {
      print('✅ База даних налаштована через db push');
    }
  } else {
    print('✅ Міграція створена');
  }
  
  print('🎉 Налаштування завершено!');
  print('📝 Важливо: Перевірте .env файл та налаштуйте правильні Supabase credentials');
  print('📝 Потім запустіть: npm run db:studio для перегляду бази даних');
}
