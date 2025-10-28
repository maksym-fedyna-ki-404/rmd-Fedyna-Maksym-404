// dart run scripts/seed_events.dart
// Requires env vars: SUPABASE_URL, SUPABASE_ANON_KEY
// Example:
// SUPABASE_URL=https://xxx.supabase.co \
// SUPABASE_ANON_KEY=eyJ... \
// dart run scripts/seed_events.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> main() async {
  // 1) беремо з process env
  var baseUrl = Platform.environment['SUPABASE_URL'];
  var anonKey = Platform.environment['SUPABASE_ANON_KEY'];

  // 2) якщо нема – пробуємо прочитати з .env у корені
  if (baseUrl == null || anonKey == null) {
    final env = await _loadEnvFile('../.env');
    baseUrl ??= env['SUPABASE_URL'];
    anonKey ??= env['SUPABASE_ANON_KEY'];
  }

  if (baseUrl == null || anonKey == null) {
    stderr.writeln('Please set SUPABASE_URL and SUPABASE_ANON_KEY environment variables');
    stderr.writeln('You can either:');
    stderr.writeln('  1) export SUPABASE_URL=... and SUPABASE_ANON_KEY=...');
    stderr.writeln('  2) or put them into .env file at project root');
    exitCode = 1;
    return;
  }

  final client = _SupabaseRest(baseUrl: baseUrl, anonKey: anonKey);

  final now = DateTime.now();

  Map<String, dynamic> buildEvent({
    required String title,
    required String description,
    required DateTime start,
    required DateTime end,
    required String location,
    required String category,
    required String organizer,
    required String contact,
    required double lat,
    required double lng,
    int max = 30,
    int current = 0,
    String status = 'upcoming',
    List<String> requirements = const [],
    String? imageUrl,
  }) {
    return {
      'title': title,
      'description': description,
      'start_date': start.toIso8601String(),
      'end_date': end.toIso8601String(),
      'location': location,
      'category': category,
      'image_url': imageUrl,
      'max_participants': max,
      'current_participants': current,
      'status': status,
      'requirements': requirements,
      'organizer': organizer,
      'contact_info': contact,
      'latitude': lat,
      'longitude': lng,
    };
  }

  final events = <Map<String, dynamic>>[
    // Майбутні (upcoming)
    buildEvent(
      title: 'Прибирання парку Шевченка',
      description: 'Допоможемо прибрати парк та зробити його чистішим для всіх львів\'ян.',
      start: now.add(const Duration(days: 3, hours: 2)),
      end: now.add(const Duration(days: 3, hours: 5)),
      location: 'Парк ім. Т.Г. Шевченка, Львів',
      category: 'Екологія',
      organizer: 'Зелений Львів',
      contact: '+380501234567',
      lat: 49.8397,
      lng: 24.0297,
      requirements: const ['Робочі рукавички', 'Зручний одяг'],
    ),
    buildEvent(
      title: 'Допомога притулку для тварин',
      description: 'Потрібні волонтери для годування та вигулу тварин.',
      start: now.add(const Duration(days: 5, hours: 1)),
      end: now.add(const Duration(days: 5, hours: 4)),
      location: 'Притулок "Друзі тварин", Львів',
      category: 'Тварини',
      organizer: 'Притулок "Друзі тварин"',
      contact: '+380672345678',
      lat: 49.85,
      lng: 24.01,
      requirements: const ['Любов до тварин'],
    ),
    buildEvent(
      title: 'Роздача їжі малозабезпеченим',
      description: 'Підготуємо і роздамо гарячу їжу у центрі міста.',
      start: now.add(const Duration(days: 2, hours: 2)),
      end: now.add(const Duration(days: 2, hours: 5)),
      location: 'Площа Ринок, Львів',
      category: 'Соціальна допомога',
      organizer: 'Добрі Справи',
      contact: '+380931112233',
      lat: 49.8419,
      lng: 24.0315,
      requirements: const ['Теплий одяг'],
    ),
    buildEvent(
      title: 'Посадка дерев у Сихові',
      description: 'Висаджуємо молоді дерева у дворі школи.',
      start: now.add(const Duration(days: 7, hours: 10)),
      end: now.add(const Duration(days: 7, hours: 13)),
      location: 'Сихівський район, Львів',
      category: 'Екологія',
      organizer: 'Еко Ініціатива',
      contact: '+380964567890',
      lat: 49.7900,
      lng: 24.0500,
    ),
    buildEvent(
      title: 'Курс англійської для дітей',
      description: 'Проводимо інтерактивні уроки англійської.',
      start: now.add(const Duration(days: 9, hours: 16)),
      end: now.add(const Duration(days: 9, hours: 18)),
      location: 'Бібліотека ім. Франка, Львів',
      category: 'Освіта',
      organizer: 'Освітній Хаб',
      contact: '+380677778899',
      lat: 49.8444,
      lng: 24.0264,
      requirements: const ['Базова англійська'],
    ),
    buildEvent(
      title: 'Збір крові для лікарні',
      description: 'Організовуємо донорську акцію разом з лікарнею.',
      start: now.add(const Duration(days: 4, hours: 9)),
      end: now.add(const Duration(days: 4, hours: 12)),
      location: 'Обласна лікарня, Львів',
      category: 'Медицина',
      organizer: 'Червоний Хрест',
      contact: '+380503334455',
      lat: 49.8455,
      lng: 24.0250,
      requirements: const ['Паспорт'],
    ),
    buildEvent(
      title: 'Прибирання на Високому Замку',
      description: 'Зробимо територію чистішою та привабливішою.',
      start: now.add(const Duration(days: 1, hours: 9)),
      end: now.add(const Duration(days: 1, hours: 12)),
      location: 'Парк Високий Замок, Львів',
      category: 'Екологія',
      organizer: 'Львів Зелений',
      contact: '+380991112233',
      lat: 49.8483,
      lng: 24.0369,
    ),
    buildEvent(
      title: 'Ремонт шкільного спортзалу',
      description: 'Фарбування та дрібні ремонтні роботи.',
      start: now.add(const Duration(days: 6, hours: 10)),
      end: now.add(const Duration(days: 6, hours: 15)),
      location: 'Школа №38, Львів',
      category: 'Культура',
      organizer: 'Батьківський комітет',
      contact: '+380631234567',
      lat: 49.8305,
      lng: 24.0002,
    ),
    buildEvent(
      title: 'Збір одягу для переселенців',
      description: 'Приймаємо та сортуємо одяг для ВПО.',
      start: now.add(const Duration(days: 8, hours: 11)),
      end: now.add(const Duration(days: 8, hours: 15)),
      location: 'Центр допомоги, Львів',
      category: 'Соціальна допомога',
      organizer: 'Разом Сильніші',
      contact: '+380935551122',
      lat: 49.8420,
      lng: 24.0300,
    ),
    buildEvent(
      title: 'Фандрейз ярмарок',
      description: 'Благодійний ярмарок на підтримку притулку.',
      start: now.add(const Duration(days: 10, hours: 12)),
      end: now.add(const Duration(days: 10, hours: 16)),
      location: 'Парк Культури, Львів',
      category: 'Культура',
      organizer: 'Друзі Тварин',
      contact: '+380939991122',
      lat: 49.8290,
      lng: 24.0190,
    ),

    // Події, що тривають (ongoing)
    buildEvent(
      title: 'Марафон прибирання дворів',
      description: 'Безперервна акція протягом дня.',
      start: now.subtract(const Duration(hours: 1)),
      end: now.add(const Duration(hours: 3)),
      location: 'Різні локації, Львів',
      category: 'Екологія',
      organizer: 'Чисте Місто',
      contact: '+380971112244',
      lat: 49.84,
      lng: 24.03,
      status: 'ongoing',
    ),

    // Минулі (completed)
    buildEvent(
      title: 'Минуле прибирання парку Стрийський',
      description: 'Прибрали територію парку разом з мешканцями.',
      start: now.subtract(const Duration(days: 5, hours: 3)),
      end: now.subtract(const Duration(days: 5)),
      location: 'Стрийський парк, Львів',
      category: 'Екологія',
      organizer: 'Еко Львів',
      contact: '+380501234000',
      lat: 49.8250,
      lng: 24.0240,
      status: 'completed',
      current: 25,
      max: 25,
    ),
    buildEvent(
      title: 'Минулий збір коштів для лікарні',
      description: 'Зібрали медикаменти та кошти.',
      start: now.subtract(const Duration(days: 12, hours: 4)),
      end: now.subtract(const Duration(days: 12, hours: 1)),
      location: 'Площа Ринок, Львів',
      category: 'Медицина',
      organizer: 'Волонтери Львова',
      contact: '+380961234000',
      lat: 49.8425,
      lng: 24.0320,
      status: 'completed',
      current: 40,
      max: 40,
    ),
    buildEvent(
      title: 'Минулий урок інформатики',
      description: 'Комп\'ютерна грамотність для підлітків.',
      start: now.subtract(const Duration(days: 2, hours: 3)),
      end: now.subtract(const Duration(days: 2, hours: 1)),
      location: 'IT Hub, Львів',
      category: 'Освіта',
      organizer: 'IT-Освіта',
      contact: '+380991231231',
      lat: 49.8450,
      lng: 24.0200,
      status: 'completed',
      current: 15,
      max: 20,
    ),
    buildEvent(
      title: 'Минуле тренування з футболу для дітей',
      description: 'Спортивні активності для дітей.',
      start: now.subtract(const Duration(days: 1, hours: 4)),
      end: now.subtract(const Duration(days: 1, hours: 2)),
      location: 'Стадіон СКА, Львів',
      category: 'Спорт',
      organizer: 'Футбол Разом',
      contact: '+380981111111',
      lat: 49.8500,
      lng: 24.0000,
      status: 'completed',
      current: 20,
      max: 25,
    ),
    buildEvent(
      title: 'Минуле приготування обідів',
      description: 'Готували обіди для літніх людей.',
      start: now.subtract(const Duration(days: 9, hours: 5)),
      end: now.subtract(const Duration(days: 9, hours: 2)),
      location: 'Кухня допомоги, Львів',
      category: 'Соціальна допомога',
      organizer: 'ДоброFood',
      contact: '+380971234567',
      lat: 49.8333,
      lng: 24.0333,
      status: 'completed',
      current: 18,
      max: 20,
    ),

    // Скасовані (cancelled)
    buildEvent(
      title: 'Скасований забіг благодійності',
      description: 'Подію скасовано через погодні умови.',
      start: now.add(const Duration(days: 1, hours: 8)),
      end: now.add(const Duration(days: 1, hours: 10)),
      location: 'Парк Культури, Львів',
      category: 'Спорт',
      organizer: 'RunLviv',
      contact: '+380991004400',
      lat: 49.8292,
      lng: 24.0201,
      status: 'cancelled',
    ),

    // Ще кілька майбутніх для різноманіття
    buildEvent(
      title: 'Велопробіг чистого міста',
      description: 'Велопробіг з прибиранням сміття по маршруту.',
      start: now.add(const Duration(days: 11, hours: 9)),
      end: now.add(const Duration(days: 11, hours: 12)),
      location: 'Проспект Свободи, Львів',
      category: 'Екологія',
      organizer: 'Вело Львів',
      contact: '+380994567321',
      lat: 49.8420,
      lng: 24.0280,
    ),
    buildEvent(
      title: 'Збір книжок для бібліотеки',
      description: 'Передаємо книжки у сільські бібліотеки.',
      start: now.add(const Duration(days: 12, hours: 13)),
      end: now.add(const Duration(days: 12, hours: 16)),
      location: 'Центральна бібліотека, Львів',
      category: 'Культура',
      organizer: 'Друзі Бібліотек',
      contact: '+380933456789',
      lat: 49.8400,
      lng: 24.0300,
    ),
    buildEvent(
      title: 'Вигул собак з притулку',
      description: 'Допоможемо вигулювати собак у парку.',
      start: now.add(const Duration(days: 4, hours: 15)),
      end: now.add(const Duration(days: 4, hours: 18)),
      location: 'Парк Знесіння, Львів',
      category: 'Тварини',
      organizer: 'Хвіст і Лапи',
      contact: '+380992223344',
      lat: 49.8600,
      lng: 24.0500,
    ),
    buildEvent(
      title: 'Майстер-клас з першої допомоги',
      description: 'Навчимо основам першої медичної допомоги.',
      start: now.add(const Duration(days: 13, hours: 10)),
      end: now.add(const Duration(days: 13, hours: 12)),
      location: 'Освітній центр, Львів',
      category: 'Медицина',
      organizer: 'SafeLife',
      contact: '+380971119988',
      lat: 49.8380,
      lng: 24.0220,
    ),
    buildEvent(
      title: 'Квест для дітей',
      description: 'Освітньо-розважальний квест для дітей.',
      start: now.add(const Duration(days: 15, hours: 12)),
      end: now.add(const Duration(days: 15, hours: 14)),
      location: 'Парк ім. І. Франка, Львів',
      category: 'Культура',
      organizer: 'Світ Дітей',
      contact: '+380931112200',
      lat: 49.8390,
      lng: 24.0230,
    ),
    buildEvent(
      title: 'Прибирання берега Полтви',
      description: 'Акція з прибирання берега річки.',
      start: now.add(const Duration(days: 16, hours: 9)),
      end: now.add(const Duration(days: 16, hours: 12)),
      location: 'Береги Полтви, Львів',
      category: 'Екологія',
      organizer: 'Чисті Ріки',
      contact: '+380935550011',
      lat: 49.8450,
      lng: 24.0100,
    ),
    buildEvent(
      title: 'Спортивний день на Сихові',
      description: 'Руханка, волейбол та естафети.',
      start: now.add(const Duration(days: 14, hours: 9)),
      end: now.add(const Duration(days: 14, hours: 13)),
      location: 'Сихів, Львів',
      category: 'Спорт',
      organizer: 'ActiveLviv',
      contact: '+380973333221',
      lat: 49.7905,
      lng: 24.0550,
    ),
  ];

  stdout.writeln('Seeding ${events.length} events...');
  for (final e in events) {
    final res = await client.insert('events', e);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      stdout.writeln('✓ Inserted: ${e['title']}');
    } else {
      stderr.writeln('✗ Failed: ${e['title']} -> ${res.statusCode} ${res.body}');
    }
  }
  stdout.writeln('Done.');
}

