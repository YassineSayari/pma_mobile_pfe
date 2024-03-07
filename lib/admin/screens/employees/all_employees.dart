import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:http/http.dart';
import 'package:pma/admin/widgets/admin_drawer.dart';
import 'package:pma/custom_appbar.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/services/user_service.dart';
import 'package:pma/theme.dart';

import '../../../models/user_model.dart';
import '../../../services/export_utils.dart';
import '../../../services/shared_preferences.dart';
import 'package:pma/admin/widgets/search_bar.dart';

import '../../widgets/user_container.dart';





class AllEmployees extends StatefulWidget {
  const AllEmployees({Key? key}) : super(key: key);

  @override
  State<AllEmployees> createState() => _AllEmployeesState();
}

class _AllEmployeesState extends State<AllEmployees> {
  late Future<List<User>> futureUsers;
  late String userId;
  List<User> allUsers = [];
  List<User> employees = [];
  String _selectedSortOption=" ";


  final ExportEmployees exportEmployees = ExportEmployees();



  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await SharedPrefs.getUserInfo().then((userInfo) {
      setState(() {
        userId = userInfo['userId'] ?? '';
        print("id : $userId");
      });
    });

    futureUsers = UserService().getAllUsers();

    await futureUsers.then((users) {
      setState(() {
        allUsers = users;
        employees = allUsers.where((user) => user.isEnabled && !user.roles.contains('Client')).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('employees: $employees');
    return Scaffold(
            drawer: AdminDrawer(selectedRoute: '/allemployees'),

 body: Column(
    children: [
        CustomAppBar(title: "Employees"),
          SizedBox(height: 15.h),
          UserSearchBar(
            onChanged: onSearchTextChanged,
            onTap: (){
                _initializeData();
                print("refresh tapped");
                },
          ), 

          SizedBox(height: 15.h),

          Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
            child: Row(
              children: [
                   Align(
                    alignment: Alignment.topLeft,
                    child: Text("Total Employees : ${employees.length}",style: TextStyle(fontSize: 22.sp,fontFamily: AppTheme.fontName,fontWeight: FontWeight.w500),)
                    ),
                
                Spacer(),
                Icon(Icons.tune_outlined,
                        size: 30.sp,
                        ),
               SizedBox(width: 15.w),            
                PopupMenuButton<String>(
                  onSelected: (value) {
                    _handleSortOption(value);
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      value: 'Name Ascending',
                      child: ListTile(
                        title: Row(
                          children: [
                            Radio(
                              value: 'Name Ascending',
                              groupValue: _selectedSortOption,
                              onChanged: (_) {},
                            ),
                            Text('Name Ascending',
                            style:TextStyle(fontSize: 17.sp),
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_upward_outlined),
                        dense: true,
                      ),
                    ),
                    PopupMenuItem(
                      value: 'Name Descending',
                      child: ListTile(
                        title: Row(
                          children: [
                            Radio(
                              value: 'Name Descending',
                              groupValue: _selectedSortOption,
                              onChanged: (_) {},
                            ),
                            Text('Name Descending',
                              style:TextStyle(fontSize: 17.sp),
                              ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_downward_rounded),
                        dense: true,
                      ),  
                    ),
                                        PopupMenuItem(
                      value: 'Role Ascending',
                      child: ListTile(
                        title: Row(
                          children: [
                            Radio(
                              value: 'Role Ascending',
                              groupValue: _selectedSortOption,
                              onChanged: (_) {},
                            ),
                            Text('Role Ascending',
                            style:TextStyle(fontSize: 17.sp),
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_upward_outlined),
                        dense: true,
                      ),
                    ),
                    PopupMenuItem(
                      value: 'Role Descending',
                      child: ListTile(
                        title: Row(
                          children: [
                            Radio(
                              value: 'Role Descending',
                              groupValue: _selectedSortOption,
                              onChanged: (_) {},
                            ),
                            Text('Role Descending',
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
                    size: 30.sp,
                  ),
                )
              ],
            ),
          ),  

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 4.h),
                  child:
                  ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    print(employees[index].image);
                    return Column(
                      children: [
                        UserContainer(user: employees[index],onDelete: deleteEmployee
                    ),
                        SizedBox(height:5.h),
                      ],
                    );
                  }
                ),
            
                ),
              ),
        ],
      ),
    );
  }


void _handleSortOption(String selectedOption) {
  setState(() {
    _selectedSortOption = selectedOption;
    switch (_selectedSortOption) {
      case 'Name Ascending':
        _sort((user) => user.fullName, ascending: true);
        break;
      case 'Name Descending':
        _sort((user) => user.fullName, ascending: false);
        break;
      case 'Role Ascending':
        _sort((user) => user.roles[0], ascending: true);
        break;
      case 'Role Descending':
        _sort((user) => user.roles[0], ascending: false);
        break;
    }
  });
}



void _sort<T>(Comparable<T> Function(User user) getField, {required bool ascending}) {
  employees.sort((a, b) {
    final aValue = getField(a);
    final bValue = getField(b);
    return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
  });
}

  void deleteEmployee(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 210.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
          width: double.infinity,
           child: Column(
             children: [
               Text("Delete Employee",style: TextStyle(fontSize: 35.sp,fontFamily: AppTheme.fontName,fontWeight: FontWeight.w600),
                       ),
                SizedBox(height: 10.h),
             Text("Are you sure you want to delete this Employee?",style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 24.sp),
            ),
            SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel",style: TextStyle(fontFamily: AppTheme.fontName,fontWeight: FontWeight.w500,fontSize: 24.sp),),
                  ),
                  TextButton(
                    onPressed: () {
                      UserService().deleteUser(id);
                      setState(() {
                        employees.removeWhere((user) => user.id == id);
                      });
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: SuccessSnackBar(message: "Employee deleted successfully !"),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                      );
                    },
                    child: Text("Delete",style: TextStyle(color: Colors.red,fontFamily: AppTheme.fontName,fontWeight: FontWeight.w500,fontSize: 24.sp),),
                  ),
                ],
              ),
            ],
           ),
         ),
        ).animate(delay: 100.ms).fade().scale();
      },
    );
  }

  void onSearchTextChanged(String text) {
    print('Search text changed: $text');
    setState(() {
      employees = allUsers.isNotEmpty
          ? allUsers.where((user) {
        final fullNameMatch = user.fullName.toLowerCase().contains(text.toLowerCase());
        final rolesMatch = user.roles.join(', ').toLowerCase().contains(text.toLowerCase());
        final genderMatch = user.gender.toLowerCase().contains(text.toLowerCase());
        final phoneMatch = user.phone.toLowerCase().contains(text.toLowerCase());
        final emailMatch = user.email.toLowerCase().contains(text.toLowerCase());

        return (fullNameMatch ||
            rolesMatch ||
            genderMatch ||
            phoneMatch ||
            emailMatch) &&
            user.isEnabled &&
            !user.roles.contains('Client');
      }).toList()
          : [];
    });
  }

}
