import 'package:flutter/material.dart';
import 'package:pma/admin/screens/admin_dashboard.dart';
import 'package:pma/authentication/sign_in.dart';
import 'package:pma/engineer/screens/engineer_dashboard.dart';
import 'package:pma/services/authentication_service.dart';
import 'package:pma/services/shared_preferences.dart';
import 'package:get_it/get_it.dart';

void setupLocator() {
  GetIt.instance.registerLazySingleton(() => SharedPrefs());
  GetIt.instance.registerLazySingleton(() => AuthService());

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
    print("================ INITIALIZE ID ================");
    var id = await sharedPrefs.getLoggedUserIdFromPrefs();
    var role = await sharedPrefs.getLoggedUserRoleFromPrefs();

    if (id != null) {
      if (role=="admin"){
        setState(() {
          current_page = AdminDashboard();
        });
      }
      else if(role=="engineer")
        {
          setState(() {
            current_page = EngineerDashboard();
          });
        }

    } else {
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
        '/admindashboard': (context) => AdminDashboard(),
        '/engineerdashboard': (context) => EngineerDashboard(),
      },
      // UserList(),
    );
  }
}



