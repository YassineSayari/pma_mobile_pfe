import 'package:flutter/material.dart';
import 'package:pma/admin/widgets/admin_drawer.dart';

import '../../models/user_model.dart';
import '../../services/shared_preferences.dart';
import '../../models/dashboardBox.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late Future<List<User>> futureUsers;
  late String userFullName= ' ';
  late String userId;


  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await SharedPrefs.getUserInfo().then((userInfo) {
      setState(() {
        userFullName = userInfo['userFullName'] ?? '';
        userId = userInfo['userId'] ?? '';
        print("id : $userId");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin dashboard, user: $userFullName'),
      ),
      drawer:AdminDrawer(selectedRoute: '/admindashboard'),
        body:
         Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DashboardBox(title: 'Box 1', value: 42),
            SizedBox(height: 16),
            DashboardBox(title: 'Box 2', value: 99),
            SizedBox(height: 16),
            DashboardBox(title: 'Box 3', value: 123),
            SizedBox(height: 16),
            DashboardBox(title: 'Box 4', value: 789),
          ],
        ),
      ), 
        /* Center(
        child: Text("admin dashboard"),
      ),*/
    );
  }
}