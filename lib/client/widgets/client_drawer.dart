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
            leading: Icon(Icons.dashboard_customize_outlined),
            title: Text('Dashboard',style: customStyle()),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.insert_chart_outlined),
            title: Text('Proces-Verbal',style: customStyle()),
            onTap: () {
                    Navigator.of(context).pushReplacementNamed('/client_pv');
                  },
                  selected: widget.selectedRoute == '/client_pv',
                  selectedTileColor: selectedColor,
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Projects',style: customStyle()),
            onTap: () {
              
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ClientProjects(id: userId),
        ),
      );
    
           },
          ),
          ListTile(
            leading: Icon(Icons.receipt_long),
            title: Text('My Reclamations',style: customStyle()),
            onTap: () {
                    Navigator.of(context).pushReplacementNamed('/client_reclamations');
                  },
                  selected: widget.selectedRoute == '/client_reclamations',
                  selectedTileColor: selectedColor,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Profile',style: customStyle()),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/profile');
            },
            selected: widget.selectedRoute == '/profile',
                  selectedTileColor: selectedColor,
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
