import 'package:flutter/material.dart';

import '../../core/base/base_view_model.dart';

class UserViewModel extends BaseViewModel {
  String username = "Guest";

  void updateUsername(String? name) {
    username = name!;
    notifyListeners();
  }
}