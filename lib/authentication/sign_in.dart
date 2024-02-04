import 'package:flutter/material.dart';
import 'package:pma/services/user_service.dart';
import 'package:pma/test_users.dart';

import '../admin/admin_dashboard.dart';
import '../engineer/engineer_dashboard.dart';


class Signin extends StatefulWidget {
  const Signin({Key? key, required this.controller}) : super(key: key);
  final PageController controller;


  @override
  State<Signin> createState() => SigninState();
}

class SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();

  final UserService userService=UserService();
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
    try {
      final Map<String, dynamic> result = await userService.login(
        mail.text.trim(),
        password.text.trim(),
      );
      print(result);

      // Check if the login was successful
      if (result.containsKey('token')) {
      /*  Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => UserList(),
          ),
        );*/
        print('Login successful');
        if (result.containsKey('token')) {
          List<dynamic> roles = result['roles'];
          String userRole = roles.isNotEmpty ? roles[0] : '';

          if (userRole == 'Admin') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminDashboard(),
              ),
            );
          } else if (userRole == 'Engineer') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EngineerDashboard(),
              ),
            );
          }
        }
      } else {

        print('check mail or password ');
        showErrorMessage(result['error'] ?? 'Failed to login');
      }
    } catch (error) {
      // Handle the error
      print('Login error: $error');
      showErrorMessage('Failed to login. Please try again.');

    }
  }
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }



@override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/pmm.png",
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
                            fontSize: 27,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            labelText:'Email',
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
                            fontSize: 27,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Password',
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
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 16),

                        // Login Button
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
                                fontSize: 30,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),



                        SizedBox(height: 10),


                        // Text below the buttons
                        Row(
                          children: [
                            Text(
                               "Need an account? ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.5,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                               /* Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Subscribe(controller: widget.controller)),
                                );*/
                              },
                              child: Text('Subscribe!',
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
