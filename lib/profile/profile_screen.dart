import 'package:flutter/material.dart';
import 'package:pma/admin/widgets/admin_drawer.dart';
import 'package:pma/client/widgets/client_drawer.dart';
import 'package:pma/engineer/widgets/engineer_drawer.dart';
import 'package:pma/team_leader/widgets/teamleader_drawer.dart';

import '../models/user_model.dart';
import 'profile_container.dart';
import '../services/shared_preferences.dart';
import '../services/user_service.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}
  
class _ProfileState extends State<Profile> {
  late String userId;
  late Future<User> user;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await SharedPrefs.getUserInfo().then((userInfo) {
      setState(() {
        userId = userInfo['userId'] ?? '';
        print("id : $userId");
      });
    });
    user = UserService().getUserbyId(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color(0xff006df1),
      ),
      drawer: _buildDrawer(),
      body: FutureBuilder<User>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            User currentUser = snapshot.data!;
            return ProfileContainer( user: currentUser);
          }
        },
      ),
    );
  }
}
Widget _buildDrawer() {

  return FutureBuilder<String?>(
    future: SharedPrefs().getLoggedUserRoleFromPrefs(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      } else {
        String userRole = snapshot.data ?? '';

        if (userRole == 'Admin') {
          return AdminDrawer(selectedRoute: "/profile");
        } else if (userRole == 'Engineer') {
          return EngineerDrawer(selectedRoute: "/profile");
        } else if (userRole == 'Team Leader') {
          return TeamLeaderDrawer(selectedRoute: "/profile");
        } else {
          return ClientDrawer(selectedRoute: "/profile");
        }
      }
    },
  );
}
