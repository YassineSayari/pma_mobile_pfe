import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/authentication_service.dart';

class EngineerDrawer extends StatelessWidget {
  const EngineerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Icon(
              Icons.person,
            ),
          ),
          ListTile(
            leading: Icon(Icons.tv),
            title: Text('Dashboard'),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.people_outline),
            title: Text('My Team'),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(Icons.layers),
            title: Text('My Projects'),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(Icons.task_alt),
            title: Text('My Tasks'),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(Icons.shield_outlined),
            title: Text('Risks'),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Profile'),
            onTap: () {
            },
          ),

          ListTile(
            leading: Icon(Icons.calendar_today_outlined),
            title: Text('Calendar'),
            onTap: () {
              print("calendar clicked");
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              print("logout clicked");

              _handleLogout(context);
            },
          ),
        ],

      ),
    );
  }
  void _handleLogout(BuildContext context) {
    print("handling logout");
    AuthService authService = GetIt.I<AuthService>();
    authService.logout();
    Navigator.of(context).pushReplacementNamed('/signin');
  }
}
