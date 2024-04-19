import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pma/client/screens/projects/client_projects.dart';
import 'package:pma/const.dart';
import 'package:pma/services/authentication_service.dart';
import 'package:pma/services/shared_preferences.dart';
import 'package:pma/theme.dart';

class ClientDrawer extends StatefulWidget {
    final String selectedRoute;
  const ClientDrawer({super.key, required this.selectedRoute});

  @override
  State<ClientDrawer> createState() => _ClientDrawerState();
}

class _ClientDrawerState extends State<ClientDrawer> {

    final SharedPrefs sharedPrefs = GetIt.instance<SharedPrefs>();
  late Map<String, String> userInfo={};
  late String? userId=" ";

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
        userId=data["userId"];
      });
      print("user id drawer::::: $userId");
    } catch (error) {
      // Handle error
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final userImage = userInfo['userImage'];
    final userImageUrl =
        userImage != null ?  "$imageUrl/$userImage":"$noImageUrl";
    print(userImageUrl);
    
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
            route: '/clientdashboard',
          ),
          _buildListTile(
            icon: Icons.insert_chart_outlined,
            title: 'Proces-Verbal',
            route: '/client_pv',
          ),
          _buildListTile2(
            icon: Icons.shield_outlined,
            title: 'Projects',
            route: '/client_projects',
            onTap: () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ClientProjects(id: userId),
        ),
      );
           },
          ),
          _buildListTile2(
            icon: Icons.shield_outlined,
            title: 'My Reclamations',
            route: '/client_reclamations',
            onTap: () {
                    Navigator.of(context).pushReplacementNamed('/client_reclamations');
                  },
                  selected: widget.selectedRoute == '/client_reclamations',
          ),
          _buildListTile(
            icon: Icons.settings,
            title: 'Profile',
            route: '/profile',
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
