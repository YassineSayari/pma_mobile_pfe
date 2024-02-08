import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:pma/services/shared_preferences.dart';

const ip = "192.168.0.18";
const port = 3002;

class AuthService {

  final String apiUrl = 'http://$ip:$port/api/v1';
  SharedPrefs shared_prefs = GetIt.I<SharedPrefs>();


  //login
  Future<Map<String, dynamic>> login(String email, String password) async {
    print("checking for user");
    final response = await http.post(
      Uri.parse('$apiUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      print("found a user");
      Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      print("no user found");
      return {'error': 'Incorrect email or password'};
    }
  }

  logout() {
    shared_prefs.clearPrefs();
  }

}
