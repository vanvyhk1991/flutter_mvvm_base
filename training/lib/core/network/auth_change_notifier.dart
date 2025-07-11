import 'dart:async';
import 'package:flutter/foundation.dart';

class AuthChangeNotifier extends ChangeNotifier {
  String? _token;

  String? get token => _token;

  set token(String? value) {
    _token = value;
    notifyListeners(); // Thông báo cho GoRouter khi token thay đổi
  }

  void clear() {
    _token = null;
    notifyListeners();
  }

  bool get isLoggedIn => _token != null;
}