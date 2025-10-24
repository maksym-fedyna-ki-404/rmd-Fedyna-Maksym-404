import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  AppUser? _currentUser;
  bool _isLoading = false;

  AuthProvider(this._authService) {
    _initializeAuthListener();
  }

  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  void _initializeAuthListener() {
    _authService.authStateChanges.listen((AuthState data) async {
      final session = data.session;
      if (session != null) {
        _currentUser = await _authService.getCurrentUser();
      } else {
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  Future<void> initialize() async {
    _setLoading(true);
    try {
      _currentUser = await _authService.getCurrentUser();
    } catch (e) {
      debugPrint('Помилка ініціалізації: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final user = await _authService.register(
        name: name,
        email: email,
        password: password,
      );
      _currentUser = user;
      notifyListeners();
      return user;
    } finally {
      _setLoading(false);
    }
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final user = await _authService.login(
        email: email,
        password: password,
      );
      _currentUser = user;
      notifyListeners();
      return user;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
      _currentUser = null;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUser(AppUser user) async {
    _setLoading(true);
    try {
      await _authService.updateUser(user);
      _currentUser = user;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
