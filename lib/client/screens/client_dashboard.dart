import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma/custom_appbar.dart';
import 'package:pma/services/project_service.dart';
import 'package:pma/services/shared_preferences.dart';
import 'package:pma/theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../widgets/client_drawer.dart';

class ClientDashboard extends StatefulWidget {
  const ClientDashboard({super.key});

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {
    late String userFullName;
    late String userId='';
    late List<Data> _chartData=[];
    late Future<List<Map<String, dynamic>>> projects;
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
  projects = ProjectService().getProjectsByClient(userId);
  projects.then((projectList) {
    print("projects: ${projectList.length}");
  });
  chartData = _fetchChartData();
  chartData.then((data) {
    setState(() {
      _chartData = data;
    });
  });
}

     Future<List<Data>> _fetchChartData() async {
    final projectList = await ProjectService().getProjectsByClient(userId);
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
    drawer: ClientDrawer(selectedRoute: '/clientdashboard'),
    appBar: CustomAppBar(title: 'Dashboard'),
     body: ListView(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Column(
                children: [
                  Row(
                    children: [

                        // running projects
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: projects,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return _buildCustomContainer(
                              backgroundColor: Colors.lightGreen,
                              icon: Icons.business_center_outlined,
                              title: 'Running Projects',
                              number: 'Loading...',
                            );
                          } else if (snapshot.hasData) {
                            var runningProjects = snapshot.data!.where((project) {
                            return project['status'] == 'In Progress' || project['status'] == 'On Hold';
                          }).toList();
                            return _buildCustomContainer(
                              backgroundColor: Colors.lightGreen,
                              icon: Icons.business_center_outlined,
                              title: 'Running Projects',
                              number: '${runningProjects.length}',
                            );
                          } else {
                            return _buildCustomContainer(
                              backgroundColor: Colors.redAccent,
                              icon: Icons.error_outline,
                              title: 'Running Projects',
                              number: '0',
                            );
                          }
                        },
                      ),
                      // _buildCustomContainer(
                      //   backgroundColor: Colors.lightGreen,
                      //   icon: Icons.confirmation_num_outlined,
                      //   title: 'Running Projects',
                      //   number: '0',
                      // ),
                      SizedBox(width: 5.w),
                      //complete projects
                        FutureBuilder<List<Map<String, dynamic>>>(
                        future: projects,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return _buildCustomContainer(
                              backgroundColor: Colors.lightBlue,
                              icon: Icons.confirmation_num_outlined,
                              title: 'Complete Projects',
                              number: 'Loading...',
                            );
                          } else if (snapshot.hasData) {
                            var completeProjects = snapshot.data!.where((project) {
                            return project['status'] == 'Completed';
                          }).toList();
                            return _buildCustomContainer(
                              backgroundColor: Colors.lightBlue,
                              icon: Icons.confirmation_num_outlined,
                              title: 'Complete Projects',
                              number: '${completeProjects.length}',
                            );
                          } else {
                            return _buildCustomContainer(
                              backgroundColor: Colors.redAccent,
                              icon: Icons.error_outline,
                              title: 'Complete Projects',
                              number: '0',
                            );
                          }
                        },
                      ),
                      // _buildCustomContainer(
                      //   backgroundColor: Colors.lightBlue,
                      //   icon: Icons.confirmation_num_outlined,
                      //   title: 'Complete Projects',
                      //   number: '2',
                      // ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      //complete projects
                        FutureBuilder<List<Map<String, dynamic>>>(
                        future: projects,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return _buildCustomContainer(
                              backgroundColor: Colors.purple,
                              icon: Icons.confirmation_num_outlined,
                              title: 'All Projects',
                              number: 'Loading...',
                            );
                          } else if (snapshot.hasData) {
                            return _buildCustomContainer(
                              backgroundColor: Colors.purple,
                              icon: Icons.confirmation_num_outlined,
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
                      // _buildCustomContainer(
                      //   backgroundColor: Colors.purple,
                      //   icon: Icons.confirmation_num_outlined,
                      //   title: 'All Projects',
                      //   number: '3',
                      // ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: Text(
                      "Project Progress Details",
                      style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w500,
                        fontSize: 30.sp,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 500,
                      child: CustomRadialChart(chartData: _chartData), // Use the radial chart widget
                    ),
                  ),
                  SizedBox(height: 10.h),
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
                overflow: TextOverflow.clip,
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
