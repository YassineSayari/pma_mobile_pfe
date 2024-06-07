import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma/custom_appbar.dart';
import 'package:pma/engineer/widgets/engineer_drawer.dart';
import 'package:pma/models/task_model.dart';
import 'package:pma/services/project_service.dart';
import 'package:pma/services/task_service.dart';
import 'package:pma/theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../services/shared_preferences.dart';

class EngineerDashboard extends StatefulWidget {

  const EngineerDashboard({super.key});

  @override
  State<EngineerDashboard> createState() => _EngineerDashboardState();
}

class _EngineerDashboardState extends State<EngineerDashboard> {

  late String userFullName;

  late String userId='';
  late Future<List<Map<String, dynamic>>> projects;
  late Future<List<Task>> newTasks;
  late Future<List<Task>> openTasks;
  late Future<List<Task>> closedTasks;
  late Future<List<Data>> chartData;


  @override
  void initState() {
     _initializeData();
    super.initState();

    
  }
   Future<void> _initializeData() async {
await SharedPrefs.getUserInfo().then((userInfo) {
      setState(() {
        userFullName = userInfo['userFullName'] ?? '';
        userId = userInfo['userId'] ?? '';
        print("id : $userId");
      });
    });
    projects = ProjectService().getProjectsByEmployee(userId);
    projects.then((projectList) {
      print("projects: ${projectList.length}");
    });
    newTasks=TaskService().getTasksByExecutor(userId);
    openTasks= TaskService().getOpenTasks();
    closedTasks= TaskService().getClosedTasks();
    chartData = _fetchChartData();
   }
     Future<List<Data>> _fetchChartData() async {
    final projectList = await ProjectService().getProjectsByEmployee(userId);
    return projectList.map((project) {
      return Data(
        project['Projectname'],
        project['progress'], 
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Dashboard"),
      drawer: EngineerDrawer(selectedRoute: '/engineerdashboard'),
      body: ListView(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      FutureBuilder<List<Task>>(
                              future: newTasks,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return _buildCustomContainer(
                                    backgroundColor: Colors.lightGreen,
                                    icon: Icons.task_alt_outlined,
                                    title: 'New Tasks',
                                    number: 'Loading...',
                                  );
                                } else if (snapshot.hasData) {
                                  var pendingTasks = snapshot.data!.where((task) => task.status == 'Pending').toList();
                                  return _buildCustomContainer(
                                    backgroundColor: Colors.lightGreen,
                                    icon: Icons.task_alt_outlined,
                                    title: 'New Tasks',
                                    number: '${pendingTasks.length}',
                                  );
                                } else {
                                  return _buildCustomContainer(
                                    backgroundColor: Colors.redAccent,
                                    icon: Icons.error_outline,
                                    title: 'New Tasks',
                                    number: '0',
                                  );
                                }
                              },
                            ),
                      // _buildCustomContainer(
                      //   backgroundColor: Colors.lightGreen,
                      //   icon: Icons.confirmation_num_outlined,
                      //   title: 'New Tasks',
                      //   number: '3',
                      // ),
                      SizedBox(width: 5.w),

                      //Closed tasks
                           FutureBuilder<List<Task>>(
                              future: closedTasks,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return _buildCustomContainer(
                                    backgroundColor: Colors.lightBlue,
                                    icon: Icons.done_outline_outlined,
                                    title: 'Tasks Closed',
                                    number: 'Loading...',
                                  );
                                } else if (snapshot.hasData) {
                                  return _buildCustomContainer(
                                    backgroundColor: Colors.lightBlue,
                                    icon: Icons.done_outline_outlined,
                                    title: 'Tasks Closed',
                                    number: '${snapshot.data!.length}',
                                  );
                                } else {
                                  return _buildCustomContainer(
                                    backgroundColor: Colors.redAccent,
                                    icon: Icons.error_outline,
                                    title: 'Tasks Closed',
                                    number: '0',
                                  );
                                }
                              },
                            ),
                      // _buildCustomContainer(
                      //   backgroundColor: Colors.lightBlue,
                      //   icon: Icons.task_alt_outlined,
                      //   title: 'Tasks Closed',
                      //   number: '2',
                      // ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      //open tasks

                      //Closed tasks
                           FutureBuilder<List<Task>>(
                              future: openTasks,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return _buildCustomContainer(
                                    backgroundColor: Colors.purple,
                                    icon: Icons.pending_actions_outlined,
                                    title: 'Tasks Open',
                                    number: 'Loading...',
                                  );
                                } else if (snapshot.hasData) {
                                  return _buildCustomContainer(
                                    backgroundColor: Colors.purple,
                                    icon: Icons.pending_actions_outlined,
                                    title: 'Tasks Open',
                                    number: '${snapshot.data!.length}',
                                  );
                                } else {
                                  return _buildCustomContainer(
                                    backgroundColor: Colors.redAccent,
                                    icon: Icons.error_outline,
                                    title: 'Tasks Open',
                                    number: '0',
                                  );
                                }
                              },
                            ),
                      // _buildCustomContainer(
                      //   backgroundColor: Colors.purple,
                      //   icon: Icons.list_alt_outlined,
                      //   title: 'Tasks Open',
                      //   number: '0',
                      // ),
                      SizedBox(width: 5.w),

                       // for projects
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: projects,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return _buildCustomContainer(
                              backgroundColor: Colors.orange,
                              icon: Icons.business_center_outlined,
                              title: 'Projects Assigned',
                              number: 'Loading...',
                            );
                          } else if (snapshot.hasData) {
                            return _buildCustomContainer(
                              backgroundColor: Colors.orange,
                              icon: Icons.business_center_outlined,
                              title: 'Projects Assigned',
                              number: '${snapshot.data!.length}',
                            );
                          } else {
                            return _buildCustomContainer(
                              backgroundColor: Colors.redAccent,
                              icon: Icons.error_outline,
                              title: 'Projects Assigned',
                              number: '0',
                            );
                          }
                        },
                      ),
                      // _buildCustomContainer(
                      //   backgroundColor: Colors.orange,
                      //   icon: Icons.business_center_outlined,
                      //   title: 'Projects Assigned',
                      //   number: '4',
                      // ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Project Progress",
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 30.sp,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 500,
                      child: FutureBuilder<List<Data>>(
                                future: chartData,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasData) {
                                    return CustomRadialChart(chartData: snapshot.data!);
                                  } else {
                                    return Center(child: Text('No data available'));
                                  }
                                },
                              ), // Use the radial chart widget
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

class CustomRadialChart extends StatelessWidget {
  final List<Data> chartData;

  const CustomRadialChart({required this.chartData});

  @override
  Widget build(BuildContext context) {
    int totalProgress = 0;
    for (var data in chartData) {
      totalProgress += data.progress;
    }
    double averageProgress = chartData.isNotEmpty
        ? totalProgress / chartData.length
        : 0; // Calculate the average progress

    return Stack(
      alignment: Alignment.center,
      children: [
        SfCircularChart(
          legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
            textStyle: TextStyle(
              fontFamily: AppTheme.fontName,
              fontSize: 20.sp,
            ),
          ),
          series: <CircularSeries>[
            RadialBarSeries<Data, String>(
              dataSource: chartData,
              xValueMapper: (Data data, _) => data.project,
              yValueMapper: (Data data, _) => data.progress,
              dataLabelSettings: DataLabelSettings(isVisible: true),
              maximumValue: 100,
            )
          ],
        ),
        Positioned(
          top: 270,
          child: Column(
            children: [
              Text(
                'Average',
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(' ${averageProgress.round()}%',
              style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}


class Data {
  Data(this.project, this.progress);
  final String project;
  final int progress;
}
