import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  // Keys for String value
  static const String _keyEmail = "emailKey";
  static const String _keyName = "nameKey";
  static const String _keyNewUser = "newUserKey";

// Set a String value
  Future<void> setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Save the user details
  Future<void> saveUserDetails({
    required String email,
    required String name,
  }) async {
    await setString(_keyEmail, email);
    await setString(_keyName, name);
  }

// Get a String value
  Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  /// Retrieve user details
  Future<Map<String, String?>> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(_keyEmail),
      'name': prefs.getString(_keyName),
    };
  }

// Set a bool value
  Future<void> setBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

// Get a bool value
  Future<bool?> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Use getBool and handle nullability
    return prefs.containsKey(key) ? prefs.getBool(key) : null;
  }

  // Set the new user flag
  Future<void> setNewUser(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNewUser, value);
  }

  // Get the new user flag
  Future<bool> isNewUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNewUser) ?? true;
  }

  // Clear the user data (email, name, new user flag) on logout
  Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove specific keys related to user data
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyName);
    await prefs.remove(_keyNewUser);
  }
}
