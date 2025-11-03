import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _allowNotifications = true;
  bool _allowLocationTracking = false;
  bool _allowProfileVisibility = true;
  bool _allowEventRecommendations = true;

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF2E7D32);

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
                      'Приватність',
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Заголовок
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
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
                        children: [
                          Icon(
                            FontAwesomeIcons.shield,
                            size: 48,
                            color: primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Налаштування приватності',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Керуйте своїми даними та приватністю',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Сповіщення
                    _buildPrivacyCard(
                      icon: FontAwesomeIcons.bell,
                      title: 'Сповіщення',
                      children: [
                        _buildSwitchTile(
                          title: 'Push-сповіщення',
                          subtitle: 'Отримувати сповіщення про нові івенти',
                          value: _allowNotifications,
                          onChanged: (value) => setState(() => _allowNotifications = value),
                        ),
                        _buildSwitchTile(
                          title: 'Email-сповіщення',
                          subtitle: 'Отримувати сповіщення на email',
                          value: _allowNotifications,
                          onChanged: (value) => setState(() => _allowNotifications = value),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Місцезнаходження
                    _buildPrivacyCard(
                      icon: FontAwesomeIcons.locationDot,
                      title: 'Місцезнаходження',
                      children: [
                        _buildSwitchTile(
                          title: 'Відстеження місцезнаходження',
                          subtitle: 'Дозволити доступ до GPS для пошуку близьких івентів',
                          value: _allowLocationTracking,
                          onChanged: (value) => setState(() => _allowLocationTracking = value),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Профіль
                    _buildPrivacyCard(
                      icon: FontAwesomeIcons.user,
                      title: 'Профіль',
                      children: [
                        _buildSwitchTile(
                          title: 'Видимість профілю',
                          subtitle: 'Дозволити іншим користувачам бачити мій профіль',
                          value: _allowProfileVisibility,
                          onChanged: (value) => setState(() => _allowProfileVisibility = value),
                        ),
                        _buildSwitchTile(
                          title: 'Рекомендації івентів',
                          subtitle: 'Отримувати персоналізовані рекомендації',
                          value: _allowEventRecommendations,
                          onChanged: (value) => setState(() => _allowEventRecommendations = value),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Дії
                    _buildActionCard(
                      icon: FontAwesomeIcons.fileExport,
                      title: 'Експорт даних',
                      subtitle: 'Завантажити копію ваших даних',
                      onTap: _exportData,
                    ),
                    const SizedBox(height: 12),
                    _buildActionCard(
                      icon: FontAwesomeIcons.userSlash,
                      title: 'Видалити акаунт',
                      subtitle: 'Видалити акаунт та всі дані',
                      onTap: _deleteAccount,
                      isDestructive: true,
                    ),
                    const SizedBox(height: 24),

                    // Політика конфіденційності
                    Center(
                      child: TextButton(
                        onPressed: _openPrivacyPolicy,
                        child: Text(
                          'Політика конфіденційності',
                          style: TextStyle(
                            color: primary,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    const Color primary = Color(0xFF2E7D32);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: primary, size: 24),
                const SizedBox(width: 12),
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
    const Color primary = Color(0xFF2E7D32);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
      ),
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
                    fontSize: 12,
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

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    const Color primary = Color(0xFF2E7D32);
    final Color iconColor = isDestructive ? Colors.red : primary;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDestructive ? Colors.red : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              FontAwesomeIcons.chevronRight,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Експорт даних розпочато...'),
        backgroundColor: Color(0xFF2E7D32),
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Видалити акаунт'),
        content: const Text('Ця дія незворотна. Всі ваші дані будуть назавжди видалені. Ви впевнені?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Скасувати'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Запит на видалення акаунта відправлено. Ми зв\'яжемося з вами для підтвердження.'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Видалити'),
          ),
        ],
      ),
    );
  }

  void _openPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Відкриваємо політику конфіденційності...'),
        backgroundColor: Color(0xFF2E7D32),
      ),
    );
  }
}