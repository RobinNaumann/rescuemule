import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rescuemule/model/m_user.dart';

class UserService {
  static const String _storageKey = 'saved_users';
  static const String _clientKey = 'client_data';

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> users = prefs.getStringList(_storageKey) ?? [];
    users.add(jsonEncode(user.toJson()));
    await prefs.setStringList(_storageKey, users);
  }

  Future<List<User>> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> users = prefs.getStringList(_storageKey) ?? [];
    return users.map((userString) => User.fromJson(jsonDecode(userString))).toList();
  }

  Future<void> clearUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  Future<void> saveClientUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_clientKey, jsonEncode(user.toJson()));
  }

  Future<User?> loadClientUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString(_clientKey);
    if (userString == null) return null;
    return User.fromJson(jsonDecode(userString));
  }
}