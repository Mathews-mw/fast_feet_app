import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fast_feet_app/models/user.dart';
import 'package:fast_feet_app/services/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  final HttpService _httpService = HttpService();

  static const String _userKey = "user_data";

  User? get user {
    return _user;
  }

  bool get isAuthenticated {
    return _user != null;
  }

  Future<void> _saveUSerToLocalStorage(User user) async {
    final prefs = await SharedPreferences.getInstance();

    final userJson = jsonEncode({
      "id": user.id,
      "name": user.name,
      "email": user.email,
      "cpf": user.cpf,
      "role": user.role,
      "createdAt": user.createdAt,
    });

    await prefs.setString(_userKey, userJson);
  }

  Future<void> _loadUserFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);

    if (userJson != null) {
      final userData = jsonDecode(userJson);

      final user = User(
        id: userData['id'],
        name: userData['name'],
        email: userData['email'],
        cpf: userData['cpf'],
        role: userData['role'],
        createdAt: userData['createdAt'],
      );

      _user = user;
    }
  }

  Future<void> loadUserData() async {
    try {
      final response = await _httpService.get('users/me');

      final user = User.fromJson(response);

      _user = user;

      notifyListeners();
    } catch (error) {
      print("Erro ao buscar usuário: $error");
    }
  }

  Future<void> logout() async {
    _user = null;
    notifyListeners();
  }

  Future<void> initializerUser() async {
    await _loadUserFromLocalStorage();
  }
}
