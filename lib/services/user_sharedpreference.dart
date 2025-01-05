import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  // Keys for String value
  static const String _keyEmail = "emailKey";
  static const String _keyName = "nameKey";
  static const String _keyPhNo = "phNoKey";
  static const String _keyNewUser = "newUserKey";
  // Add a new key for showing the scratch card
  static const String _keyHasSeenScratchCard = "hasSeenScratchCard";

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

// Set an int value
  Future<void> setInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

// Get an int value
  Future<int?> getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Use getInt and handle nullability
    return prefs.containsKey(key) ? prefs.getInt(key) : null;
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
}
