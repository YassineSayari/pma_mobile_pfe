import 'package:flutter/material.dart';
import 'package:pma/admin/screens/add_client.dart';
import 'package:pma/admin/screens/add_employee.dart';
import 'package:pma/admin/screens/admin_dashboard.dart';
import 'package:pma/admin/screens/all_clients.dart';
import 'package:pma/authentication/sign_in.dart';
import 'package:pma/authentication/sign_up.dart';
import 'package:pma/engineer/screens/engineer_dashboard.dart';
import 'package:pma/services/authentication_service.dart';
import 'package:pma/services/export_utils.dart';
import 'package:pma/services/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:pma/services/user_service.dart';

import 'admin/screens/all_employees.dart';

void setupLocator() {
  GetIt.instance.registerLazySingleton(() => SharedPrefs());
  GetIt.instance.registerLazySingleton(() => AuthService());
  GetIt.instance.registerLazySingleton(() => UserService());
  GetIt.instance.registerLazySingleton(() => ExportEmployees());


}


void main() {
  setupLocator();
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PageController controller = PageController(initialPage: 0);
  late Widget current_page = Container();

  SharedPrefs sharedPrefs = GetIt.I<SharedPrefs>();

  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    print("============= INITIALIZE ID ===============");
    var id = await sharedPrefs.getLoggedUserIdFromPrefs();
    var role = await sharedPrefs.getLoggedUserRoleFromPrefs();

    print('Role: $role, ID: $id');


    if (id != null) {
      if (role=="Admin"){
        print('redirecting to admin page');
        setState(() {
          current_page = AdminDashboard();
        });
      }
      else if(role=="Engineer")
        {
          print('redirecting to engineer page');
          setState(() {
            current_page = EngineerDashboard();
          });
        }

    } else {
      print("redirecting to sign in");
      setState(() {
        current_page = Signin(controller: controller);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => current_page,
        '/signin':(context) =>Signin(controller: controller),
        '/signup':(context) =>SignUp(controller: controller),

        '/admindashboard': (context) => AdminDashboard(),
        '/engineerdashboard': (context) => EngineerDashboard(),

        '/allclients':(context)=>AllClients(),
        '/addclient':(context)=>AddClient(),

        '/allemployees':(context)=>AllEmployees(),
        '/addemployee':(context)=>AddEmployee(),

      },
      // UserList(),
    );
  }
}



