import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:pma/services/shared_preferences.dart';


const ip = "192.168.0.17";
const port = 3002;

class AuthService {

  final String apiUrl = 'http://$ip:$port/api/v1/users';
  SharedPrefs shared_prefs = GetIt.I<SharedPrefs>();


  //login
  Future<Map<String, dynamic>> login(String email, String password) async {
    print("checking for user");
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
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

Future<Map<String, dynamic>> signUp(
  String fullName,
  String email,
  String password,
  String mobile,
  String gender,
  String role,
  dynamic image,
) async {
  try {
    print("Sending signup request");
    final response = await http.post(
      Uri.parse('$apiUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullName': fullName,
        'email': email,
        'password': password,
        'mobile': mobile,
        'gender': gender,
        'roles': [role], // Convert role to a list if needed
        'image': image,
      }),
    );

    print("Received response: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      print("Sign-up request failed");
      return {'error': 'Failed to sign up. Please try again.'};
    }
  } catch (error) {
    print("Error during sign-up: $error");
    return {'error': 'An error occurred while signing up. Please try again later.'};
  }
}

  logout() {
    shared_prefs.clearPrefs();
  }

}
