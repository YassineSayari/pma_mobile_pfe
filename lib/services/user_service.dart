import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

const ip = "192.168.0.18";
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

  //delete a user
  Future<void> deleteUser(String userId) async {
    print("deleting user with id $userId");
    final response = await http.delete(Uri.parse(apiUrl+"/users/delete/$userId"));
    if (response.statusCode == 200) {
      print('User deleted successfully');
    } else {
      throw Exception('Failed to delete user');
    }
  }


}