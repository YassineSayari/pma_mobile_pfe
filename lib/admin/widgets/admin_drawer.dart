import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/authentication_service.dart';

class AdminDrawer extends StatelessWidget {
  final String selectedRoute;

  const AdminDrawer({super.key, required this.selectedRoute});

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Colors.white12;
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
            onTap: (){
              Navigator.pushNamed(context, '/admindashboard');
            },
            selected: selectedRoute == '/admindashboard',
            selectedTileColor: selectedColor,
          ),
          ExpansionTile(
            leading: Icon(Icons.folder_copy),
            title: Text('Projects'),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  title: Text('All Projects'),
                  onTap: () {
                    Navigator.pushNamed(context,'/allprojects');
                  },
                  selected: selectedRoute == '/allprojects',
                  selectedTileColor: selectedColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  title: Text('Add Project'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/addproject');
                  },
                  selected: selectedRoute == '/addproject',
                  selectedTileColor: selectedColor,
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.people_outlined),
            title: Text('Employees'),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  title: Text('All Employees'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/allemployees');
                  },
                  selected: selectedRoute == '/allemployees',
                  selectedTileColor: selectedColor,

                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  title: Text('Add Employee'),
                  onTap: () {
                        Navigator.of(context).pushNamed('/addemployee');
                  },
                  selected: selectedRoute == '/addemployee',
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.person),
            title: Text('Clients'),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  title: Text('All Clients'),
                  onTap: () {
                    Navigator.of(context).pushNamed('/allclients');
                  },
                  selected: selectedRoute == '/allclients',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  title: Text('Add Client'),
                  onTap: () {
                    Navigator.pushNamed(context,'/addclient');
                  },
                  selected: selectedRoute == '/addclient',

                ),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Signup-Requests'),
            onTap: () {
              Navigator.pushNamed(context,'/signuprequests');
            },
            selected: selectedRoute == '/signuprequests',
          ),
          ListTile(
            leading: Icon(Icons.receipt_long),
            title: Text('Reclamations'),
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
            },
          ),
          ListTile(
            leading: Icon(Icons.task_alt),
            title: Text('Task'),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(Icons.insert_chart_outlined),
            title: Text('Proces-Verbal'),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(Icons.email_outlined),
            title: Text('Email'),
            onTap: () {
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
