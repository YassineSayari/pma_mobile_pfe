import 'package:flutter/material.dart';
import 'package:pma/team_leader/widgets/teamleader_drawer.dart';

class TeamLeaderDashboard extends StatelessWidget {
  const TeamLeaderDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: TeamLeaderDrawer(selectedRoute: '/dashboard'),
      body: Center(
        child: Text("team leader dashboard"),
      ),
    );
  }
}