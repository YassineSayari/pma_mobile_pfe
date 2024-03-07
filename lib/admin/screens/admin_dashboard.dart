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

        GridView.count(
  crossAxisCount: 4, // Adjust number for your design
  children: <Widget>[
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          child: Icon(Icons.business_center_outlined),
          backgroundColor: Colors.lightGreen,
          radius: 30,
        ),
        Text('All Projects'),
        Text('0'),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          child: Icon(Icons.group_outlined),
          backgroundColor: Colors.lightBlue,
          radius: 30,
        ),
        Text('Client'),
        Text('0'),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          child: Icon(Icons.person_4_outlined),
          backgroundColor: Colors.purple,
          radius: 30,
        ),
        Text('Team Leader'),
        Text('0'),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          child: Icon(Icons.person_outlined),
          backgroundColor: Colors.orange,
          radius: 30,
        ),
        Text('Engineer'),
        Text('0'),
      ],
    ),
  ],
)



        /*GridView.count(
        crossAxisCount: 2,
          children: [
            DashboardBox(
              title: "All project",
              value: 0,
              background: Colors.green[100]!,
              ),
            DashboardBox(
              title: 'Client',
              value: 0,
              background: Colors.blue[100]!,
              ),
            DashboardBox(
              title: 'Team Leader',
              value: 0,
              background: Colors.purple[100]!,
              ),
            DashboardBox(
              title: 'Engineer',
              value: 0,
              background: Colors.orange[100]!,
              ),
          ],
        ),*/
    );
  }
}