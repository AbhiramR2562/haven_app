import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<void> setScratchCardShown(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isScratchCardShown', value);
  }

  // Retrieve the scratch card status
  Future<bool> isScratchCardShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isScratchCardShown') ?? false;
  }

  // Save user data
  Future<void> setUserData(String email, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
    await prefs.setString('userName', name);
  }

  // Retrieve user data
  Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');
    final name = prefs.getString('userName');
    return {'email': email, 'name': name};
  }

  // Clear user data
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
    await prefs.remove('userName');
  }
}
