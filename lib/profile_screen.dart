import 'package:flutter/material.dart';

import 'models/user_model.dart';
import 'profile_container.dart';
import 'services/shared_preferences.dart';
import 'services/user_service.dart';

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
            // return Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [

            //     Text(
            //       "Welcome, ${currentUser.fullName}",
            //       style: TextStyle(
            //         fontSize: 20,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     Text("Email: ${currentUser.email}"),
            //     Text("Phone: ${currentUser.phone}"),
            //   ],
            // );
          }
        },
      ),
    );
  }
}
