import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pma/theme.dart';
import '../../const.dart';
import '../../services/authentication_service.dart';
import '../../services/shared_preferences.dart';

class AdminDrawer extends StatefulWidget {
  final String selectedRoute;

  const AdminDrawer({Key? key, required this.selectedRoute}) : super(key: key);

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  final SharedPrefs sharedPrefs = GetIt.instance<SharedPrefs>();
  late Map<String, String> userInfo = {};

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final data = await SharedPrefs.getUserInfo();
      setState(() {
        userInfo = data;
      });
    } catch (error) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final userImage = userInfo['userImage'];
    final userImageUrl = userImage != null ? "$imageUrl/$userImage" : "$noImageUrl";

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(userImageUrl),
            ),
          ),
          _buildListTile(
            icon: Icons.tv,
            title: 'Dashboard',
            route: '/admindashboard',
          ),
          _buildExpansionTile(
            icon: Icons.folder_copy,
            title: 'Projects',
            children: [
              _buildSubListTile(title: 'All Projects', route: '/allprojects'),
              _buildSubListTile(title: 'Add Project', route: '/addproject'),
            ],
          ),
          _buildExpansionTile(
            icon: Icons.people_outlined,
            title: 'Employees',
            children: [
              _buildSubListTile(title: 'All Employees', route: '/allemployees'),
              _buildSubListTile(title: 'Add Employee', route: '/addemployee'),
            ],
          ),
          _buildExpansionTile(
            icon: Icons.person,
            title: 'Clients',
            children: [
              _buildSubListTile(title: 'All Clients', route: '/allclients'),
              _buildSubListTile(title: 'Add Client', route: '/addclient'),
            ],
          ),
          _buildListTile(
            icon: Icons.people,
            title: 'Signup-Requests',
            route: '/signuprequests',
          ),
          _buildListTile(
            icon: Icons.receipt_long,
            title: 'Reclamations',
            route: '/reclamations',
          ),
          _buildListTile(
            icon: Icons.shield_outlined,
            title: 'Risks',
            route: '/risks',
          ),
          _buildListTile(
            icon: Icons.settings,
            title: 'Profile',
            route: '/profile',
          ),
          _buildListTile(
            icon: Icons.calendar_today_outlined,
            title: 'Calendar',
            route: '/calendar',
          ),
          _buildListTile(
            icon: Icons.task_alt,
            title: 'Task',
            route: '/tasks',
          ),
          _buildListTile(
            icon: Icons.insert_chart_outlined,
            title: 'Proces-Verbal',
            route: '/procesv',
          ),
          _buildListTile(
            icon: Icons.email_outlined,
            title: 'Email',
            route:'/',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:6.0),
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'Logout',
                style: AppTheme.defaultItemStyle,
              ),
              onTap: () {
                print("logout clicked");
                _handleLogout(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({required IconData icon, required String title, required String route}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: widget.selectedRoute == route ? AppColors.selectedTileBackgroundColor : null,
        ),
        child: ListTile(
          leading: Icon(icon,color: widget.selectedRoute == route ? AppColors.selectedDrawerIconColor : AppColors.defaultDrawerIconColor),
          title: Text(
            title,
            style: widget.selectedRoute == route ? AppTheme.selectedItemStyle : AppTheme.defaultItemStyle,
          ),
          onTap: () {
            Navigator.pushNamed(context, route);
          },
          selected: widget.selectedRoute == route,
        ),
      ),
    );
  }

  Widget _buildSubListTile({required String title, required String route}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: widget.selectedRoute == route ? AppColors.selectedTileBackgroundColor : null,
        ),
        child: ListTile(
          title: Text(
            title,
            style: widget.selectedRoute == route ? AppTheme.selectedItemStyle : AppTheme.defaultItemStyle,
          ),
          onTap: () {
            Navigator.pushNamed(context, route);
          },
          selected: widget.selectedRoute == route,
        ),
      ),
    );
  }

  Widget _buildExpansionTile({required IconData icon, required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:6.0),
      child: ExpansionTile(
        leading: Icon(icon,color: AppColors.defaultDrawerIconColor),
        title: Text(title, style: AppTheme.defaultItemStyle),
        children: children,
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
