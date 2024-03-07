//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma/admin/reclamations/all_reclamations.dart';
import 'package:pma/admin/screens/clients/add_client.dart';
import 'package:pma/admin/screens/employees/add_employee.dart';
import 'package:pma/admin/screens/projects/add_project.dart';
import 'package:pma/admin/screens/admin_dashboard.dart';
import 'package:pma/admin/screens/clients/all_clients.dart';
import 'package:pma/admin/screens/signup_requests.dart';
import 'package:pma/authentication/sign_in.dart';
import 'package:pma/authentication/sign_up.dart';
//import 'package:pma/custom_snackbar.dart';
import 'package:pma/engineer/screens/engineer_dashboard.dart';
import 'package:pma/profile/profile_screen.dart';
import 'package:pma/services/authentication_service.dart';
import 'package:pma/services/export_utils.dart';
import 'package:pma/services/project_service.dart';
import 'package:pma/services/reclamation_service.dart';
import 'package:pma/services/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:pma/services/user_service.dart';

import 'admin/screens/employees/all_employees.dart';
import 'admin/screens/projects/all_projects.dart';
import 'calendar.dart';
import 'services/event_service.dart';

void setupLocator() {
  GetIt.instance.registerLazySingleton(() => SharedPrefs());
  GetIt.instance.registerLazySingleton(() => AuthService());
  GetIt.instance.registerLazySingleton(() => UserService());
  GetIt.instance.registerLazySingleton(() => ProjectService());
  GetIt.instance.registerLazySingleton(() => ReclamationService());
  GetIt.instance.registerLazySingleton(() => EventService());
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
    print("...initializing id...");
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
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: false,
      splitScreenMode: true,
      builder: (context,child)=>MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => current_page,
        //'/':(context)=>CustomSnackBar(),
        '/signin':(context) =>Signin(controller: controller),
        '/signup':(context) =>SignUp(controller: controller),

        '/admindashboard': (context) => AdminDashboard(),
        '/engineerdashboard': (context) => EngineerDashboard(),

        '/allprojects':(context)=>AllProjects(),
        '/addproject':(context)=>AddProject(),

        '/reclamations':(context)=>AllReclamations(),

        '/allclients':(context)=>AllClients(),
        '/addclient':(context)=>AddClient(),

        '/allemployees':(context)=>AllEmployees(),
        '/addemployee':(context)=>AddEmployee(),

        '/signuprequests':(context)=>SignUpRequests(),
        '/calendar':(context)=>Calendar(),

        '/profile':(context)=>Profile(),

      },

    ),
    );
  }
}



