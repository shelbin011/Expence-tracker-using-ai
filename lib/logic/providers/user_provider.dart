import 'package:flutter/material.dart';
import '../../data/user_preferences.dart';

class UserProvider with ChangeNotifier {
  String _name = "John Doe";
  String _email = "john.doe@example.com";
  final UserPreferences _userPreferences = UserPreferences();

  String get name => _name;
  String get email => _email;

  UserProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final userData = await _userPreferences.getUser();
    _name = userData['name']!;
    _email = userData['email']!;
    notifyListeners();
  }

  Future<void> updateUser(String name, String email) async {
    _name = name;
    _email = email;
    await _userPreferences.saveUser(name, email);
    notifyListeners();
  }
}
