import 'dart:convert';
import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pma/services/shared_preferences.dart';

import '../const.dart';


class AuthService {

  final String apiUrl = '$baseUrl/api/v1/users';
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



  Future<void> SignUp( Map<String, dynamic> data  
) async {
  final response = await http.post(
    Uri.parse('$apiUrl/api/users/signup'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(    data
      ),
  );

  if (response.statusCode == 200) {
    print('User signed up');
  } else {
    print('Failed to signup ');
  }
}

Future<void> UploadImageUser(XFile? pickedFile, Map<String, dynamic> userData) async {
    try {
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        print("picked file::::$pickedFile");
                print("picked path::::$file");
                

        final filename= file.path.split('/').last;// Get only the filename from the path
        print("image:::::$filename");
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('$imageUrl'),
        );

        request.files.add(await http.MultipartFile.fromPath('image', file.path));

        final response = await request.send();
          userData['image']=filename;
          print("data:::::: $userData");
        if (response.statusCode == 200) {
          userData['image']=filename;
          print("uploaded image successfully");

            await SignUp(userData);

        } else {
          print('Failed to upload image');
          return null;
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }



// Future<Map<String, dynamic>> signUp(
//   String fullName,
//   String email,
//   String password,
//   String mobile,
//   String gender,
//   String role,
//   dynamic image,
// ) async {
//   try {
//     print("Sending signup request");
//     final response = await http.post(
//       Uri.parse('$apiUrl/signup'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'fullName': fullName,
//         'email': email,
//         'password': password,
//         'mobile': mobile,
//         'gender': gender,
//         'roles': [role], 
//         'image': image,
//       }),
//     );

//     print("Received response: ${response.statusCode}");
//     print("Response body: ${response.body}");

//     if (response.statusCode == 200) {
//       Map<String, dynamic> data = json.decode(response.body);
//       return data;
//     } else {
//       print("Sign-up request failed");
//       return {'error': 'Failed to sign up. Please try again.'};
//     }
//   } catch (error) {
//     print("Error during sign-up: $error");
//     return {'error': 'An error occurred while signing up. Please try again later.'};
//   }
// }




  logout() {
    shared_prefs.clearPrefs();
  }

}
