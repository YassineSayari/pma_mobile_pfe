import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pma/const.dart';
import 'package:pma/services/authentication_service.dart';
import 'package:pma/services/shared_preferences.dart';
import 'package:pma/theme.dart';

class TeamLeaderDrawer extends StatefulWidget {
  final String selectedRoute;

  const TeamLeaderDrawer({Key? key, required this.selectedRoute}) : super(key: key);

  @override
  State<TeamLeaderDrawer> createState() => _TeamLeaderDrawerState();
}

class _TeamLeaderDrawerState extends State<TeamLeaderDrawer> {
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
            icon: Icons.dashboard_customize_outlined,
            title: 'Dashboard',
            route: '/admindashboard',
          ),
          _buildExpansionTile(
            icon: Icons.task_alt,
            title: 'tasks',
            children: [
              _buildSubListTile(title: 'Tasks', route: '/tlalltasks'),
              _buildSubListTile(title: 'My Tasks', route: '/tltasks'),
            ],
          ),
          _buildListTile(
            icon: Icons.insert_chart_outlined,
            title: 'Proces-Verbal',
            route: '/teamleader_pv',
          ),
          _buildListTile(
            icon: Icons.folder,
            title: 'All Projects',
            route: '/tlprojects',
          ),
          _buildListTile(
            icon: Icons.receipt_long,
            title: 'Client Claims',
            route: '/tlreclamations',
          ),
          _buildListTile(
            icon: Icons.shield_outlined,
            title: 'Risks',
            route: '/tlrisks',
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

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String route,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: widget.selectedRoute == route ? AppColors.selectedTileBackgroundColor : null,
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: widget.selectedRoute == route ? AppColors.selectedDrawerIconColor : AppColors.defaultDrawerIconColor,
          ),
          title: Text(
            title,
            style: widget.selectedRoute == route ? AppTheme.selectedItemStyle : AppTheme.defaultItemStyle,
          ),
          onTap: onTap != null
              ? onTap
              : () {
                  Navigator.pushReplacementNamed(context, route);
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
