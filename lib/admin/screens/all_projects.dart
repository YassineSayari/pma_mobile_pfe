import 'package:flutter/material.dart';
import '../../models/project_model.dart';
import '../../services/project_service.dart';
import '../widgets/project_container.dart';



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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: projects,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Map<String, dynamic>> projects = snapshot.data ?? [];
            return ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                // Use ProjectContainer instead of ListTile
                return ProjectContainer(
                  projectName: projects[index]['Projectname']?? '',
                  status:projects[index]['status']?? '',
                  description: projects[index]['description']?? '',
                  dateDebut: projects[index]['dateDebut']?? '',
                  teamLeaderId: projects[index]['TeamLeader']['fullName']?? '',
                  priority: projects[index]['priority']?? '',
                  dateFin: projects[index]['dateFin']?? '',
                  client: projects[index]['client']['fullName']?? '',
                  equipe: projects[index]['equipe'] ?? [],
                  progress: projects[index]['progress']?? '',
                );
              },
            );
          }
        },
      ),
    );
  }
}



/*class AllProjects extends StatefulWidget {
  @override
  _AllProjectsState createState() => _AllProjectsState();
}

class _AllProjectsState extends State<AllProjects> {
  List<Project> projects = [];

  @override
  void initState() {
    super.initState();
    loadProjects();
  }

  Future<void> loadProjects() async {
    try {
      List<Project> fetchedProjects = await ProjectService().getAllProjects();
      print("fetched projects : $fetchedProjects");

      setState(() {
        projects = fetchedProjects;
      });
    } catch (error) {
      // Handle error
      print('Error loading projects: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Container'),
      ),
      body: projects != null
          ? ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return ProjectContainer(projects[index]);
        },
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
*/