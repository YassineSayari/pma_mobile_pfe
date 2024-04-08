//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma/admin/screens/procesv/all_procesv.dart';
import 'package:pma/admin/screens/reclamations/add_reclamation.dart';
import 'package:pma/admin/screens/reclamations/all_reclamations.dart';
import 'package:pma/admin/screens/clients/add_client.dart';
import 'package:pma/admin/screens/employees/add_employee.dart';
import 'package:pma/admin/screens/projects/add_project.dart';
import 'package:pma/admin/screens/admin_dashboard.dart';
import 'package:pma/admin/screens/clients/all_clients.dart';
import 'package:pma/admin/screens/risks/all_risks.dart';
import 'package:pma/admin/screens/signup_requests.dart';
import 'package:pma/admin/screens/tasks/all_tasks.dart';
import 'package:pma/authentication/sign_in.dart';
import 'package:pma/authentication/sign_up.dart';
//import 'package:pma/calendar/today_page.dart';
import 'package:pma/client/screens/client_dashboard.dart';
import 'package:pma/client/screens/my_reclamations.dart/client_reclamations.dart';
import 'package:pma/client/screens/procesv/client_procesv.dart';
import 'package:pma/client/screens/projects/client_projects.dart';
//import 'package:pma/custom_snackbar.dart';
import 'package:pma/engineer/screens/engineer_dashboard.dart';
import 'package:pma/engineer/screens/tasks/my_tasks..dart';
import 'package:pma/profile/profile_screen.dart';
import 'package:pma/services/authentication_service.dart';
import 'package:pma/services/export_utils.dart';
import 'package:pma/services/procesv_service..dart';
import 'package:pma/services/project_service.dart';
import 'package:pma/services/reclamation_service.dart';
import 'package:pma/services/risk_service.dart';
import 'package:pma/services/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:pma/services/task_service.dart';
import 'package:pma/services/user_service.dart';
import 'package:pma/team_leader/screens/procesv/teamleader_pv.dart';
import 'package:pma/team_leader/screens/reclamations/tl_all_reclamations.dart';
import 'package:pma/team_leader/screens/teamleader_dashboard.dart';

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
  GetIt.instance.registerLazySingleton(() => TaskService());
  GetIt.instance.registerLazySingleton(() => RiskService());
  GetIt.instance.registerLazySingleton(() => ProcesVService());
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
switch (role) {
      case "Admin":
        print('redirecting to admin page');
        setState(() {
          current_page = AdminDashboard();
        });
        break;
      case "Engineer":
        print('redirecting to engineer page');
        setState(() {
          current_page = EngineerDashboard();
        });
        break;
        case "Team Leader":
        print('redirecting to team leader page');
        setState(() {
          current_page = TeamLeaderDashboard();
        });
      case "Client":
        print('redirecting to client page');
        setState(() {
          current_page = ClientDashboard();
        });
        break;
      default:
        print('Unknown role, redirecting to sign in');
        setState(() {
          current_page = Signin(controller: controller);
        });
        break;
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
        '/clientdashboard': (context) => ClientDashboard(),
        '/teamleaderdashboard': (context) => TeamLeaderDashboard(),
        '/engineerdashboard': (context) => EngineerDashboard(),

        '/allprojects':(context)=>AllProjects(),
        '/client_projects':(context)=>ClientProjects(),
        '/addproject':(context)=>AddProject(),

        '/reclamations':(context)=>AllReclamations(),
        '/client_reclamations':(context)=>ClientReclamations(),
        '/tlreclamations':(context)=>TlAllReclamations(),
        '/addreclamation':(context)=>AddReclamation(),

        '/risks':(context)=>AllRisks(),
        '/engineer_tasks':(context)=>EngineerTasks(),

        '/tasks':(context)=>AllTasks(),

        '/procesv':(context)=>AllProcesv(),
        '/client_pv':(context)=>ClientProcesV(),
        '/teamleader_pv':(context)=>TeamLeaderPv(),

        '/allclients':(context)=>AllClients(),
        '/addclient':(context)=>AddClient(),

        '/allemployees':(context)=>AllEmployees(),
        '/addemployee':(context)=>AddEmployee(),

        '/signuprequests':(context)=>SignUpRequests(),
        '/calendar':(context)=>Calendar(),
         // '/calendar':(context)=>TodayPage(),
        '/profile':(context)=>Profile(),

      },

    ),
    );
  }
}



