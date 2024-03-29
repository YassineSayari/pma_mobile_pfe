import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pma/theme.dart';
import '../../const.dart';
import '../../services/authentication_service.dart';
import '../../services/shared_preferences.dart';



class AdminDrawer extends StatefulWidget {
  final String selectedRoute;

  const AdminDrawer({super.key, required this.selectedRoute});

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {

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
      // Handle error
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
            title: Text('Dashboard',style: customStyle()),
            onTap: (){
              Navigator.pushNamed(context, '/admindashboard');
            },
            selected: widget.selectedRoute == '/admindashboard',
            selectedTileColor: selectedColor,
          ),
          ExpansionTile(
            leading: Icon(Icons.folder_copy),
            title: Text('Projects',style: customStyle()),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  title: Text('All Projects',style: customStyle()),
                  onTap: () {
                    Navigator.pushNamed(context,'/allprojects');
                  },
                  selected: widget.selectedRoute == '/allprojects',
                  selectedTileColor: selectedColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  title: Text('Add Project',style: customStyle()),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/addproject');
                  },
                  selected: widget.selectedRoute == '/addproject',
                  selectedTileColor: selectedColor,
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.people_outlined),
            title: Text('Employees',style: customStyle()),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  title: Text('All Employees',style: customStyle()),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/allemployees');
                  },
                  selected: widget.selectedRoute == '/allemployees',
                  selectedTileColor: selectedColor,

                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  title: Text('Add Employee',style: customStyle()),
                  onTap: () {
                        Navigator.of(context).pushNamed('/addemployee');
                  },
                  selected: widget.selectedRoute == '/addemployee',
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.person),
            title: Text('Clients',style: customStyle()),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  title: Text('All Clients',style: customStyle()),
                  onTap: () {
                    Navigator.of(context).pushNamed('/allclients');
                  },
                  selected: widget.selectedRoute == '/allclients',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  title: Text('Add Client',style: customStyle()),
                  onTap: () {
                    Navigator.pushNamed(context,'/addclient');
                  },
                  selected: widget.selectedRoute == '/addclient',

                ),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Signup-Requests',style: customStyle()),
            onTap: () {
              Navigator.pushNamed(context,'/signuprequests');
            },
            selected: widget.selectedRoute == '/signuprequests',
          ),
          ListTile(
            leading: Icon(Icons.receipt_long),
            title: Text('Reclamations',style: customStyle()),
            onTap: () {
               Navigator.of(context).pushNamed('/reclamations');
            },
            selected: widget.selectedRoute == '/reclamations',
                  selectedTileColor: selectedColor,
          ),
          ListTile(
            leading: Icon(Icons.shield_outlined),
            title: Text('Risks',style: customStyle()),
            onTap: () {
               Navigator.of(context).pushNamed('/risks');
                  },
                  selected: widget.selectedRoute == '/risks',
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
            title: Text('Calendar',style: customStyle(),),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/calendar');
            },
            selected: widget.selectedRoute == '/calendar',
            selectedTileColor: selectedColor,

          ),
          ListTile(
            leading: Icon(Icons.task_alt),
            title: Text('Task',style: customStyle()),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/tasks');
            },
            selected: widget.selectedRoute == '/tasks',
            selectedTileColor: selectedColor,

          ),
          ListTile(
            leading: Icon(Icons.insert_chart_outlined),
            title: Text('Proces-Verbal',style: customStyle()),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/procesv');
            },
            selected: widget.selectedRoute == '/procesv',
            selectedTileColor: selectedColor,
          ),
          ListTile(
            leading: Icon(Icons.email_outlined),
            title: Text('Email',style: customStyle()),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout',style: customStyle(),),
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
