import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:pma/custom_appbar.dart';
import 'package:pma/engineer/screens/myteam/team_member_container.dart';
import 'package:pma/engineer/widgets/engineer_drawer.dart';
import 'package:pma/models/user_model.dart';
import 'package:pma/services/project_service.dart';
import 'package:pma/services/user_service.dart';

class MyTeam extends StatefulWidget {
  final String? id;
  MyTeam({Key? key, this.id}) : super(key: key);

  @override
  State<MyTeam> createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam> {
  late Future<List<Map<String, dynamic>>> _teamMembersAndProjectsFuture;
  UserService userService = GetIt.I<UserService>();

  @override
  void initState() {
    super.initState();
    _teamMembersAndProjectsFuture = _initializeData();
  }

  Future<List<Map<String, dynamic>>> _initializeData() async {
    List<Map<String, dynamic>> teamMembersAndProjects = [];
    try {
      final List<Map<String, dynamic>> projectList = await ProjectService().getProjectsByEmployee(widget.id!);
      // Iterate current user projects
      for (var project in projectList) {
        if (project['equipe'] != null && project['equipe'] is List) {
          List<dynamic> equipe = project['equipe'];
          // Iterate members
          for (var member in equipe) {
            // If member is not current user
            if (member['_id'] != widget.id) {
              // Add member ID and project name to the list
              teamMembersAndProjects.add({
                'memberId': member['_id'],
                'projectName': project['Projectname']
              });
              print("found team member: ${member['_id']} for project: ${project['Projectname']}");
            }
          }
        }
      }
    } catch (error) {
      print("Error initializing data: $error");
    }
    return teamMembersAndProjects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: EngineerDrawer(selectedRoute: '/myteam'),
      body: Column(
        children: [
          CustomAppBar(title: "My Team"),
          SizedBox(height: 15.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _teamMembersAndProjectsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<Map<String, dynamic>> teamMembersAndProjects = snapshot.data ?? [];
                    return ListView.builder(
                      itemCount: teamMembersAndProjects.length,
                      itemBuilder: (context, index) {
                        String memberId = teamMembersAndProjects[index]['memberId'];
                        String projectName = teamMembersAndProjects[index]['projectName'];
                        return FutureBuilder<User>(
                          future: userService.getUserbyId(memberId),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (userSnapshot.hasError) {
                              return Center(child: Text('Error: ${userSnapshot.error}'));
                            } else {
                              User user = userSnapshot.data!;
                              return Column(
                                children: [
                                  MemberContainer(user: user, projectName: projectName),
                                  SizedBox(height: 5.h),
                                ],
                              );
                            }
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
