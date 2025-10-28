import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';
import 'supabase_user_repository.dart';

class AuthService {
  final SupabaseUserRepository _userRepository;

  AuthService(this._userRepository);

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Використовуємо Supabase для реєстрації
      final response = await _userRepository.signUp(
        email: email,
        password: password,
        name: name,
      );

      if (response.user == null) {
        throw Exception('Не вдалося створити користувача');
      }

      // Створюємо AppUser з даних реєстрації
      final appUser = AppUser(
        id: response.user!.id,
        name: name, // Використовуємо передане ім'я
        email: email,
        password: '', // Пароль не зберігаємо
        createdAt: DateTime.parse(response.user!.createdAt),
      );

      return appUser;
    } catch (e) {
      throw Exception('Помилка реєстрації: $e');
    }
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      // Використовуємо Supabase для входу
      final response = await _userRepository.signIn(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Не вдалося увійти в систему');
      }

      // Створюємо AppUser з даних входу
      String name = 'Користувач';
      if (response.user!.userMetadata != null) {
        name = response.user!.userMetadata!['name'] ?? 
               response.user!.userMetadata!['full_name'] ?? 
               response.user!.userMetadata!['display_name'] ?? 
               response.user!.userMetadata!['user_name'] ??
               'Користувач';
      }

      final appUser = AppUser(
        id: response.user!.id,
        name: name,
        email: email,
        password: '', // Пароль не зберігаємо
        createdAt: DateTime.parse(response.user!.createdAt),
      );

      return appUser;
    } catch (e) {
      throw Exception('Помилка входу: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _userRepository.signOut();
    } catch (e) {
      throw Exception('Помилка виходу: $e');
    }
  }

  Future<AppUser?> getCurrentUser() async {
    return _userRepository.getCurrentUser();
  }

  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }

  Future<void> updateUser(AppUser user) async {
    try {
      await _userRepository.updateUser(user);
    } catch (e) {
      throw Exception('Помилка оновлення користувача: $e');
    }
  }

  Stream<AuthState> get authStateChanges => _userRepository.authStateChanges;
}
