import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:pma/const.dart';
import 'package:pma/services/shared_preferences.dart';
import '../models/user_model.dart';


class UserService{
  final String apiUrl = '$baseUrl/api/v1/users';



  Future<User> getUserbyId(String id) async{
        final response = await http.get(Uri.parse(apiUrl+"/getUserById/$id"));
        if (response.statusCode==200){
          print("user exists");
          User user=User.fromJson(json.decode(response.body));
          return user;
        }else {
      throw Exception('Failed to load users');
    }

  }

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

  Future<List<User>> getAllTeamLeaders() async {
    final response = await http.get(Uri.parse(apiUrl + "/getAllEng"));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => User.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load team leaders');
    }
  }

  Future<List<User>> getTeamLeaders() async {
    final response = await http.get(Uri.parse(apiUrl + "/getAllTeamLeader"));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => User.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load team leaders');
    }
  }


  Future<void> addUser(Map<String, dynamic> userData) async {
    String? authToken = await SharedPrefs.getAuthToken();
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/adduser'),
        body: jsonEncode(userData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('User added successfully: $responseData');
      } else {
        print('Failed to add user. Status code: ${response.statusCode}');
        print('Error message: ${response.body}');
        throw Exception('Failed to add user');
      }
    } catch (error) {
      print('Error adding user: $error');
      throw Exception('Error adding user');
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

  Future<void> removeUserImage(String userId) async {
    Map<String, dynamic> updatedData = {
      'image': '16-02-2024--no-image.jpg',
    };

    await updateUser(userId, updatedData);
  }



final ImagePicker _imagePicker = ImagePicker();

 Future<void> uploadImageUser(String idUser, File image, String authToken) async {
  print("updating user image...");
    var request = http.MultipartRequest(
      'patch',
      Uri.parse('$baseUrl/api/v1/users/update/$idUser'),
    );

    request.headers['Authorization'] = 'Bearer $authToken';
    var file = await http.MultipartFile.fromPath(
      'image',
      image.path,
      filename: path.basename(image.path),
      contentType: MediaType('image', 'jpg'),
    );
    request.files.add(file);

    print("sending request:::::");
    var response = await request.send();
    if (response.statusCode == 200) {
      print("Image updated successfully");
    } else {
      print("Failed to update image");
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

  Future<void> changePassword(String userId,String userEmail, String newPassword) async {
    
    try {
      final response = await http.patch(
        Uri.parse('$apiUrl/change-psw/$userId'),
           headers: <String, String>{
           'Content-Type': 'application/json',
         },
        body: jsonEncode({
          'email':userEmail,
          'password': newPassword
        }),
      );

  if (response.statusCode == 200) {
        print('Password changed successfully');
      } else {
        print('Failed to change password. Status Code: ${response.statusCode}, Response: ${response.body}');
        throw Exception('Failed to change password');
      }
    } catch (error) {
      print('Error changing password: $error');
      throw Exception('Failed to change password');
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