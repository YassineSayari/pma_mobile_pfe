import 'package:flutter/material.dart';

class ClientDrawer extends StatelessWidget {
  const ClientDrawer({super.key});

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
            leading: Icon(Icons.dashboard_customize_outlined),
            title: Text('Dashboard'),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.insert_chart_outlined),
            title: Text('Proces-Verbal'),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Projects'),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(Icons.receipt_long),
            title: Text('My Reclamations'),
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
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
            },
          ),
        ],

      ),
    );
  }
}
