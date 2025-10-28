import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/providers.dart';
import '../services/supabase_user_repository.dart';
import '../services/events_repository.dart';
import '../models/user_stats.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Брендові кольори
  static const Color primary = Color(0xFF2E7D32);
  static const Color secondary = Color(0xFFFF7043);
  static const Color accent = Color(0xFF42A5F5);

  Map<String, dynamic>? _profile;
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    if (user == null) return;
    final repo = SupabaseUserRepository(Supabase.instance.client);
    final data = await repo.getProfile(user.id);
    if (!mounted) return;
    setState(() {
      _profile = data ?? {};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final user = authProvider.currentUser;
            
            if (user == null) {
              return const Center(
                child: Text('Користувач не знайдений'),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Заголовок та кнопка сповіщень
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Профіль',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/notifications');
                          },
                          icon: Icon(
                            FontAwesomeIcons.bell,
                            color: primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Аватар та основна інформація
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
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
                        // Аватар з можливістю зміни
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: accent.withOpacity(0.1),
                              backgroundImage: (() {
                                final profileUrl = _profile?['avatar_url'] as String?;
                                final authUrl = user.avatarUrl;
                                final url = (profileUrl != null && profileUrl.isNotEmpty)
                                    ? profileUrl
                                    : authUrl;
                                return (url != null && url.isNotEmpty)
                                    ? NetworkImage(url)
                                    : null;
                              })(),
                              child: (() {
                                final hasUrl = ((_profile?['avatar_url'] as String?)?.isNotEmpty == true) ||
                                    ((user.avatarUrl ?? '').isNotEmpty);
                                return hasUrl
                                    ? null
                                    : Icon(
                                        FontAwesomeIcons.user,
                                        size: 40,
                                        color: accent,
                                      );
                              })(),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    _showImagePicker(context);
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.camera,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // Ім'я та email
                        Text(
                          user.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        if ((_profile?['city'] as String?)?.isNotEmpty == true)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FontAwesomeIcons.city, size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 6),
                              Text(
                                _profile!['city'] as String,
                                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        if ((_profile?['bio'] as String?)?.isNotEmpty == true) ...[
                          const SizedBox(height: 12),
                          Text(
                            _profile!['bio'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                        ],
                        if ((_profile?['interests'] as List?)?.isNotEmpty == true) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: List<String>.from(_profile!['interests'] as List)
                                .map((i) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: accent.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(i, style: TextStyle(color: accent, fontSize: 12, fontWeight: FontWeight.w600)),
                                    ))
                                .toList(),
                          ),
                        ],
                        const SizedBox(height: 20),
                        
                        // Статистика
                        FutureBuilder<UserStats>(
                          future: Provider.of<EventsRepository>(context, listen: false)
                              .fetchUserStats(user.id),
                          builder: (context, snapshot) {
                            final stats = snapshot.data;
                            return Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    icon: FontAwesomeIcons.calendarCheck,
                                    value: stats != null ? '${stats.totalEventsAttended}' : '—',
                                    label: 'Івентів',
                                    color: accent,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatCard(
                                    icon: FontAwesomeIcons.clock,
                                    value: stats != null ? '${stats.totalHoursVolunteered}' : '—',
                                    label: 'Годин',
                                    color: secondary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatCard(
                                    icon: FontAwesomeIcons.trophy,
                                    value: stats != null ? stats.currentLevel.emoji : '—',
                                    label: stats != null ? stats.currentLevel.name : 'Рівень',
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  // Меню профілю
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _buildMenuCard(
                          icon: FontAwesomeIcons.userPen,
                          title: 'Редагувати профіль',
                          subtitle: 'Змінити особисту інформацію',
                          color: primary,
                          onTap: () {
                            Navigator.pushNamed(context, '/profile-edit').then((_) => _loadProfile());
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildMenuCard(
                          icon: FontAwesomeIcons.gear,
                          title: 'Налаштування',
                          subtitle: 'Персоналізація додатку',
                          color: accent,
                          onTap: () {
                            Navigator.pushNamed(context, '/settings');
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildMenuCard(
                          icon: FontAwesomeIcons.shield,
                          title: 'Приватність',
                          subtitle: 'Керування даними',
                          color: Colors.purple,
                          onTap: () {
                            Navigator.pushNamed(context, '/privacy');
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildMenuCard(
                          icon: FontAwesomeIcons.circleQuestion,
                          title: 'Допомога',
                          subtitle: 'FAQ та підтримка',
                          color: Colors.orange,
                          onTap: () {
                            Navigator.pushNamed(context, '/help');
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildMenuCard(
                          icon: FontAwesomeIcons.thermometerHalf,
                          title: 'MQTT Датчик',
                          subtitle: 'Температура в реальному часі',
                          color: Colors.red,
                          onTap: () {
                            Navigator.pushNamed(context, '/mqtt');
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Кнопка виходу
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _logout,
                        icon: const Icon(
                          FontAwesomeIcons.arrowRightFromBracket,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Вийти з акаунту',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
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
      ),
    );
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Оберіть фото',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(
                  icon: FontAwesomeIcons.image,
                  label: 'Галерея',
                  onTap: () async {
                    Navigator.pop(context);
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(source: ImageSource.gallery);
                    if (picked != null && mounted) {
                      setState(() => _selectedImage = picked);
                      await _uploadProfileImage(picked);
                    }
                  },
                ),
                _buildImageOption(
                  icon: FontAwesomeIcons.camera,
                  label: 'Камера',
                  onTap: () async {
                    Navigator.pop(context);
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(source: ImageSource.camera);
                    if (picked != null && mounted) {
                      setState(() => _selectedImage = picked);
                      await _uploadProfileImage(picked);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Скасувати'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadProfileImage(XFile file) async {
    try {
      final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
      if (user == null) return;

      final bytes = await file.readAsBytes();
      final fileName = '${user.id}/avatar/${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      await Supabase.instance.client.storage.from('avatars').uploadBinary(
        fileName,
        bytes,
      );

      final url = Supabase.instance.client.storage.from('avatars').getPublicUrl(fileName);
      
      await Supabase.instance.client
          .from('profiles')
          .update({'avatar_url': url})
          .eq('id', user.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Фото профілю оновлено!'), backgroundColor: Color(0xFF2E7D32)),
        );
        _loadProfile();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Помилка: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: accent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: accent,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final Color primary = const Color(0xFF2E7D32);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Вийти з акаунту?'),
        content: const Text('Ви дійсно бажаєте вийти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Скасувати', style: TextStyle(color: primary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Вийти'),
          ),
        ],
      ),
    ) ?? false;

    if (!confirmed) return;

    await authProvider.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }
}
