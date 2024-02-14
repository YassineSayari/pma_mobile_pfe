import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pma/services/shared_preferences.dart';
import '../models/user_model.dart';

const ip = "192.168.0.17";
const port = 3002;

class UserService{
  final String apiUrl = 'http://$ip:$port/api/v1/users';

  //all users
  Future<List<User>> getAllUsers() async {
    final response = await http.get(Uri.parse(apiUrl+"/getall"));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      List<User> enabledUsers = list.map((model) => User.fromJson(model)).where((user) => user.isEnabled).toList();
      return enabledUsers;
    } else {
      throw Exception('Failed to load users');
    }
  }

  //clients list
  Future<List<User>> getAllClients() async {
    final response = await http.get(Uri.parse(apiUrl+"/getAllClient"));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => User.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
  // engineers
  Future<List<User>> getAllEngineers() async {
    print("loading engineers");
    final response = await http.get(Uri.parse(apiUrl + "/getEngi"));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => User.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load engineers');
    }
  }

  // team leaders+engineers
  Future<List<User>> getAllTeamLeaders() async {
    final response = await http.get(Uri.parse(apiUrl + "/getAllEng"));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => User.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load team leaders');
    }
  }


  Future<void> updateUser(String userId, Map<String, dynamic> updatedData) async {
    print("updating user with id $userId");

    String? authToken = await SharedPrefs.getAuthToken();
    try {
      final response = await http.patch(
        Uri.parse('$apiUrl/update/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        print('User updated successfully');
      } else {
        print('Failed to update user. Status Code: ${response.statusCode}, Response: ${response.body}');
        throw Exception('Failed to update user');
      }
    } catch (error) {
      print('Error updating user: $error');
      throw Exception('Failed to update user');
    }
  }





  Future<List<User>> getSignUpRequests() async {
    try {

      String? authToken = await SharedPrefs.getAuthToken();

      if (authToken == null) {
        throw Exception('Authentication token not available');
      }

      final response = await http.get(
        Uri.parse(apiUrl + "/signup/requests"),
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

  Future<void> confirmSignupRequests(String userId) async{
    print("confirming signup of the user $userId" );
    try{
      final response=await http.post(Uri.parse(apiUrl+"/confirm-signup/$userId"));
      if (response.statusCode == 200 || response.statusCode == 500) {
        print('User Confirmed successfully');
      } else {
        print('Failed to confirm. Status Code: ${response.statusCode}, Response: ${response.body}');
        throw Exception('Failed to confirm ');
      }
    } catch (error) {
      print('Error confirming: $error');
      throw Exception('Failed to confirm user');
    }
  }

  
  //delete a user
  Future<void> deleteUser(String userId) async {
    print("deleting user with id $userId");
    try {
      final response = await http.delete(Uri.parse(apiUrl + "/delete/$userId"));
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
      Uri.parse(apiUrl + "/search"),
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