class _SupabaseRest {
  final String baseUrl;
  final String anonKey;

  _SupabaseRest({required this.baseUrl, required this.anonKey});

  Map<String, String> get _headers => {
        'apikey': anonKey,
        'Authorization': 'Bearer $anonKey',
        'Content-Type': 'application/json',
        'Prefer': 'return=representation',
      };

  Future<http.Response> insert(String table, Map<String, dynamic> row) {
    final url = Uri.parse('$baseUrl/rest/v1/$table');
    return http.post(url, headers: _headers, body: jsonEncode(row));
  }
}

Future<Map<String, String>> _loadEnvFile(String path) async {
  final file = File(path);
  if (!await file.exists()) {
    return {};
  }
  final lines = await file.readAsLines();
  final Map<String, String> data = {};
  for (final line in lines) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
    final idx = trimmed.indexOf('=');
    if (idx <= 0) continue;
    final key = trimmed.substring(0, idx).trim();
    var value = trimmed.substring(idx + 1).trim();
    if (value.startsWith('"') && value.endsWith('"') && value.length >= 2) {
      value = value.substring(1, value.length - 1);
    }
    if (value.startsWith('\'') && value.endsWith('\'') && value.length >= 2) {
      value = value.substring(1, value.length - 1);
    }
    data[key] = value;
  }
  return data;
}



