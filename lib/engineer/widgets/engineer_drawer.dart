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

  const EngineerDrawer({super.key, required this.selectedRoute});

  @override
  State<EngineerDrawer> createState() => _EngineerDrawerState();
}

class _EngineerDrawerState extends State<EngineerDrawer> {

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
    } catch (error) {
      print("error loading user image");
    }
  }
  @override
  Widget build(BuildContext context) {

  final Color selectedColor = Color.fromARGB(31, 33, 41, 116);
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
            title: Text('Dashboard',style: customStyle()),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.people_outline),
            title: Text('My Team',style: customStyle()),
            onTap: () {
              Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyTeam(id: userId),
        ),
        );
          },
            selected: widget.selectedRoute == '/myteam',
            selectedTileColor: selectedColor,
          ),
          ListTile(
            leading: Icon(Icons.layers),
            title: Text('My Projects',style: customStyle()),
            onTap: () {
              Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyProjects(id: userId),
          ),
        );
            },
            selected: widget.selectedRoute == '/engineer_projects',
            selectedTileColor: selectedColor,
          ),
          ListTile(
            leading: Icon(Icons.task_alt),
            title: Text('My Tasks',style: customStyle()),
            onTap: () {
                    Navigator.of(context).pushNamed('/engineer_tasks');
                  },
                  selected: widget.selectedRoute == '/engineer_tasks',
                  selectedTileColor: selectedColor,
          ),
          ListTile(
            leading: Icon(Icons.shield_outlined),
            title: Text('Risks',style: customStyle()),
            onTap: () {
              Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyRisks(),
        ),
      );
            },
            selected: widget.selectedRoute == '/engineer_projects',
                  selectedTileColor: selectedColor,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Profile',style: customStyle()),
            onTap: () {
                    Navigator.of(context).pushNamed('/profile');
                  },
                  selected: widget.selectedRoute == '/profile',
                  selectedTileColor: selectedColor,
          ),

          ListTile(
            leading: Icon(Icons.calendar_today_outlined),
            title: Text('Calendar',style: customStyle()),
            onTap: () {
              print("calendar clicked");
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout',style: customStyle()),
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
  
    TextStyle customStyle(){
    return TextStyle(
      fontFamily: AppTheme.fontName,
      fontWeight: FontWeight.w500
    );
  }
}
