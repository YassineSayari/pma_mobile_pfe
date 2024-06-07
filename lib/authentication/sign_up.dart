import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:pma/const.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/theme.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController fullname = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordconf = TextEditingController();
  TextEditingController mobile = TextEditingController();
  String? role;
  String? gender;
  File? selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

Future<void> _handleSignUp() async {
  print("SIGNING UPPPPPPPPPP");

  var request = http.MultipartRequest(
    'POST',
    Uri.parse('$baseUrl/api/v1/users/signup'), 
  );

  request.fields['fullName'] = fullname.text;
  request.fields['phone'] = mobile.text;
  request.fields['email'] = mail.text;
  request.fields['password'] = password.text;
  request.fields['mobile'] = mobile.text;
  request.fields['role'] = role!;
  request.fields['gender'] = gender!;

  print("adding image");
  if (selectedImage != null) {
    
    var file = await http.MultipartFile.fromPath(
      'image',
      selectedImage!.path,
      filename: path.basename(selectedImage!.path),
      contentType: MediaType('image', 'jpg'),
    );

    // Access the MIME type of the file
    print("MIME type of the file: ${file.contentType}");

    request.files.add(file);
  }

  print("sending data:::::::::request::::::$request");
  print("request fields:::: ${request.fields},,,,,,,,, request files:::: ${request.files}");

  var response = await request.send();
  print("response::::$response");

  if (response.statusCode == 200) {
    print("Signup successful");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SuccessSnackBar(message: "Signup successfull , waiting for admin confirmation!"),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
    Navigator.of(context).pop();
  } else {
    // Handle error
    print("Signup failed");
  }
}


  Future<void> _signup() async {
    ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
            content: SuccessSnackBar(message: "Signup successfull , waiting for admin confirmation!"),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          );
  Navigator.of(context).pop();
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
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 8.h),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 100.h),
                      TextFormField(
                        controller: fullname,
                        keyboardType: TextInputType.text,
                        style: TextInputDecorations.textStyle,
                        decoration: TextInputDecorations.customInputDecoration(labelText: 'Username'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Full Name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: mail,
                        keyboardType: TextInputType.text,
                        style: TextInputDecorations.textStyle,
                        decoration: TextInputDecorations.customInputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: password,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        style: TextInputDecorations.textStyle,
                        decoration: TextInputDecorations.customInputDecoration(labelText: 'Password'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: passwordconf,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        style: TextInputDecorations.textStyle,
                        decoration: TextInputDecorations.customInputDecoration(labelText: 'Confirm Password'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Re-Enter password is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: mobile,
                        keyboardType: TextInputType.number,
                        style: TextInputDecorations.textStyle,
                        decoration: TextInputDecorations.customInputDecoration(labelText: 'Mobile'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mobile number is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
                      DropdownButtonFormField(
                        value: role,
                        style: TextInputDecorations.textStyle,
                        decoration: TextInputDecorations.customInputDecoration(labelText: 'Role'),
                        items: [
                          DropdownMenuItem(child: Text('Engineer', style: TextStyle(fontSize: 20.sp, fontFamily: AppTheme.fontName)), value: 'Engineer'),
                          DropdownMenuItem(child: Text('Client', style: TextStyle(fontSize: 20.sp, fontFamily: AppTheme.fontName)), value: 'Client'),
                          DropdownMenuItem(child: Text('Team Leader', style: TextStyle(fontSize: 20.sp, fontFamily: AppTheme.fontName)), value: 'Team Leader'),
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
                      SizedBox(height: 10.h),
                      DropdownButtonFormField(
                        value: gender,
                        style: TextInputDecorations.textStyle,
                        decoration: TextInputDecorations.customInputDecoration(labelText: 'Gender'),
                        items: [
                          DropdownMenuItem(child: Text('Male', style: TextStyle(fontSize: 20.sp, fontFamily: AppTheme.fontName)), value: 'Male'),
                          DropdownMenuItem(child: Text('Female', style: TextStyle(fontSize: 20.sp, fontFamily: AppTheme.fontName)), value: 'Female'),
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
                                    image: FileImage(File(selectedImage!.path)),
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
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                              fontSize: 16.5.sp,
                              fontFamily: AppTheme.fontName,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppTheme.fontName,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40.h,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleSignUp,
                        // onPressed:_signup,
                          style: AppButtonStyles.submitButtonStyle,
                          child: Text(
                            'Register',
                            style: AppButtonStyles.submitButtonTextStyle,
                          ),
                        ),
                      ),
                    ],
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
