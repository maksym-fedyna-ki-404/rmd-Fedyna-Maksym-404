import '../models/user.dart';

abstract class UserRepository {
  Future<AppUser?> getUserByEmail(String email);
  Future<AppUser?> getUserById(String id);
  Future<void> saveUser(AppUser user);
  Future<void> updateUser(AppUser user);
  Future<void> deleteUser(String id);
  Future<List<AppUser>> getAllUsers();
  Future<bool> isEmailExists(String email);
}
