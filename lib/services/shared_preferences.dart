import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String userIdKey="userId";
  static const String userFullNameKey = 'userFullName';
  static const String userEmailKey = 'userEmail';
  static const String userRoleKey = 'userRole';

  static Future<void> saveUserInfo(String id,String fullName, String email, String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userIdKey,id);
    prefs.setString(userFullNameKey, fullName);
    prefs.setString(userEmailKey, email);
    prefs.setString(userRoleKey, role);
  }

  static Future<Map<String, String>> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString(userIdKey);
    String? fullName = prefs.getString(userFullNameKey);
    String? email = prefs.getString(userEmailKey);
    String? role = prefs.getString(userRoleKey);

    return {
      "userId": id ?? '',
      'userFullName': fullName ?? '',
      'userEmail': email ?? '',
      'userRole': role ?? '',
    };
  }

  Future<String?> getLoggedUserIdFromPrefs() async {
    print("got id");
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getLoggedUserRoleFromPrefs() async {
    print("got role");
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userRoleKey);
  }

  void clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(userIdKey);
    prefs.remove(userFullNameKey);
    prefs.remove(userEmailKey);
    prefs.remove(userRoleKey);
  }

}
