import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma/admin/widgets/admin_drawer.dart';
import 'package:pma/custom_appbar.dart';
import 'package:pma/services/project_service.dart';
import 'package:pma/services/user_service.dart';
import 'package:pma/theme.dart';

import '../../models/user_model.dart';
import '../../services/shared_preferences.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late Future<List<User>> futureUsers;
  late String userFullName = ' ';
  late String userId;
  late Future<List<Map<String, dynamic>>> projects;
  late Future<List<User>> clients;
  late Future<List<User>> teamLeaders;
  late Future<List<User>> engineers;
  late Future<List<Map<String, dynamic>>> engineerParticipations;
  late Future<List<Map<String, dynamic>>> teamLeaderParticipations;
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await SharedPrefs.getUserInfo().then((userInfo) {
      setState(() {
        userFullName = userInfo['userFullName'] ?? '';
        userId = userInfo['userId'] ?? '';
        print("id : $userId");
      });
    });
    // all projects
    projects = ProjectService().getAllProjects();
    projects.then((projectList) {
      print("projects: ${projectList.length}");
    });
    // clients
    clients = UserService().getAllClients();
    teamLeaders = UserService().getTeamLeaders();
    print('team leaders ::: $teamLeaders');
    engineers = UserService().getAllEngineers();
    engineerParticipations = ProjectService().fetchEngineersParticipations();
    teamLeaderParticipations = ProjectService().fetchTeamLeaderParticipations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Dashboard'),
      drawer: AdminDrawer(selectedRoute: '/admindashboard'),
      body: ListView(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      // for projects
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: projects,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return _buildCustomContainer(
                              backgroundColor: Colors.lightGreen,
                              icon: Icons.business_center_outlined,
                              title: 'All Projects',
                              number: 'Loading...',
                            );
                          } else if (snapshot.hasData) {
                            return _buildCustomContainer(
                              backgroundColor: Colors.lightGreen,
                              icon: Icons.business_center_outlined,
                              title: 'All Projects',
                              number: '${snapshot.data!.length}',
                            );
                          } else {
                            return _buildCustomContainer(
                              backgroundColor: Colors.redAccent,
                              icon: Icons.error_outline,
                              title: 'All Projects',
                              number: '0',
                            );
                          }
                        },
                      ),
                      SizedBox(width: 5.w),
                      // for clients
                      FutureBuilder<List<User>>(
                        future: clients,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return _buildCustomContainer(
                              backgroundColor: Colors.lightBlue,
                              icon: Icons.person_2_outlined,
                              title: 'Clients',
                              number: 'Loading...',
                            );
                          } else if (snapshot.hasData) {
                            return _buildCustomContainer(
                              backgroundColor: Colors.lightBlue,
                              icon: Icons.person_2_outlined,
                              title: 'Clients',
                              number: '${snapshot.data!.length}',
                            );
                          } else {
                            return _buildCustomContainer(
                              backgroundColor: Colors.redAccent,
                              icon: Icons.error_outline,
                              title: 'Clients',
                              number: '0',
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      // for team leaders
                      FutureBuilder<List<User>>(
                        future: teamLeaders,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return _buildCustomContainer(
                              backgroundColor: Colors.purple,
                              icon: Icons.person_4_outlined,
                              title: 'Team Leader',
                              number: 'Loading...',
                            );
                          } else if (snapshot.hasData) {
                            return _buildCustomContainer(
                              backgroundColor: Colors.purple,
                              icon: Icons.person_4_outlined,
                              title: 'Team Leader',
                              number: '${snapshot.data!.length}',
                            );
                          } else {
                            return _buildCustomContainer(
                              backgroundColor: Colors.redAccent,
                              icon: Icons.error_outline,
                              title: 'Team Leader',
                              number: '0',
                            );
                          }
                        },
                      ),
                      SizedBox(width: 5.w),
                      // for engineers
                      FutureBuilder<List<User>>(
                        future: engineers,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return _buildCustomContainer(
                              backgroundColor: Colors.orange,
                              icon: Icons.person_outline_outlined,
                              title: 'Engineer',
                              number: 'Loading...',
                            );
                          } else if (snapshot.hasData) {
                            return _buildCustomContainer(
                              backgroundColor: Colors.orange,
                              icon: Icons.person_outline_outlined,
                              title: 'Engineer',
                              number: '${snapshot.data!.length}',
                            );
                          } else {
                            return _buildCustomContainer(
                              backgroundColor: Colors.redAccent,
                              icon: Icons.error_outline,
                              title: 'Engineer',
                              number: '0',
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Top engineer participations in projects",
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 20.sp,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 300,
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: projects,
                        builder: (context, projectSnapshot) {
                          if (projectSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (projectSnapshot.hasError) {
                            return Center(child: Text('Error: ${projectSnapshot.error}'));
                          } else if (!projectSnapshot.hasData || projectSnapshot.data!.isEmpty) {
                            return Center(child: Text('No data found'));
                          } else {
                            return FutureBuilder<List<Map<String, dynamic>>>(
                              future: engineerParticipations,
                              builder: (context, participationSnapshot) {
                                if (participationSnapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (participationSnapshot.hasError) {
                                  return Center(child: Text('Error: ${participationSnapshot.error}'));
                                } else if (!participationSnapshot.hasData || participationSnapshot.data!.isEmpty) {
                                  return Center(child: Text('No data found'));
                                } else {
                                  return CustomBarChart(
                                    projectCount: projectSnapshot.data!.length,
                                    engineerParticipations: participationSnapshot.data!,
                                  );
                                }
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Top Team Leaders Leading projects",
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 20.sp,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 300,
                      child:  FutureBuilder<List<Map<String, dynamic>>>(
                        future: projects,
                        builder: (context, projectSnapshot) {
                          if (projectSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (projectSnapshot.hasError) {
                            return Center(child: Text('Error: ${projectSnapshot.error}'));
                          } else if (!projectSnapshot.hasData || projectSnapshot.data!.isEmpty) {
                            return Center(child: Text('No data found'));
                          } else {
                            return FutureBuilder<List<Map<String, dynamic>>>(
                              future: teamLeaderParticipations,
                              builder: (context, participationSnapshot) {
                                if (participationSnapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (participationSnapshot.hasError) {
                                  return Center(child: Text('Error: ${participationSnapshot.error}'));
                                } else if (!participationSnapshot.hasData || participationSnapshot.data!.isEmpty) {
                                  return Center(child: Text('No data found'));
                                } else {
                                  return TeamLeadersChart(
                                    projectCount: projectSnapshot.data!.length,
                                    teamLEaderParticipations: participationSnapshot.data!,
                                  );
                                }
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomContainer({
    required Color backgroundColor,
    required IconData icon,
    required String title,
    required String number,
  }) {
    return Container(
      padding: EdgeInsets.all(8.0.r),
      width: 165.w,
      height: 65.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontSize: 14.sp,
                ),
              ),
              Icon(icon),
            ],
          ),
          SizedBox(height: 5.h), 
          Text(
            number,
            style: TextStyle(
              fontFamily: AppTheme.fontName,
              fontWeight: FontWeight.w500,
              fontSize: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBarChart extends StatelessWidget {
  final int projectCount;
  final List<Map<String, dynamic>> engineerParticipations;

  CustomBarChart({
    required this.projectCount,
    required this.engineerParticipations,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        groupsSpace: 50,
        backgroundColor: Color.fromARGB(66, 131, 184, 215),
        maxY: projectCount.toDouble(),
        gridData: FlGridData(
          drawHorizontalLine: true,
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(show: false),
        barGroups: engineerParticipations.asMap().entries.map((entry) {
          int index = entry.key;
          var participation = entry.value;
          var user = participation['user'];
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: (participation['projects'] ?? 0).toDouble(),
                color: Colors.blue,
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                var index = value.toInt();
                if (index < engineerParticipations.length) {
                  var user = engineerParticipations[index]['user'];
                  return Text(
                    user != null ? user['fullName'] : 'N/A',
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: AppTheme.fontName,
                      fontSize: 20,
                    ),
                  );
                }
                return Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
class TeamLeadersChart extends StatelessWidget {
    final int projectCount;
  final List<Map<String, dynamic>> teamLEaderParticipations;

  TeamLeadersChart({
    required this.projectCount,
    required this.teamLEaderParticipations,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        groupsSpace: 50,
        backgroundColor: Color.fromARGB(66, 131, 184, 215),
        maxY: projectCount.toDouble(),
        gridData: FlGridData(
          drawHorizontalLine: true,
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(show: false),
        barGroups: teamLEaderParticipations.asMap().entries.map((entry) {
          int index = entry.key;
          var participation = entry.value;
          var user = participation['user'];
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: (participation['projects'] ?? 0).toDouble(),
                color: Colors.blue,
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                var index = value.toInt();
                if (index < teamLEaderParticipations.length) {
                  var user = teamLEaderParticipations[index]['user'];
                  return Text(
                    user != null ? user['fullName'] : 'N/A',
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: AppTheme.fontName,
                      fontSize: 17,
                    ),
                  );
                }
                return Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}