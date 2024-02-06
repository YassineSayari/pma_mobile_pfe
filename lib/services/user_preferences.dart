import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String userFullNameKey = 'userFullName';
  static const String userEmailKey = 'userEmail';
  static const String userRoleKey = 'userRole';

  static Future<void> saveUserInfo(String fullName, String email, String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userFullNameKey, fullName);
    prefs.setString(userEmailKey, email);
    prefs.setString(userRoleKey, role);
  }

  static Future<Map<String, String>> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fullName = prefs.getString(userFullNameKey);
    String? email = prefs.getString(userEmailKey);
    String? role = prefs.getString(userRoleKey);

    return {
      'userFullName': fullName ?? '',
      'userEmail': email ?? '',
      'userRole': role ?? '',
    };
  }
}
