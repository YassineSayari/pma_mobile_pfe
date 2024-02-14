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
      appBar: AppBar(
        title: Text('All Projects'),
      ),
      drawer: AdminDrawer(selectedRoute: '/allprojects'),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: projects,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Map<String, dynamic>> allProjects = snapshot.data ?? [];

            List<Map<String, dynamic>> pendingProjects = allProjects
                .where((project) => project['status'] == 'Pending')
                .toList();
            List<Map<String, dynamic>> inProgressProjects = allProjects
                .where((project) => project['status'] == 'In Progress')
                .toList();
            List<Map<String, dynamic>> onHoldProjects = allProjects
                .where((project) => project['status'] == 'On Hold')
                .toList();
            List<Map<String, dynamic>> completedProjects = allProjects
                .where((project) => project['status'] == 'Completed')
                .toList();

            return ListView(
              children: [
                _buildSection('New Projects ', pendingProjects),
                _buildSection('In Progress ', inProgressProjects),
                _buildSection('On Hold ', onHoldProjects),
                _buildSection('Completed ', completedProjects),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildSection(String sectionTitle, List<Map<String, dynamic>> projects) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            sectionTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        for (var project in projects)
          LongPressDraggable<Map<String, dynamic>>(
            data: project,
            child: ProjectContainer(
              projectName: project['Projectname'] ?? '',
              type: project['type'] ?? '',
              status: project['status'] ?? '',
              description: project['description'] ?? '',
              dateDebut: project['dateDebut'] ?? '',
              teamLeaderId: project['TeamLeader']['fullName'] ?? '',
              priority: project['priority'] ?? '',
              dateFin: project['dateFin'] ?? '',
              client: project['client']['fullName'] ?? '',
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
                  teamLeaderId: project['TeamLeader']['fullName'] ?? '',
                  priority: project['priority'] ?? '',
                  dateFin: project['dateFin'] ?? '',
                  client: project['client']['fullName'] ?? '',
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
            onDragEnd: (details) {
            },
            onDragCompleted: () {
            },
          ),
        SizedBox(height: 20),
      ],
    );
  }
}
