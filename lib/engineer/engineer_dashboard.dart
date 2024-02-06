import 'package:flutter/material.dart';
import 'package:pma/components/drawers/engineer_drawer.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';

class EngineerDashboard extends StatefulWidget {

  const EngineerDashboard({super.key});

  @override
  State<EngineerDashboard> createState() => _EngineerDashboardState();
}

class _EngineerDashboardState extends State<EngineerDashboard> {
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
        title: Text('welcome'),
      ),
      drawer: EngineerDrawer(),
      body: Center(
        child: Text("engineer dashboard"),
      ),
    );
  }
}
