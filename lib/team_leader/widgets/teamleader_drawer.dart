import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pma/const.dart';
import 'package:pma/services/authentication_service.dart';
import 'package:pma/services/shared_preferences.dart';
import 'package:pma/theme.dart';

class TeamLeaderDrawer extends StatefulWidget {
    final String selectedRoute;

  const TeamLeaderDrawer({super.key, required this.selectedRoute});

  @override
  State<TeamLeaderDrawer> createState() => _TeamLeaderDrawerState();
}

class _TeamLeaderDrawerState extends State<TeamLeaderDrawer> {
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
            onTap: (){

            },
          ),
          ExpansionTile(
            leading: Icon(Icons.task_alt),
            title: Text('tasks',style: customStyle()),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  title: Text('Tasks',style: customStyle()),
                  onTap: () {
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  title: Text('My Tasks',style: customStyle()),
                  onTap: () {
                  },
                ),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.insert_chart_outlined),
            title: Text('Proces-Verbal',style: customStyle()),
            onTap: () {
                    Navigator.of(context).pushReplacementNamed('/teamleader_pv');
                  },
                  selected: widget.selectedRoute == '/teamleader_pv',
          ),
          ListTile(
            leading: Icon(Icons.folder),
            title: Text('All Projects',style: customStyle()),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(Icons.receipt_long),
            title: Text('Client Claims',style: customStyle()),
           onTap: () {
                    Navigator.of(context).pushReplacementNamed('/tlreclamations');
                  },
                  selected: widget.selectedRoute == '/tlreclamations',
          ),

          ListTile(
            leading: Icon(Icons.shield_outlined),
            title: Text('Risks',style: customStyle()),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Profile',style: customStyle()),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/profile');
            },
            selected: widget.selectedRoute == '/profile',
          ),
          ListTile(
            leading: Icon(Icons.calendar_today_outlined),
            title: Text('Calendar',style: customStyle()),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/calendar');
            },
            selected: widget.selectedRoute == '/calendar',
          ),

          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout',style: customStyle()),
            onTap: () {
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
