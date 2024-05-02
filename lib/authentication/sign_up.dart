import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pma/theme.dart';


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
XFile? selectedImage;



final ImagePicker _imagePicker = ImagePicker();

  Future<XFile?> _pickImage() async {
      final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage=pickedFile;
      });
              return pickedFile;

    }
  }


Future<void> _handleSignUp() async {
  try {

    if (_formKey.currentState!.validate()) {


      XFile? pickedFile = await _pickImage();
      
      if (pickedFile != null) {
        Map<String, dynamic> userData = {
        'fullname': fullname.text,
        'email': mail.text,
        'password': password.text,
        'mobile': mobile.text,
        'role': role,
        'gender': gender,
      };
        await authService.UploadImageUser(pickedFile,userData);
      }

    }
  } catch (e) {
    print('Error during signup: $e');
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
                      SizedBox(height:10.h),
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
                        decoration: TextInputDecorations.customInputDecoration(labelText: 'Department'),
                        items: [
                          DropdownMenuItem(child: Text('Engineer',style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName)), value: 'Engineer'),
                          DropdownMenuItem(child: Text('Client',style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName)), value: 'Client'),
                          DropdownMenuItem(child: Text('Team Leader',style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName)), value: 'Team Leader'),
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
                          DropdownMenuItem(child: Text('Male',style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName)), value: 'Male'),
                          DropdownMenuItem(child: Text('Female',style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName)), value: 'Female'),
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
                            child: Text('Login',
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              print("sign up pressed");
                              _handleSignUp();
                            }
                          },
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
