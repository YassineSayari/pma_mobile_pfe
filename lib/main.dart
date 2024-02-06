import 'package:flutter/material.dart';
import 'package:pma/admin/screens/admin_dashboard.dart';
import 'package:pma/authentication/sign_in.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final PageController controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/':(context) =>Signin(controller: controller),
        '/admindashboard':(context)=>AdminDashboard(),
      },
      // UserList(),
    );
  }
}


