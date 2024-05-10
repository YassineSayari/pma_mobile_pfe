import 'package:flutter/material.dart';
import 'package:pma/admin/widgets/admin_drawer.dart';
import 'package:pma/models/dashboardBox.dart';

import '../../models/user_model.dart';
import '../../services/shared_preferences.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late Future<List<User>> futureUsers;
  late String userFullName = ' ';
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
      drawer: AdminDrawer(selectedRoute: '/admindashboard'),
      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        childAspectRatio: 2,  
        crossAxisSpacing: 10,
        padding: EdgeInsets.all(10), 
        children: <Widget>[
          dashboardBox(
            title: "All Projects",
            num: 0,
            svgSrc: Icon(Icons.business_center_outlined),
            color: Colors.lightGreen,
          ),
          dashboardBox(
            title: "Clients",
            num: 0,
            svgSrc: Icon(Icons.group_outlined),
            color: Colors.lightBlue,
          ),
          dashboardBox(
            title: "Team Leaders",
            num: 0,
            svgSrc: Icon(Icons.person_4_outlined),
            color: Colors.purple,
          ),
          dashboardBox(
            title: "Engineers",
            num: 0,
            svgSrc: Icon(Icons.person_outlined),
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}
