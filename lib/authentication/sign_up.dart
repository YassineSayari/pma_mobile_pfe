import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../services/authentication_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key, required PageController controller}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullname = TextEditingController();
  final TextEditingController mail = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController passwordconf = TextEditingController();

  AuthService authService = AuthService();

  String? gender;
  String? role;



File? selectedImage;
PickedFile? _pickedFile;
final _picker=ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile!.path);
      print("Selected Image Path::::::::::: ${selectedImage!}");
      });
    }
  }


 
Future<String> uploadImage(String imagePath) async {
  try {
    var request = http.MultipartRequest('POST', Uri.parse('http://192.168.32.1:3002/static/images'));
    var file = File(imagePath);
    var fileName = file.path.split('/').last;
    print("file name:::::::::::::::::::$fileName");
    print("file path:::::::::::::::::::${file.path}");

        request.files.add(
      await http.MultipartFile.fromPath('image', file.path, filename: fileName),
    );

// request.files.add(
//   await http.MultipartFile.fromPath('image', fileName, filename: fileName),
// );

    print("Image Upload Request: $request");

    var response = await request.send();
    print("Image Upload Response Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      print("Image uploaded successfully");
      return response.stream.bytesToString();
    } else {
      print("Image upload failed. Status code: ${response.statusCode}");
      print("Response body: ${await response.stream.bytesToString()}");
      if (response.statusCode == 404) {
        throw Exception('The server did not find the requested URL.');
      } else {
        throw Exception('Failed to upload image');
      }
    }
  } catch (error) {
    print('Error uploading image: $error');
    if (error is http.ClientException && error.message.contains('404')) {
      throw Exception('no Url Found.');
    } else {
      throw error;
    }
  }
}




void _handleSignUp() async {
  if (_formKey.currentState!.validate()) {
    try {
      print("handling sign up");
      String name = fullname.text;
      String email = mail.text;
      String passwordValue = password.text;
      String mobileValue = mobile.text;
      String genderValue = gender ?? ''; 
      String roleValue = role ?? ''; 

      String imageValue = '';
      if (selectedImage != null) {
       imageValue = await uploadImage(selectedImage!.path);
      }

      print("Signing up as: $name, $email, $passwordValue, $mobileValue, $genderValue, $roleValue");

      Map<String, dynamic> result = await authService.signUp(
        name,
        email,
        passwordValue,
        mobileValue,
        genderValue,
        roleValue,
        imageValue,
      );

      if (result.containsKey('error')) {
        print("Sign-up failed: ${result['error']}");
      } else {
        print("Sign-up successful: ${result['message']}");
      }
    } catch (error) {
      print("Error during sign-up: $error");
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/auth_background.jpeg",
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: fullname,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 27,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            labelText: 'UserName*',
                            labelStyle: TextStyle(
                              color: Color(0xFF7743DB),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Full Name is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: mail,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 27,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Email*',
                            labelStyle: TextStyle(
                              color: Color(0xFF7743DB),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: password,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 27,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Password*',
                            labelStyle: TextStyle(
                              color: Color(0xFF755DC1),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: passwordconf,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 27,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Re-Enter Password',
                            labelStyle: TextStyle(
                              color: Color(0xFF755DC1),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Re-Enter password is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: mobile,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 27,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Mobile*',
                      labelStyle: TextStyle(
                        color: Color(0xFF755DC1),
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 3,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 3,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mobile number is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          value: role,
                          decoration: InputDecoration(
                            labelText: 'Department*',
                            labelStyle: TextStyle(
                              color: Color(0xFF7743DB),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          items: [
                            DropdownMenuItem(child: Text('Engineer'), value: 'Engineer'),
                            DropdownMenuItem(child: Text('Client'), value: 'Client'),
                            DropdownMenuItem(child: Text('Team Leader'), value: 'Team Leader'),
                          ],
                          onChanged: (selectedRole) {
                            setState(() {
                              role = selectedRole as String?;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Department is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: DropdownButtonFormField(
                          value: gender,
                          decoration: InputDecoration(
                            labelText: 'Gender*',
                            labelStyle: TextStyle(
                              color: Color(0xFF7743DB),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          items: [
                            DropdownMenuItem(child: Text('Male'), value: 'Male'),
                            DropdownMenuItem(child: Text('Female'), value: 'Female'),
                          ],
                          onChanged: (selectedValue) {
                            setState(() {
                              gender = selectedValue as String?;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Gender is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Column(
                      children: [
                        if (selectedImage != null)
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: FileImage(selectedImage!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        else
                          Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: Colors.grey[600],
                          ),
                        SizedBox(height: 8),
                        Text(
                          'Upload Image',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Spacer(),
                      Text(
                        "Already Registered? ",
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16.5,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Login',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print("sign up pressed");
                        _handleSignUp();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9F7BFF),
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
