import 'package:flutter/material.dart';
import 'package:pma/admin/widgets/admin_drawer.dart';
import '../../../services/project_service.dart';
import '../../widgets/project_container.dart';

class AllProjects extends StatefulWidget {
  AllProjects({Key? key}) : super(key: key);

  @override
  State<AllProjects> createState() => _AllProjectsState();
}

class _AllProjectsState extends State<AllProjects> {
  late Future<List<Map<String, dynamic>>> projects;

  @override
  void initState() {
    super.initState();
    projects = ProjectService().getAllProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(selectedRoute: '/allprojects'),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: AppBar(
              title: Text(
                'All Projects',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
              ),
              centerTitle: true,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: projects,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
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
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              sectionTitle,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: getColorForSection(sectionStatus),
              ),
            ),
          ),
        ),
        for (var project in sectionProjects)
          LongPressDraggable<Map<String, dynamic>>(
            data: project,
            child: ProjectContainer(
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
                child: ProjectContainer(
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
                      Text('Project Updated to: $newStatus',style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w600)),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.yellowAccent,
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
  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  final sectionPosition = renderBox.localToGlobal(Offset.zero).dy;
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
