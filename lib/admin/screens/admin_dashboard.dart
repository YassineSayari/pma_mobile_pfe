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
          crossAxisCount: 4,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                dashboardBox(
                  title: "All Projects",
                  num: 0,
                  svgSrc: Icon(Icons.business_center_outlined),
                  color: Colors.lightGreen,
                ),

              ]  
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                dashboardBox(
                  title: "Clients",
                  num: 0,
                  svgSrc:  Icon(Icons.group_outlined),
                  color: Colors.lightBlue,
                ),

              ]  
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                dashboardBox(
                  title: "Team Leaders",
                  num: 0,
                  svgSrc: Icon(Icons.person_4_outlined),
                  color: Colors.purple,
                ),

              ]  
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                dashboardBox(
                  title: "Engineers",
                  num: 0,
                  svgSrc: Icon(Icons.person_outlined),
                  color: Colors.orange,
                ),

              ]  
            ),

          ],
        )
    );
  }
  
}
/*<Widget>[
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
              */
