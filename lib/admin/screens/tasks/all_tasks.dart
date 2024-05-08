import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pma/admin/screens/tasks/task_container.dart';
import 'package:pma/admin/widgets/admin_drawer.dart';
import 'package:pma/admin/widgets/search_bar.dart';
import 'package:pma/custom_appbar.dart';
import 'package:pma/models/task_model.dart';
import 'package:pma/services/task_service.dart';
import 'package:pma/theme.dart';

class AllTasks extends StatefulWidget {
  const AllTasks({super.key});

  @override
  State<AllTasks> createState() => _AllTasksState();
}

class _AllTasksState extends State<AllTasks> {
  late List<Task> allTasks;
  List<Task> displayedTasks = [];
  late Task task;
    String _selectedSortOption=" ";


  @override
  void initState() {
    super.initState();
    allTasks = [];
    TaskService().getAllTasks().then((tasks) {
      setState(() {
        allTasks = tasks;
        displayedTasks = allTasks;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(selectedRoute: '/tasks'),
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
             padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
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
                            TaskContainer(task: displayedTasks[index]),
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
