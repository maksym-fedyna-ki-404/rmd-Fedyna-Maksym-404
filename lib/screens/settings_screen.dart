import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Брендові кольори
  static const Color primary = Color(0xFF2E7D32);

  // Налаштування
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'Українська';
  String _selectedDistance = '5 км';

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
                      'Налаштування',
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
            
            // Контент
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Сповіщення
                    _buildSection(
                      title: 'Сповіщення',
                      icon: FontAwesomeIcons.bell,
                      children: [
                        _buildSwitchTile(
                          title: 'Push-сповіщення',
                          subtitle: 'Отримувати сповіщення про нові івенти',
                          value: _notificationsEnabled,
                          onChanged: (value) {
                            setState(() {
                              _notificationsEnabled = value;
                            });
                          },
                        ),
                        _buildSwitchTile(
                          title: 'Нагадування про івенти',
                          subtitle: 'Нагадувати за годину до початку',
                          value: true,
                          onChanged: (value) {
                            // TODO: Зберегти налаштування
                          },
                        ),
                        _buildSwitchTile(
                          title: 'Електронна пошта',
                          subtitle: 'Отримувати щотижневі звіти',
                          value: false,
                          onChanged: (value) {
                            // TODO: Зберегти налаштування
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Локація
                    _buildSection(
                      title: 'Локація',
                      icon: FontAwesomeIcons.locationDot,
                      children: [
                        _buildSwitchTile(
                          title: 'Дозволити доступ до локації',
                          subtitle: 'Знаходити івенти поблизу',
                          value: _locationEnabled,
                          onChanged: (value) {
                            setState(() {
                              _locationEnabled = value;
                            });
                          },
                        ),
                        _buildListTile(
                          title: 'Радіус пошуку',
                          subtitle: _selectedDistance,
                          icon: FontAwesomeIcons.ruler,
                          onTap: () {
                            _showDistancePicker();
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Персоналізація
                    _buildSection(
                      title: 'Персоналізація',
                      icon: FontAwesomeIcons.palette,
                      children: [
                        _buildSwitchTile(
                          title: 'Темна тема',
                          subtitle: 'Використовувати темний режим',
                          value: _darkModeEnabled,
                          onChanged: (value) {
                            setState(() {
                              _darkModeEnabled = value;
                            });
                          },
                        ),
                        _buildListTile(
                          title: 'Мова',
                          subtitle: _selectedLanguage,
                          icon: FontAwesomeIcons.language,
                          onTap: () {
                            _showLanguagePicker();
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Приватність
                    _buildSection(
                      title: 'Приватність',
                      icon: FontAwesomeIcons.shield,
                      children: [
                        _buildListTile(
                          title: 'Політика конфіденційності',
                          subtitle: 'Як ми використовуємо ваші дані',
                          icon: FontAwesomeIcons.fileShield,
                          onTap: () {
                            // TODO: Відкрити політику конфіденційності
                          },
                        ),
                        _buildListTile(
                          title: 'Умови використання',
                          subtitle: 'Правила використання додатку',
                          icon: FontAwesomeIcons.fileContract,
                          onTap: () {
                            // TODO: Відкрити умови використання
                          },
                        ),
                        _buildListTile(
                          title: 'Експорт даних',
                          subtitle: 'Завантажити всі ваші дані',
                          icon: FontAwesomeIcons.download,
                          onTap: () {
                            // TODO: Експорт даних
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Функція експорту буде додана пізніше'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Додатково
                    _buildSection(
                      title: 'Додатково',
                      icon: FontAwesomeIcons.gear,
                      children: [
                        _buildListTile(
                          title: 'Очистити кеш',
                          subtitle: 'Звільнити місце на пристрої',
                          icon: FontAwesomeIcons.trash,
                          onTap: () {
                            _showClearCacheDialog();
                          },
                        ),
                        _buildListTile(
                          title: 'Про додаток',
                          subtitle: 'Версія 1.0.0',
                          icon: FontAwesomeIcons.infoCircle,
                          onTap: () {
                            _showAboutDialog();
                          },
                        ),
                        _buildListTile(
                          title: 'Зв\'язатися з підтримкою',
                          subtitle: 'Допомога та зворотний зв\'язок',
                          icon: FontAwesomeIcons.headset,
                          onTap: () {
                            // TODO: Відкрити підтримку
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Функція підтримки буде додана пізніше'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: primary,
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                FontAwesomeIcons.chevronRight,
                size: 14,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDistancePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Радіус пошуку',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
            const SizedBox(height: 20),
            ...['1 км', '3 км', '5 км', '10 км', '20 км'].map((distance) {
              return ListTile(
                title: Text(distance),
                trailing: _selectedDistance == distance
                    ? Icon(Icons.check, color: primary)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedDistance = distance;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Мова',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
            const SizedBox(height: 20),
            ...['Українська', 'English', 'Русский'].map((language) {
              return ListTile(
                title: Text(language),
                trailing: _selectedLanguage == language
                    ? Icon(Icons.check, color: primary)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedLanguage = language;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистити кеш'),
        content: const Text('Це дія видалить всі тимчасові файли та звільнить місце на пристрої. Продовжити?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Кеш очищено'),
                ),
              );
            },
            child: Text(
              'Очистити',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Волонтерські івенти Львова',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        FontAwesomeIcons.heart,
        color: primary,
        size: 48,
      ),
      children: [
        const Text('Додаток для пошуку та участі у волонтерських івентах у Львові.'),
        const SizedBox(height: 16),
        const Text('Розроблено з ❤️ для спільноти'),
      ],
    );
  }
}
