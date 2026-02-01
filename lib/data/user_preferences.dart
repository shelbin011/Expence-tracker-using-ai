import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const _keyName = 'user_name';
  static const _keyEmail = 'user_email';
  static const _keyCountry = 'user_country';
  static const _keyBudget = 'user_budget';
  static const _keyAccountNumber = 'user_account_number';
  static const _keyExpiryDate = 'user_expiry_date';

  static const _keyNotifications = 'user_notifications';

  Future<void> saveUser(String name, String email, String country, double budget, String accountNumber, String expiryDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyCountry, country);
    await prefs.setDouble(_keyBudget, budget);
    await prefs.setString(_keyAccountNumber, accountNumber);
    await prefs.setString(_keyExpiryDate, expiryDate);
  }

  Future<Map<String, dynamic>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_keyName) ?? "John Doe";
    final email = prefs.getString(_keyEmail) ?? "john.doe@example.com";
    final country = prefs.getString(_keyCountry) ?? "United States";
    final budget = prefs.getDouble(_keyBudget) ?? 0.0;
    final accountNumber = prefs.getString(_keyAccountNumber) ?? "*** **** **** 1234";
    final expiryDate = prefs.getString(_keyExpiryDate) ?? "12/30";
    return {
      'name': name,
      'email': email,
      'country': country,
      'budget': budget,
      'accountNumber': accountNumber,
      'expiryDate': expiryDate,
    };
  }

  Future<void> saveNotificationPreference(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifications, isEnabled);
  }

  Future<bool> getNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotifications) ?? false;
  }
}
