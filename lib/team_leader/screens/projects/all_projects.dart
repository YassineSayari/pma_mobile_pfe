import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/services/shared_preferences.dart';
import 'package:pma/team_leader/screens/projects/tl_project_container.dart';
import 'package:pma/team_leader/widgets/teamleader_drawer.dart';
import 'package:pma/theme.dart';
import '../../../custom_appbar.dart';
import '../../../services/project_service.dart';
class TlAllProjects extends StatefulWidget {
  TlAllProjects({Key? key}) : super(key: key);

  @override
  State<TlAllProjects> createState() => _TlAllProjectsState();
}

class _TlAllProjectsState extends State<TlAllProjects> {
  late Future<List<Map<String, dynamic>>> projects;

  @override
  void initState() {
    super.initState();
    _loadUserInfo().then((_) {
    print("current user id:::: $userId");
    projects = ProjectService().getProjectsByTeamLeader(userId!);
    });
  }

 final SharedPrefs sharedPrefs = GetIt.instance<SharedPrefs>();
  late Map<String, String> userInfo = {};
  late String? userId = " ";
    Future<void> _loadUserInfo() async {
    try {
      final data = await SharedPrefs.getUserInfo();
      setState(() {
        userInfo = data;
        userId = data["userId"];
        print("user loaded::::::: id $userId");
      });
    } catch (error) {
      print("error loading user image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: TeamLeaderDrawer(selectedRoute: '/tlprojects'),
      body: Column(
        children: [
          CustomAppBar(title: 'Projects'),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: projects,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: SpinKitCubeGrid(color: Colors.blueAccent));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Map<String, dynamic>> allProjects = snapshot.data ?? [];
                  return ListView(
                    children: [
                      _buildSection('New Projects', 'Pending', allProjects),
                      _buildSection('In Progress', 'In Progress', allProjects),
                      _buildSection('On Hold', 'On Hold', allProjects),
                      _buildSection('Completed', 'Completed', allProjects),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      String sectionTitle, String sectionStatus, List<Map<String, dynamic>> allProjects) {
    List<Map<String, dynamic>> sectionProjects = allProjects
        .where((project) => project['status'] == sectionStatus)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
          child: Center(
            child: Text(
              sectionTitle,
              style: TextStyle(
                fontSize: 35.sp,
                fontWeight: FontWeight.bold,
                color: getColorForSection(sectionStatus),
                fontFamily: AppTheme.fontName
              ),
            ),
          ),
        ),
        for (var project in sectionProjects)
          LongPressDraggable<Map<String, dynamic>>(
            data: project,
            child: TlProjectContainer(
              projectId: project['_id'],
              projectName: project['Projectname'] ?? '',
              type: project['type'] ?? '',
              status: project['status'] ?? '',
              description: project['description'] ?? '',
              dateDebut: project['dateDebut'] ?? '',
              teamLeaderId: project['TeamLeader']?['fullName'] ?? '',
              priority: project['priority'] ?? '',
              dateFin: project['dateFin'] ?? '',
              client: project['client']?['fullName'] ?? '',
              equipe: project['equipe'] ?? [],
              progress: project['progress'] ?? 0,
            ),
            feedback: Material(
              elevation: 5.0,
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TlProjectContainer(
                  projectName: project['Projectname'] ?? '',
                  type: project['type'] ?? '',
                  status: project['status'] ?? '',
                  description: project['description'] ?? '',
                  dateDebut: project['dateDebut'] ?? '',
                  teamLeaderId:
                      project['TeamLeader']?['fullName'] ?? '',
                  priority: project['priority'] ?? '',
                  dateFin: project['dateFin'] ?? '',
                  client: project['client']?['fullName'] ?? '',
                  equipe: project['equipe'] ?? [],
                  progress: project['progress'] ?? 0,
                ),
              ),
            ),
            childWhenDragging: SizedBox.shrink(),
            onDragStarted: () {
              // Add any necessary logic when dragging starts
            },
            onDraggableCanceled: (velocity, offset) {
              // Add any necessary logic when draggable is canceled
            },
            onDragEnd: (details) async {
              // Implement logic when drag ends
              String newStatus =
                  determineNewStatus(details.offset, sectionTitle,context);
              print("new status::::::$newStatus");

              await ProjectService().updateProjectStatus(
                project['_id'],
                newStatus,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      SuccessSnackBar(message: 'Project Updated to: $newStatus'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                 ),
              );
              Navigator.of(context).pushReplacementNamed('/allprojects');

            },
            onDragCompleted: () {
            },
          ),
        SizedBox(height: 20),
      ],
    );
  }

String determineNewStatus(Offset dropPosition, String sectionTitle, BuildContext context) {

  // find the container on ui
  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  //calculate top position of container
  final sectionPosition = renderBox.localToGlobal(Offset.zero).dy;
  //set start point in the middle of container
  final threshold = sectionPosition + renderBox.size.height / 2;

  if (dropPosition.dy > threshold) {
    switch (sectionTitle) {
      //if dropped from new projects drop->in progress
      case 'New Projects':
        return 'In Progress';
      case 'In Progress':
        return 'On Hold';
      case 'On Hold':
        return 'Completed';
      default:
        return 'On Hold';
    }
  } else {
    switch (sectionTitle) {
      case 'In Progress':
        return 'Pending';
      case 'On Hold':
        return 'In Progress';
      case 'Completed':
        return 'On Hold';
      default:
        return '';
    }
  }
}


  Color getColorForSection(String section) {
    switch (section) {
      case 'New Projects':
        return Colors.red;
      case 'In Progress':
        return Color.fromARGB(255, 122, 147, 180);
      case 'On Hold':
        return Colors.orange;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
