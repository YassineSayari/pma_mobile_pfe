import 'package:flutter/material.dart';
import 'package:pma/components/drawers/admin_drawer.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

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
        title: Text('Admin dashboard'),
      ),
      drawer: AdminDrawer(),
      body:  Center(
        child: Text("admin dashboard"),
      ),
    );
  }
}
