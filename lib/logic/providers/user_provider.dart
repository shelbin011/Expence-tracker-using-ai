import 'package:flutter/material.dart';
import '../../data/user_preferences.dart';
import '../../core/constants/app_constants.dart';

class UserProvider with ChangeNotifier {
  String _name = "John Doe";
  String _email = "john.doe@example.com";
  String _country = "United States";
  double _monthlyBudget = 0.0;
  String _accountNumber = "*** **** **** 1234";
  String _expiryDate = "12/30";
  final UserPreferences _userPreferences = UserPreferences();

  String get name => _name;
  String get email => _email;
  String get country => _country;
  double get monthlyBudget => _monthlyBudget;
  String get accountNumber => _accountNumber;
  String get expiryDate => _expiryDate;
  String get currency => AppConstants.countryCurrencies[_country] ?? '\$';

  bool _isNotificationsEnabled = false;
  bool get isNotificationsEnabled => _isNotificationsEnabled;

  UserProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final userData = await _userPreferences.getUser();
    _name = userData['name'] as String;
    _email = userData['email'] as String;
    _country = userData['country'] as String;
    _monthlyBudget = userData['budget'] as double;
    _accountNumber = userData['accountNumber'] as String;
    _expiryDate = userData['expiryDate'] as String;
    _isNotificationsEnabled = await _userPreferences.getNotificationPreference(); // Load preference
    notifyListeners();
  }

  Future<void> updateUser(String name, String email) async {
    _name = name;
    _email = email;
    await _userPreferences.saveUser(name, email, _country, _monthlyBudget, _accountNumber, _expiryDate);
    notifyListeners();
  }

  Future<void> updateCountry(String country) async {
    _country = country;
    await _userPreferences.saveUser(_name, _email, country, _monthlyBudget, _accountNumber, _expiryDate);
    notifyListeners();
  }

  Future<void> updateBudget(double budget) async {
    _monthlyBudget = budget;
    await _userPreferences.saveUser(_name, _email, _country, budget, _accountNumber, _expiryDate);
    notifyListeners();
  }

  Future<void> updateAccountDetails(String accountNumber, String expiryDate) async {
    _accountNumber = accountNumber;
    _expiryDate = expiryDate;
    await _userPreferences.saveUser(_name, _email, _country, _monthlyBudget, accountNumber, expiryDate);
    notifyListeners();
  }

  Future<void> toggleNotifications(bool value) async {
    _isNotificationsEnabled = value;
    await _userPreferences.saveNotificationPreference(value);
    notifyListeners();
  }
}
