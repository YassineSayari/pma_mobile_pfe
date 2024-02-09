import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:pma/services/shared_preferences.dart';

//const ip = "192.168.0.18";

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

  Future<Map<String, dynamic>> signUp(String fullName, String email, String password, String image) async {
    try {
      print("signing up");
      final response = await http.post(
        Uri.parse('$apiUrl/users/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'password': password,
          'image': image,
        }),
      );

      if (response.statusCode == 200) {
        print("Sign-up successful");
        Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        print("Sign-up failed");
        return {'error': 'Failed to sign up'};
      }
    } catch (error) {
      print("Error during sign-up: $error");
      return {'error': 'Unexpected error during sign-up'};
    }
  }

  logout() {
    shared_prefs.clearPrefs();
  }

}
