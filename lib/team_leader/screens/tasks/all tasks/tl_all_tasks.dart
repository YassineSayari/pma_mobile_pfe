import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:pma/admin/widgets/search_bar.dart';
import 'package:pma/custom_appbar.dart';
import 'package:pma/models/task_model.dart';
import 'package:pma/services/shared_preferences.dart';
import 'package:pma/services/task_service.dart';
import 'package:pma/team_leader/screens/tasks/all%20tasks/tl_add_task.dart';
import 'package:pma/team_leader/screens/tasks/tl_tasks_container.dart';
import 'package:pma/team_leader/widgets/teamleader_drawer.dart';
import 'package:pma/theme.dart';

class TlAllTasks extends StatefulWidget {
  const TlAllTasks({super.key});

  @override
  State<TlAllTasks> createState() => _TlAllTasksState();
}

class _TlAllTasksState extends State<TlAllTasks> {
  late List<Task> allTasks;
  List<Task> displayedTasks = [];
  late Task task;
    String _selectedSortOption=" ";

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
void initState() {
  super.initState();   
  _loadUserInfo().then((_) {
    print("current user id:::: $userId");
    TaskService().getTasksByTeamLeader(userId!).then((tasks) {
      setState(() {
        allTasks = tasks;
        displayedTasks = allTasks;
      });
    }).catchError((error) {
      print("Failed to load tasks: $error");
    });
  });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: TeamLeaderDrawer(selectedRoute: '/tlalltasks'),
            floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(context: context, builder: (context) => TlAddTask());
          },
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0.r),
          ),
          child: Icon(
            Icons.add,
            size: 30.sp,
          ),
        ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(title: "Tasks"),
          SizedBox(height: 15.h),
          UserSearchBar(onChanged: onSearchTextChanged,
          onTap: (){
          },
          ), 

          
          SizedBox(height: 10.h),
          
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Row(
              children: [
                Text("Total Tasks : ${displayedTasks.length}",
                style: TextStyle(fontSize:  AppTheme.totalObjectFontSize.sp,fontFamily: AppTheme.fontName,fontWeight: FontWeight.w500
                ),
                ),

                Spacer(),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    _handleSortOption(value);
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      value: 'Priority Ascending',
                      child: ListTile(
                        title: Row(
                          children: [
                            Radio(
                              value: 'Priority Ascending',
                              groupValue: _selectedSortOption,
                              onChanged: (_) {},
                            ),
                            Text('Priority ',
                            style:TextStyle(fontSize: 17.sp),
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_upward_outlined),
                        dense: true,
                      ),
                    ),
                    PopupMenuItem(
                      value: 'Priority Descending',
                      child: ListTile(
                        title: Row(
                          children: [
                            Radio(
                              value: 'Priority Descending',
                              groupValue: _selectedSortOption,
                              onChanged: (_) {},
                            ),
                            Text('Priority ',
                              style:TextStyle(fontSize: 17.sp),
                              ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_downward_rounded),
                        dense: true,
                      ),  
                    ),
                      PopupMenuItem(
                      value: 'Status Ascending',
                      child: ListTile(
                        title: Row(
                          children: [
                            Radio(
                              value: 'Status Ascending',
                              groupValue: _selectedSortOption,
                              onChanged: (_) {},
                            ),
                            Text('Status ',
                            style:TextStyle(fontSize: 17.sp),
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_upward_outlined),
                        dense: true,
                      ),
                    ),
                    PopupMenuItem(
                      value: 'Status Descending',
                      child: ListTile(
                        title: Row(
                          children: [
                            Radio(
                              value: 'Status Descending',
                              groupValue: _selectedSortOption,
                              onChanged: (_) {},
                            ),
                            Text('Status ',
                              style:TextStyle(fontSize: 17.sp),
                              ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_downward_rounded),
                        dense: true,
                      ),
                      
                    ),
                  ],
                  icon: Icon(
                    Icons.swap_vert,
                    size: AppTheme.sortandfilterIconFontSize.sp,
                  ),
                )
              ],
            ),
            
          ),
          Expanded(
            child: displayedTasks.isEmpty
                ? Center(child: SpinKitCubeGrid(color: Colors.blue))
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                    child: ListView.builder(
                      itemCount: displayedTasks.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            TlTaskContainer(task: displayedTasks[index]),
                            SizedBox(height: 5.h),
                          ],
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void onSearchTextChanged(String text) {
    print('Search text changed: $text');
    setState(() {
      displayedTasks = allTasks
          .where((task) => task.title.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  void _handleSortOption(String selectedOption) {
  setState(() {
    _selectedSortOption = selectedOption;
    switch (_selectedSortOption) {
      case 'Priority Ascending':
        _sort((task) => task.priority, ascending: true);
        break;
      case 'Priority Descending':
        _sort((task) => task.priority, ascending: false);
        break;
      case 'Status Ascending':
        _sort((task) => task.status, ascending: true);
        break;
      case 'Status Descending':
        _sort((task) =>task.status, ascending: false);
        break;
    }
  });
}

void _sort<T>(Comparable<T> Function(Task task) getField, {required bool ascending}) {
  displayedTasks.sort((a, b) {
    final aValue = getField(a);
    final bValue = getField(b);
    return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
  });
}
}
