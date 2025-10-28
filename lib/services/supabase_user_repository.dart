import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';
import 'user_repository.dart';

class SupabaseUserRepository implements UserRepository {
  final SupabaseClient _supabase;

  SupabaseUserRepository(this._supabase);

  @override
  Future<AppUser?> getUserByEmail(String email) async {
    try {
      // Отримуємо користувача з auth.users через Supabase
      final authUser = _supabase.auth.currentUser;
      if (authUser != null && authUser.email == email) {
        return getCurrentUser();
      }
      return null;
    } catch (e) {
      // Не викидаємо помилку, просто повертаємо null
      return null;
    }
  }

  @override
  Future<AppUser?> getUserById(String id) async {
    try {
      // Отримуємо користувача з auth.users через Supabase
      final authUser = _supabase.auth.currentUser;
      if (authUser != null && authUser.id == id) {
        return getCurrentUser();
      }
      return null;
    } catch (e) {
      // Не викидаємо помилку, просто повертаємо null
      return null;
    }
  }

  @override
  Future<void> saveUser(AppUser user) async {
    // Supabase сам управляє користувачами, тому цей метод не потрібен
    // Але залишаємо для сумісності з інтерфейсом
  }

  @override
  Future<void> updateUser(AppUser user) async {
    try {
      // Оновлюємо metadata користувача в Supabase Auth
      await _supabase.auth.updateUser(
        UserAttributes(data: {'name': user.name})
      );
    } catch (e) {
      throw Exception('Помилка оновлення користувача: $e');
    }
  }

  Future<void> updateProfile({
    required String userId,
    String? name,
    String? bio,
    String? city,
    String? phone,
    List<String>? interests,
    String? avatarUrl,
  }) async {
    try {
      final Map<String, dynamic> updates = {};
      if (name != null) updates['name'] = name;
      if (bio != null) updates['bio'] = bio;
      if (city != null) updates['city'] = city;
      if (phone != null) updates['phone'] = phone;
      if (interests != null) updates['interests'] = interests;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      
      print('🔍 Перевіряємо профіль для userId: $userId');
      // 1) Чи існує профіль?
      final existing = await _supabase
          .from('profiles')
          .select('id')
          .eq('id', userId)
          .maybeSingle();

      print('📊 Існуючий профіль: $existing');
      
      Map<String, dynamic>? res;
      if (existing == null) {
        // 2) Вставка
        print('➕ Вставка нового профілю з даними: $updates');
        res = await _supabase
            .from('profiles')
            .insert({'id': userId, ...updates})
            .select()
            .maybeSingle();
      } else {
        // 3) Оновлення
        print('✏️ Оновлення профілю з даними: $updates');
        res = await _supabase
            .from('profiles')
            .update(updates)
            .eq('id', userId)
            .select()
            .maybeSingle();
      }

      print('✅ Результат збереження: $res');

      if (res == null) {
        throw Exception('Не вдалося зберегти профіль (порожня відповідь)');
      }
    } catch (e) {
      print('❌ Помилка: $e');
      throw Exception('Помилка оновлення профілю: $e');
    }
  }

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final res = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return res;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      // Видаляємо користувача з Supabase Auth
      await _supabase.auth.admin.deleteUser(id);
    } catch (e) {
      throw Exception('Помилка видалення користувача: $e');
    }
  }

  @override
  Future<List<AppUser>> getAllUsers() async {
    // Повертаємо тільки поточного користувача
    final currentUser = getCurrentUser();
    if (currentUser != null) {
      return [currentUser];
    }
    return [];
  }

  @override
  Future<bool> isEmailExists(String email) async {
    try {
      // Перевіряємо чи поточний користувач має такий email
      final currentUser = _supabase.auth.currentUser;
      return currentUser?.email == email;
    } catch (e) {
      // Не викидаємо помилку, просто повертаємо false
      return false;
    }
  }

  // Supabase специфічні методи
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'full_name': name,
          'display_name': name,
        },
      );

      // Оновлюємо metadata користувача після створення
      if (response.user != null) {
        try {
          await _supabase.auth.updateUser(
            UserAttributes(
              data: {
                'name': name,
                'full_name': name,
                'display_name': name,
              }
            )
          );
        } catch (updateError) {
          // Не критична помилка, продовжуємо
          print('Попередження: не вдалося оновити metadata: $updateError');
        }

        // Автоматично створюємо профіль в public.profiles
        try {
          await _supabase.from('profiles').insert({
            'id': response.user!.id,
            'name': name,
          });
        } catch (profileError) {
          print('Попередження: не вдалося створити профіль: $profileError');
        }
      }

      return response;
    } catch (e) {
      // Перевіряємо різні типи помилок
      final errorMessage = e.toString().toLowerCase();
      
      if (errorMessage.contains('user already registered') || 
          errorMessage.contains('already registered') ||
          errorMessage.contains('email already registered')) {
        throw Exception('Користувач з таким email вже існує');
      } else if (errorMessage.contains('invalid email')) {
        throw Exception('Неправильний формат email');
      } else if (errorMessage.contains('password')) {
        throw Exception('Пароль не відповідає вимогам');
      } else if (errorMessage.contains('email not confirmed')) {
        throw Exception('Email не підтверджено. Перевірте пошту та підтвердіть email');
      } else {
        throw Exception('Помилка реєстрації: ${e.toString()}');
      }
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Помилка входу: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Помилка виходу: $e');
    }
  }

  AppUser? getCurrentUser() {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    // Спробуємо отримати ім'я з різних полів metadata
    String name = 'Користувач';
    if (user.userMetadata != null) {
      name = user.userMetadata!['name'] ?? 
             user.userMetadata!['full_name'] ?? 
             user.userMetadata!['display_name'] ?? 
             user.userMetadata!['user_name'] ??
             'Користувач';
    }

    return AppUser(
      id: user.id,
      name: name,
      email: user.email ?? '',
      password: '',
      createdAt: DateTime.parse(user.createdAt),
    );
  }

  Future<AppUser?> getCurrentUserAsync() async {
    // Чекаємо трохи, щоб Supabase встиг оновити стан
    await Future.delayed(const Duration(milliseconds: 100));
    
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    // Спробуємо отримати ім'я з різних полів metadata
    String name = 'Користувач';
    if (user.userMetadata != null) {
      name = user.userMetadata!['name'] ?? 
             user.userMetadata!['full_name'] ?? 
             user.userMetadata!['display_name'] ?? 
             user.userMetadata!['user_name'] ??
             'Користувач';
    }

    return AppUser(
      id: user.id,
      name: name,
      email: user.email ?? '',
      password: '',
      createdAt: DateTime.parse(user.createdAt),
    );
  }

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
