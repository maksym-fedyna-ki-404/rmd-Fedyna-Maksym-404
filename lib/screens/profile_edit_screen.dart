import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../providers/providers.dart';
import '../services/supabase_user_repository.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  
  String _selectedCity = 'Львів';
  List<String> _selectedInterests = [];
  XFile? _selectedImage;
  Uint8List? _previewBytes;
  String? _avatarUrl;
  
  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: '+380');
    _bioController = TextEditingController(text: '');
    _loadUserProfile();
  }
  
  Future<void> _loadUserProfile() async {
    try {
      final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
      if (user == null) return;
      
      final supabaseRepo = SupabaseUserRepository(Supabase.instance.client);
      final profileData = await supabaseRepo.getProfile(user.id);
      
      if (profileData != null && mounted) {
        setState(() {
          _bioController.text = profileData['bio'] as String? ?? '';
          _selectedCity = profileData['city'] as String? ?? 'Львів';
          _selectedInterests = List<String>.from(profileData['interests'] as List? ?? []);
          _avatarUrl = profileData['avatar_url'] as String?;
        });
      }
    } catch (e) {
      debugPrint('Помилка завантаження профілю: $e');
    }
  }
  
  final List<String> _cities = [
    'Київ', 'Харків', 'Одеса', 'Дніпро', 'Львів', 'Запоріжжя', 'Інше'
  ];
  
  final List<String> _interests = [
    'Екологія', 'Допомога тваринам', 'Освіта', 'Медицина', 
    'Спорт', 'Культура', 'Соціальна допомога', 'Технології'
  ];

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF2E7D32);
    const Color accent = Color(0xFF42A5F5);

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
                      'Редагувати профіль',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextButton(
                    onPressed: _saveProfile,
                    child: Text(
                      'Зберегти',
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Фото профілю
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: _previewBytes != null
                                  ? MemoryImage(_previewBytes!)
                                  : (_avatarUrl != null && _avatarUrl!.isNotEmpty
                                      ? NetworkImage(_avatarUrl!) as ImageProvider
                                      : null),
                              child: (_previewBytes == null && (_avatarUrl == null || _avatarUrl!.isEmpty))
                                  ? Icon(
                                      FontAwesomeIcons.user,
                                      size: 60,
                                      color: Colors.grey[600],
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _showImagePicker,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: accent,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(
                                    FontAwesomeIcons.camera,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Особиста інформація
                      _buildSectionTitle('Особиста інформація'),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Ім\'я',
                          prefixIcon: Icon(FontAwesomeIcons.user, color: primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primary, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Будь ласка, введіть ім\'я';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(FontAwesomeIcons.envelope, color: primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primary, width: 2),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Будь ласка, введіть email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Введіть коректний email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Телефон',
                          prefixIcon: Icon(FontAwesomeIcons.phone, color: primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primary, width: 2),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 24),

                      // Місто
                      _buildSectionTitle('Місто'),
                      const SizedBox(height: 16),
                      
                      DropdownButtonFormField<String>(
                        value: _selectedCity,
                        decoration: InputDecoration(
                          labelText: 'Виберіть місто',
                          prefixIcon: Icon(FontAwesomeIcons.city, color: primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primary, width: 2),
                          ),
                        ),
                        items: _cities.map((String city) {
                          return DropdownMenuItem<String>(
                            value: city,
                            child: Text(city),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCity = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Будь ласка, виберіть місто';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Про себе
                      _buildSectionTitle('Про себе'),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _bioController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Біографія',
                          prefixIcon: Icon(FontAwesomeIcons.solidFileLines, color: primary),
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primary, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Інтереси
                      _buildSectionTitle('Інтереси'),
                      const SizedBox(height: 16),
                      
                      Wrap(
                        spacing: 8.0,
                        children: _interests.map((interest) {
                          final isSelected = _selectedInterests.contains(interest);
                          return FilterChip(
                            label: Text(interest),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedInterests.add(interest);
                                } else {
                                  _selectedInterests.remove(interest);
                                }
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
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    const Color primary = Color(0xFF2E7D32);
    
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: primary,
      ),
    );
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Галерея'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null && mounted) {
                    final bytes = await picked.readAsBytes();
                    setState(() {
                      _selectedImage = picked;
                      _previewBytes = bytes;
                    });
                    await _uploadProfileImage(picked);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Камера'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(source: ImageSource.camera);
                  if (picked != null && mounted) {
                    final bytes = await picked.readAsBytes();
                    setState(() {
                      _selectedImage = picked;
                      _previewBytes = bytes;
                    });
                    await _uploadProfileImage(picked);
                  }
                },
              ),
            ],
          ),
        );
      },
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
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Помилка: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final user = authProvider.currentUser;
        if (user == null) return;
        
        // Оновлюємо ім'я в Auth
        await authProvider.updateUser(
          user.copyWith(
            name: _nameController.text,
            email: _emailController.text,
          ),
        );
        
        // Оновлюємо профіль в Supabase
        final supabaseRepo = SupabaseUserRepository(Supabase.instance.client);
        await supabaseRepo.updateProfile(
          userId: user.id,
          name: _nameController.text,
          bio: _bioController.text,
          city: _selectedCity,
          phone: _phoneController.text,
          interests: _selectedInterests,
        );
        
        // Додаткова перевірка - читаємо назад з БД
        final saved = await supabaseRepo.getProfile(user.id);
        debugPrint('✅ Збережено в БД: $saved');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Профіль успішно збережено!'),
              backgroundColor: Color(0xFF2E7D32),
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Помилка збереження: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}