import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/authentication_service.dart';
import '../../services/shared_preferences.dart';

const ip = "192.168.0.17";
const port = 3002;

class EngineerDrawer extends StatefulWidget {
    final String selectedRoute;

  const EngineerDrawer({super.key, required this.selectedRoute});

  @override
  State<EngineerDrawer> createState() => _EngineerDrawerState();
}

class _EngineerDrawerState extends State<EngineerDrawer> {
    final String imageUrl="http://$ip:$port/static/images";
    final String noImageUrl ="http://$ip:$port/static/images/16-02-2024--no-image.jpg";
    final SharedPrefs sharedPrefs = GetIt.instance<SharedPrefs>();

  late Map<String, String> userInfo={};

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
    }
  }
  @override
  Widget build(BuildContext context) {

    final Color selectedColor = Colors.white12;
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
                    Navigator.of(context).pushNamed('/profile');
                  },
                  selected: widget.selectedRoute == '/profile',
                  selectedTileColor: selectedColor,
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
