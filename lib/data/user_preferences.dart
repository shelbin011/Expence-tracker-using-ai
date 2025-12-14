import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const _keyName = 'user_name';
  static const _keyEmail = 'user_email';
  static const _keyCountry = 'user_country';

  Future<void> saveUser(String name, String email, String country) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyCountry, country);
  }

  Future<Map<String, String>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_keyName) ?? "John Doe";
    final email = prefs.getString(_keyEmail) ?? "john.doe@example.com";
    final country = prefs.getString(_keyCountry) ?? "United States";
    return {
      'name': name,
      'email': email,
      'country': country,
    };
  }
}
