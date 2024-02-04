import 'package:flutter/material.dart';
import 'package:pma/components/drawers/admin_drawer.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';

class AdminDashboard extends StatefulWidget {
  final String userFullName;
  const AdminDashboard({super.key, required this.userFullName});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late Future<List<User>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = UserService().getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.userFullName}'),
      ),
      drawer: AdminDrawer(),
      body: FutureBuilder(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<User> users = snapshot.data as List<User>;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(users[index].fullName),
                  subtitle: Text(users[index].email),
                );
              },
            );
          }
        },
      ),
    );
  }
}
