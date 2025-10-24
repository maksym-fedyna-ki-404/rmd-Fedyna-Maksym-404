import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  static const Color primary = Color(0xFF2E7D32);
  static const Color accent = Color(0xFF42A5F5);

  final List<Map<String, dynamic>> _faqItems = [
    {
      'category': 'Загальні питання',
      'question': 'Як зареєструватися в додатку?',
      'answer': 'Для реєстрації перейдіть на екран входу та натисніть "Зареєструватися". Заповніть необхідні дані та підтвердіть свою пошту.',
    },
    {
      'category': 'Загальні питання',
      'question': 'Як знайти івенти?',
      'answer': 'Ви можете знайти івенти на вкладці "Заходи" або на "Карті". Використовуйте фільтри для пошуку за категоріями та датами.',
    },
    {
      'category': 'Профіль',
      'question': 'Як змінити фото профілю?',
      'answer': 'На сторінці "Профіль" натисніть на іконку камери біля вашого фото. Ви зможете вибрати фото з галереї або зробити нове.',
    },
    {
      'category': 'Профіль',
      'question': 'Як оновити особисту інформацію?',
      'answer': 'На сторінці "Профіль" натисніть "Редагувати профіль". Там ви зможете змінити ім\'я, email, телефон, місто та інтереси.',
    },
    {
      'category': 'Рейтинг',
      'question': 'Як працює система рейтингу?',
      'answer': 'Ваш рейтинг зростає з кількістю відвіданих івентів. Кожен рівень (Новачок, Волонтер, Чемпіон тощо) вимагає певної кількості відвіданих подій.',
    },
    {
      'category': 'Рейтинг',
      'question': 'Що дає вищий рівень?',
      'answer': 'Вищі рівні відкривають доступ до ексклюзивних івентів, спеціальних нагород та визнання в спільноті волонтерів.',
    },
    {
      'category': 'Сповіщення',
      'question': 'Як налаштувати сповіщення?',
      'answer': 'Перейдіть до "Профіль" -> "Налаштування" -> "Приватність". Там ви зможете увімкнути або вимкнути push- та email-сповіщення.',
    },
    {
      'category': 'Карта',
      'question': 'Чому карта не відображається?',
      'answer': 'Переконайтеся, що у вас є підключення до інтернету. Якщо проблема зберігається, можливо, потрібно оновити Google Maps API ключ.',
    },
    {
      'category': 'Контакти',
      'question': 'Як зв\'язатися зі службою підтримки?',
      'answer': 'Ви можете написати нам на email: support@volunteerevent.com або в Telegram: @VolunteerEventSupport.',
    },
  ];

  String _searchQuery = '';
  String? _selectedCategory;

  List<String> get _categories => _faqItems.map((item) => item['category'] as String).toSet().toList();

  List<Map<String, dynamic>> get _filteredFaqItems {
    return _faqItems.where((item) {
      final matchesCategory = _selectedCategory == null || item['category'] == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          (item['question'] as String).toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (item['answer'] as String).toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@volunteerevent.com',
      queryParameters: {'subject': 'Питання щодо додатку Volunteer Event'},
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не вдалося відкрити поштовий клієнт')),
      );
    }
  }

  Future<void> _launchTelegram() async {
    final Uri telegramLaunchUri = Uri.parse('https://t.me/VolunteerEventSupport');
    if (await canLaunchUrl(telegramLaunchUri)) {
      await launchUrl(telegramLaunchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не вдалося відкрити Telegram')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // Кастомний хедер
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    color: primary,
                  ),
                  Expanded(
                    child: Text(
                      'Допомога та FAQ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // Для балансу
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Часті питання',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Пошук по питаннях',
                            prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass, color: primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: primary, width: 2),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              FilterChip(
                                label: const Text('Всі категорії'),
                                selected: _selectedCategory == null,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedCategory = null;
                                  });
                                },
                                selectedColor: primary.withOpacity(0.2),
                                checkmarkColor: primary,
                                labelStyle: TextStyle(
                                  color: _selectedCategory == null ? primary : Colors.grey[700],
                                  fontWeight: _selectedCategory == null ? FontWeight.bold : FontWeight.normal,
                                ),
                                side: BorderSide(
                                  color: _selectedCategory == null ? primary : Colors.grey[400]!,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ..._categories.map((category) {
                                final isSelected = _selectedCategory == category;
                                return FilterChip(
                                  label: Text(category),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedCategory = selected ? category : null;
                                    });
                                  },
                                  selectedColor: primary.withOpacity(0.2),
                                  checkmarkColor: primary,
                                  labelStyle: TextStyle(
                                    color: isSelected ? primary : Colors.grey[700],
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                  side: BorderSide(
                                    color: isSelected ? primary : Colors.grey[400]!,
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _filteredFaqItems.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.circleQuestion,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Нічого не знайдено',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Спробуйте змінити запит або фільтри',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _filteredFaqItems.length,
                            itemBuilder: (context, index) {
                              final item = _filteredFaqItems[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ExpansionTile(
                                  leading: Icon(FontAwesomeIcons.circleInfo, color: accent),
                                  title: Text(
                                    item['question'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16, bottom: 12),
                                      child: Text(
                                        item['answer'],
                                        style: TextStyle(color: Colors.grey[700]),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  // Контакти
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Зв\'язатися з нами',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildContactButton(
                          icon: FontAwesomeIcons.envelope,
                          text: 'support@volunteerevent.com',
                          onTap: _launchEmail,
                          color: primary,
                        ),
                        const SizedBox(height: 8),
                        _buildContactButton(
                          icon: FontAwesomeIcons.telegram,
                          text: '@VolunteerEventSupport',
                          onTap: _launchTelegram,
                          color: accent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}