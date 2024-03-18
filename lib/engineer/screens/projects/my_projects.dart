import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pma/engineer/screens/projects/engineer_project_container.dart';
import 'package:pma/engineer/widgets/engineer_drawer.dart';
import 'package:pma/theme.dart';
import '../../../custom_appbar.dart';
import '../../../services/project_service.dart';
class MyProjects extends StatefulWidget {
  final String? id;
  MyProjects({Key? key, this.id}) : super(key: key);

  @override
  State<MyProjects> createState() => _MyProjectsState();
}

class _MyProjectsState extends State<MyProjects> {
  late Future<List<Map<String, dynamic>>> projects;

  @override
  void initState() {
    super.initState();
    projects = ProjectService().getProjectsByEmployee(widget.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: EngineerDrawer(selectedRoute: '/engineer_projects'),
      body: Column(
        children: [
          CustomAppBar(title: 'My Projects'),
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
            child: MyProjectContainer(
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
            feedback: Material(
              elevation: 5.0,
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: MyProjectContainer(
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
            },
            onDraggableCanceled: (velocity, offset) {
            },
            onDragEnd: (details) async {
            },
            onDragCompleted: () {
            },
          ),
        SizedBox(height: 20),
      ],
    );
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
