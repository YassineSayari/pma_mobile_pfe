import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String userIdKey="userId";
  static const String userFullNameKey = 'userFullName';
  static const String userEmailKey = 'userEmail';
  static const String userRoleKey = 'userRole';
  static const String authTokenKey = 'authToken';
  static const String userImage='image';

  static Future<void> saveUserInfo(String id,String fullName, String email, String role, String image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userIdKey,id);
    prefs.setString(userFullNameKey, fullName);
    prefs.setString(userEmailKey, email);
    prefs.setString(userRoleKey, role);
    prefs.setString(userImage, image);

  }

  static Future<void> saveAuthToken(String authToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(authTokenKey, authToken);
  }

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(authTokenKey);
  }


  static Future<Map<String, String>> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString(userIdKey);
    String? fullName = prefs.getString(userFullNameKey);
    String? email = prefs.getString(userEmailKey);
    String? role = prefs.getString(userRoleKey);
    String? image = prefs.getString(userImage);

    return {
      "userId": id ?? '',
      'userFullName': fullName ?? '',
      'userEmail': email ?? '',
      'userRole': role ?? '',
      'userImage': image ?? '',
    };
  }

  Future<String?> getLoggedUserIdFromPrefs() async {
    print("got id");
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }
    Future<String?> getUserImage() async {
    print("getting image");
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userImage);
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
    prefs.remove(userImage);
  }

}
