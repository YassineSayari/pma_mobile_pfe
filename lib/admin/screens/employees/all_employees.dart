import 'package:flutter/material.dart';
//import 'package:http/http.dart';
import 'package:pma/admin/widgets/admin_drawer.dart';
import 'package:pma/services/user_service.dart';

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

  // int _rowsPerPage = 2;
  // int _sortColumnIndex = 0;
  // bool _sortAscending = true;

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
      Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              //spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: AppBar(
          title: Text('All Employees',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 30),),
          centerTitle: true,
        ),
      ),
          SizedBox(height: 30),
          UserSearchBar(
            onChanged: onSearchTextChanged,
            onTap: (){
                _initializeData();
                print("refresh tapped");
                },
          ), 

          SizedBox(height: 30),

          Padding(
                  padding: const EdgeInsets.only(top:8.0,left: 20.0,right: 25.0,bottom: 20.0),
            child: Row(
              children: [
                   Align(
                    alignment: Alignment.topLeft,
                    child: Text("Total Employees : ${employees.length}",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)
                    ),
                
                Spacer(),
                Icon(Icons.tune_outlined,
                        size: 35,
                        //color: Color.fromARGB(255, 20, 14, 188),
                        ),
               SizedBox(width: 15),            
                Icon(Icons.swap_vert,
                        size: 35,
                        //color: Color.fromARGB(255, 20, 14, 188),
                        ),
              ],
            ),
          ),  

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child:
                  ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    print(employees[index].image);
                    return Column(
                      children: [
                        UserContainer(user: employees[index],onDelete: deleteEmployee
                    ),
                        SizedBox(height:5),
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



  /*void _sort<T>(Comparable<T> Function(User user) getField, int columnIndex, bool ascending) {
    employees.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
    });

    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }*/

  void deleteEmployee(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this Employee?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
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
                    content: Text('Employee deleted successfully.'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.yellow,
                  ),
                );
              },
              child: Text("Delete",style: TextStyle(color: Colors.red),),
            ),
          ],
        );
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

       /*PaginatedDataTable(
                    header:  Row(
                        children: [
                          Expanded(
                            child: UserSearchBar(
                              onChanged: onSearchTextChanged,
                              onTap: (){_initializeData();
                              print("refresh tapped");},
                            ),
                          ),
              
                         /* Row(
                            children: [
                              IconButton(
                                icon: Image.asset('assets/images/txt.png', width: 24, height: 24),
                                onPressed: () async {
                                  print("text option clicked");
                                  print("Employees before export: $employees");
                                  await exportEmployees.generateEmployeesTextFile(employees);
                                },
                              ),
                              IconButton(
                                icon: Image.asset('assets/images/csv.png', width: 24, height: 24),
                                onPressed: () {
                                  exportEmployees.generateEmployeesCsvFile(employees);
                                },
                              ),
                              IconButton(
                                icon: Image.asset('assets/images/xlsx.png', width: 24, height: 24),
                                onPressed: () async {
                                  await exportEmployees.generateEmployeesXlsxFile(employees);
                                },
                              ),
                              IconButton(
                                icon: Image.asset('assets/images/json.png', width: 24, height: 24),
                                onPressed: () {
                                  exportEmployees.generateEmployeesJsonFile(employees);
                                },
                              ),
                            ],
                          )*/
                        ],
                      ),
              
                    rowsPerPage: _rowsPerPage,
                    availableRowsPerPage: [1, 2, 3, 4, 5, 6, 10, 25, 100],
                    onRowsPerPageChanged: (int? value) {
                      setState(() {
                        _rowsPerPage = value!;
                      });
                    },
              
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
              
                    columns: [
                      DataColumn(
                        label: Text('Name'),
                        onSort: (columnIndex, ascending) {
                          _sort<String>((user) => user.fullName, columnIndex, ascending);
                        },
                      ),
                      DataColumn(
                        label: Text('Roles'),
                        onSort: (columnIndex, ascending) {
                          _sort<String>((user) => user.roles.join(', '), columnIndex, ascending);
                        },
                      ),
                      DataColumn(
                        label: Text('Gender'),
                        onSort: (columnIndex, ascending) {
                          _sort<String>((user) => user.gender, columnIndex, ascending);
                        },
                      ),
                      DataColumn(
                        label: Text('Mobile'),
                        onSort: (columnIndex, ascending) {
                          _sort<String>((user) => user.phone, columnIndex, ascending);
                        },
                      ),
                      DataColumn(label: Text('Email'),
                        onSort: (columnIndex, ascending) {
                          _sort<String>((user) => user.email, columnIndex, ascending);
                        },
                      ),
                      DataColumn(label: Text('Actions')),
                    ],
                    source: EmployeeDataSource(employees,context,deleteEmployee),
                  ),*/