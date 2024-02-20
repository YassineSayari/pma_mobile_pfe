import 'package:flutter/material.dart';
import 'package:pma/engineer/widgets/engineer_drawer.dart';
import '../../services/shared_preferences.dart';

class EngineerDashboard extends StatefulWidget {

  const EngineerDashboard({super.key});

  @override
  State<EngineerDashboard> createState() => _EngineerDashboardState();
}

class _EngineerDashboardState extends State<EngineerDashboard> {

  late String userFullName;

  late String userId='';


  @override
  void initState() {
    super.initState();



    SharedPrefs.getUserInfo().then((userInfo) {
      setState(() {
        userFullName = userInfo['userFullName'] ?? '';
        userId = userInfo['userId'] ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard, $userFullName'),
      ),
      drawer: EngineerDrawer(selectedRoute: '/engineerdashboard'),
      body: Center(
        child: Text("engineer dashboard"),
      ),
    );
  }
}
