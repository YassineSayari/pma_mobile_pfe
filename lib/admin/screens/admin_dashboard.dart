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
        body: GridView.count(
        crossAxisCount: 2,
          children: [
            DashboardBox(title: 'All project', value: 0, background: Colors.green),
          //  SizedBox(height: 16),
            DashboardBox(title: 'Client', value: 0, background: Colors.blue),
          //  SizedBox(height: 16),
            DashboardBox(title: 'Team Leader', value: 0, background: Colors.purple),
            //SizedBox(height: 16),
            DashboardBox(title: 'Engineer', value: 0, background: Colors.orange),
          ],
        ),
       
        /* Center(
        child: Text("admin dashboard"),
      ),*/
    );
  }
}