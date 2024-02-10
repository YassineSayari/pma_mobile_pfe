import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pma/services/shared_preferences.dart';
import '../models/user_model.dart';

const ip = "192.168.0.18";
//const ip = "192.168.0.18";
const port = 3002;

class UserService{
  final String apiUrl = 'http://$ip:$port/api/v1';

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

  //clients list
  Future<List<User>> getAllClients() async {
    final response = await http.get(Uri.parse(apiUrl+"/users/getAllClient"));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => User.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }



  Future<List<User>> getSignUpRequests() async {
    try {

      String? authToken = await SharedPrefs.getAuthToken();

      if (authToken == null) {
        throw Exception('Authentication token not available');
      }

      final response = await http.get(
        Uri.parse(apiUrl + "/users/signup/requests"),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => User.fromJson(model)).toList();
      } else {
        throw Exception('Failed to load sign-up requests');
      }
    } catch (error) {
      print('Error in getSignUpRequests: $error');
      throw Exception('Failed to load sign-up requests');
    }
  }

  //delete a user
  Future<void> deleteUser(String userId) async {
    print("deleting user with id $userId");
    try {
      final response = await http.delete(Uri.parse(apiUrl + "/users/delete/$userId"));
      if (response.statusCode == 200 || response.statusCode == 500) {
        print('User deleted successfully');
      } else {
        print('Failed to delete user. Status Code: ${response.statusCode}, Response: ${response.body}');
        throw Exception('Failed to delete user');
      }
    } catch (error) {
      print('Error deleting user: $error');
      throw Exception('Failed to delete user');
    }
  }



  Future<List<User>> searchUsers(Map<String, dynamic> filters) async {
    final response = await http.post(
      Uri.parse(apiUrl + "/users/search"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(filters),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      throw Exception('Failed to search users');
    }
  }




}