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
                          style: TextInputDecorations.textStyle,
                          decoration: TextInputDecorations.customInputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
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
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 15.h),

                        SizedBox(
                          width: double.infinity,
                          height: 40.h,
                          child: ElevatedButton(
                            onPressed: () {
                              print("button works0");
                              if (_formKey.currentState!.validate()) {
                                verifier();
                                print("button works");
                              }
                            },
                            style: AppButtonStyles.submitButtonStyle,
                            child: Text('Login',
                              style: AppButtonStyles.submitButtonTextStyle,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
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
