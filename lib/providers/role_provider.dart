import 'package:flutter/material.dart';

class RoleProvider with ChangeNotifier {
  bool _isAdmin = false;
  String? _accessToken;

  bool get isAdmin => _isAdmin;
  String? get accessToken => _accessToken;

  void setRole(bool isAdmin) {
    _isAdmin = isAdmin;
    notifyListeners();
  }

  void setAccessToken(String accessToken) {
    _accessToken = accessToken;
    notifyListeners();
  }
}
