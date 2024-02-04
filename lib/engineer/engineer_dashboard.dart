import 'package:flutter/material.dart';
import 'package:pma/components/drawers/engineer_drawer.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';

class EngineerDashboard extends StatefulWidget {
  final String userFullName;

  const EngineerDashboard({super.key,required this.userFullName});

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
        title: Text(' ${widget.userFullName}'),
      ),
      drawer: EngineerDrawer(),
      body: Center(
        child: Text("engineer dashboard"),
      ),
    );
  }
}
