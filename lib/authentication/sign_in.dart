import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/services/authentication_service.dart';
import 'package:pma/theme.dart';

import '../services/shared_preferences.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key, required this.controller}) : super(key: key);
  final PageController controller;


  @override
  State<Signin> createState() => SigninState();
}

class SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();

  final AuthService authService=AuthService();
  final TextEditingController mail = TextEditingController();
  final TextEditingController password = TextEditingController();



  @override
  void initState() {
    super.initState();

 }

  bool log = false;
  bool mdp = false;
  String email = "";

  void verifier() async {
    print("verifying sign up");
    try {
      final Map<String, dynamic> result = await authService.login(
        mail.text.trim(),
        password.text.trim(),
      );
      print(result);

      if (result.containsKey('token')) {
        print('Login successful');

        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: SuccessSnackBar(message: "Login Successfull !"),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );

          List<dynamic> roles = result['roles'];
          String userRole = roles.isNotEmpty ? roles[0] : '';

          //save in shared prefs
          SharedPrefs.saveUserInfo(
            result['id'] ?? '',
            result['fullName'] ?? '',
            result['email'] ?? '',
            userRole,
             result['image'] ?? '',
          );

      SharedPrefs.saveAuthToken(result['token']);

      switch (userRole) {
      case "Admin":
        print('redirecting to admin page');
        setState(() {
           Navigator.pushReplacementNamed(
              context,'/admindashboard',
            );
        });
        break;
      case "Team Leader":
        print('redirecting to team leader page');
        setState(() {
          Navigator.pushReplacementNamed(
              context,'/teamleaderdashboard',
            );
        });
        break;  
      case "Engineer":
        print('redirecting to engineer page');
        setState(() {
          Navigator.pushReplacementNamed(
              context,'/engineerdashboard',
            );
        });
        break;
      case "Client":
        print('redirecting to client page');
        setState(() {
          Navigator.pushReplacementNamed(
              context,'/clientdashboard',
            );
        });
        break;
      default:
        print('Unknown role, redirecting to sign in');
        break;
    }
   }
   else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: FailSnackBar(message: "Wrong email or password !"),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
   }
    } catch (error) {
      print('Login error: $error');
      
    }
  }



@override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/auth_bg.jpeg",
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        TextFormField(
                          controller: mail,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 27.sp,
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            labelText:'Email',
                            labelStyle: TextStyle(
                              color: Color(0xFF7743DB),
                            fontSize: 25.sp,
                            fontFamily: AppTheme.fontName,
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
                              return 'Please enter an email';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 16),

                        TextFormField(
                          controller: password,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 27.sp,
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Color(0xFF755DC1),
                            fontSize: 25.sp,
                            fontFamily: AppTheme.fontName,
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
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 16),

                        SizedBox(
                          width: 300,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              print("button works0");
                              if (_formKey.currentState!.validate()) {
                                verifier();
                                print("button works");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9F7BFF),
                            ),
                            child: Text('Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.sp,
                                 fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Spacer(),
                            Text(
                               "Need an account? ",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 16.5.sp,
                                fontFamily: AppTheme.fontName,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                               Navigator.pushNamed(context,'/signup');
                              },
                              child: Text('Subscribe!',
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
