import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:pma/services/shared_preferences.dart';
import '../models/user_model.dart';

const ip = "192.168.0.23";
const port = 3002;

class AuthService {

  final String apiUrl = 'http://$ip:$port/api/v1';
  SharedPrefs shared_prefs = GetIt.I<SharedPrefs>();


  //all users
  Future<List<User>> getAllUsers() async {
    final response = await http.get(Uri.parse(apiUrl+"/users/getall"));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => User.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  //login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      return {'error': 'Incorrect email or password'};
    }
  }

  logout() {
    shared_prefs.clearPrefs();
  }

}
