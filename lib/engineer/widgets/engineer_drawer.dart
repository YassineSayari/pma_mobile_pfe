import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pma/const.dart';
import 'package:pma/engineer/screens/myteam/my_team.dart';
import 'package:pma/engineer/screens/projects/my_projects.dart';
import 'package:pma/engineer/screens/risks/my_risks.dart';
import 'package:pma/theme.dart';

import '../../services/authentication_service.dart';
import '../../services/shared_preferences.dart';

class EngineerDrawer extends StatefulWidget {
  final String selectedRoute;

  const EngineerDrawer({Key? key, required this.selectedRoute}) : super(key: key);

  @override
  State<EngineerDrawer> createState() => _EngineerDrawerState();
}

class _EngineerDrawerState extends State<EngineerDrawer> {
  final SharedPrefs sharedPrefs = GetIt.instance<SharedPrefs>();
  late Map<String, String> userInfo = {};
  late String? userId = " ";

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
        userId = data["userId"];
      });
    } catch (error) {
      print("error loading user image");
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
            route: '/engineerdashboard',
          ),
          _buildListTile2(
            icon: Icons.people_outline,
            title: 'My Team',
            route:'/myteam',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyTeam(id: userId)),
              );
            },
          ),
          _buildListTile2(
            icon: Icons.layers,
            title: 'My Projects',
            route:'/engineer_projects',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyProjects(id: userId)),
              );
            },
          ),
          _buildListTile(
            icon: Icons.task_alt,
            title: 'My Tasks',
            route: '/engineer_tasks',
          ),
          _buildListTile2(
            icon: Icons.shield_outlined,
            title: 'Risks',
            route: '/engineer_risks',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyRisks()),
              );
            },
            selected: widget.selectedRoute == '/engineer_risks',
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
  Widget _buildListTile2({required IconData icon,required String title,VoidCallback? onTap,bool selected = false,required String route}) {
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
          onTap: onTap != null
              ? onTap
              : () {
                  Navigator.pushReplacementNamed(context, route);
                },
          selected: selected,
        ),
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
