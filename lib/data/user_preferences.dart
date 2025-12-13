import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const _keyName = 'user_name';
  static const _keyEmail = 'user_email';

  Future<void> saveUser(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyEmail, email);
  }

  Future<Map<String, String>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_keyName) ?? "John Doe";
    final email = prefs.getString(_keyEmail) ?? "john.doe@example.com";
    return {
      'name': name,
      'email': email,
    };
  }
}
