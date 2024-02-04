import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

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
          ExpansionTile(
            leading: Icon(Icons.folder_copy),
            title: Text('Projects'),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  title: Text('All Projects'),
                  onTap: () {
                    // Handle tap for All Projects
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  title: Text('Add Project'),
                  onTap: () {
                  },
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

                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  title: Text('Add Employee'),
                  onTap: () {

                  },
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

                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  title: Text('Add Client'),
                  onTap: () {
                  },
                ),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Signup-Requests'),
            onTap: () {
            },
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
            },
          ),
        ],

      ),
    );
  }
}
