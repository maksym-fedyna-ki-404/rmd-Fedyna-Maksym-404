import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  List<ConnectivityResult> _current = [ConnectivityResult.none];
  List<ConnectivityResult> get current => _current;
  bool get isOnline => _current.any((result) => result != ConnectivityResult.none);

  Future<void> initialize() async {
    if (_subscription != null) return; // Вже ініціалізовано
    
    _current = await _connectivity.checkConnectivity();
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      _current = result;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
