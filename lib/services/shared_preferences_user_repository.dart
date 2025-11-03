import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'user_repository.dart';

class SharedPreferencesUserRepository implements UserRepository {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'current_user';

  @override
  Future<AppUser?> getUserByEmail(String email) async {
    final users = await getAllUsers();
    try {
      return users.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AppUser?> getUserById(String id) async {
    final users = await getAllUsers();
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveUser(AppUser user) async {
    final users = await getAllUsers();
    
    // Перевіряємо чи користувач з таким email вже існує
    if (await isEmailExists(user.email)) {
      throw Exception('Користувач з таким email вже існує');
    }
    
    users.add(user);
    await _saveUsersToPrefs(users);
  }

  @override
  Future<void> updateUser(AppUser user) async {
    final users = await getAllUsers();
    final index = users.indexWhere((u) => u.id == user.id);
    
    if (index == -1) {
      throw Exception('Користувач не знайдений');
    }
    
    users[index] = user;
    await _saveUsersToPrefs(users);
  }

  @override
  Future<void> deleteUser(String id) async {
    final users = await getAllUsers();
    users.removeWhere((user) => user.id == id);
    await _saveUsersToPrefs(users);
  }

  @override
  Future<List<AppUser>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_usersKey) ?? [];
    
    return usersJson
        .map((json) => AppUser.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<bool> isEmailExists(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }

  Future<void> setCurrentUser(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
  }

  Future<AppUser?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_currentUserKey);
    
    if (userJson == null) return null;
    
    return AppUser.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
  }

  Future<void> clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  Future<void> _saveUsersToPrefs(List<AppUser> users) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = users
        .map((user) => jsonEncode(user.toJson()))
        .toList();
    
    await prefs.setStringList(_usersKey, usersJson);
  }
}
