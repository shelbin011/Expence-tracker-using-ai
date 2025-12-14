import 'package:flutter/material.dart';
import '../../data/user_preferences.dart';
import '../../core/constants/app_constants.dart';

class UserProvider with ChangeNotifier {
  String _name = "John Doe";
  String _email = "john.doe@example.com";
  String _country = "United States";
  final UserPreferences _userPreferences = UserPreferences();

  String get name => _name;
  String get email => _email;
  String get country => _country;
  String get currency => AppConstants.countryCurrencies[_country] ?? '\$';

  UserProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final userData = await _userPreferences.getUser();
    _name = userData['name']!;
    _email = userData['email']!;
    _country = userData['country']!;
    notifyListeners();
  }

  Future<void> updateUser(String name, String email) async {
    _name = name;
    _email = email;
    await _userPreferences.saveUser(name, email, _country);
    notifyListeners();
  }

  Future<void> updateCountry(String country) async {
    _country = country;
    await _userPreferences.saveUser(_name, _email, country);
    notifyListeners();
  }
}
