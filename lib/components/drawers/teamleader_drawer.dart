import 'package:flutter/material.dart';

class TeamLeader extends StatelessWidget {
  const TeamLeader({super.key});

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
            leading: Icon(Icons.task_alt),
            title: Text('tasks'),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  title: Text('Tasks'),
                  onTap: () {
                    // Handle tap for All Projects
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  title: Text('My Tasks'),
                  onTap: () {
                  },
                ),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.insert_chart_outlined),
            title: Text('Proces-Verbal'),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(Icons.folder),
            title: Text('All Projects'),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(Icons.receipt_long),
            title: Text('Client Claims'),
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
