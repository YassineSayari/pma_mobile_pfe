import 'package:flutter/material.dart';
import 'package:pma/admin/widgets/admin_drawer.dart';
import 'package:pma/services/user_service.dart';

import '../../models/user_model.dart';
import '../../services/export_utils.dart';
import '../../services/shared_preferences.dart';
import 'package:pma/admin/widgets/search_bar.dart';

class AllEmployees extends StatefulWidget {
  const AllEmployees({Key? key}) : super(key: key);

  @override
  State<AllEmployees> createState() => _AllEmployeesState();
}

class _AllEmployeesState extends State<AllEmployees> {
  late Future<List<User>> futureUsers;
  late String userFullName;
  late String userId;
  List<User> allUsers = [];
  List<User> employees = [];

  int _rowsPerPage = 5;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  final ExportEmployees exportEmployees = ExportEmployees();



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

    futureUsers = UserService().getAllUsers();

    await futureUsers.then((users) {
      setState(() {
        allUsers = users;
        employees = allUsers.where((user) => !user.roles.contains('Client')).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('employees: $employees');
    return Scaffold(
      appBar: AppBar(
        title: Text('All Employees, user: $userFullName'),
      ),
      drawer: AdminDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PaginatedDataTable(
                header:          Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: UserSearchBar(
                          onChanged: onSearchTextChanged,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Image.asset('assets/images/txt.png', width: 24, height: 24),
                            onPressed: () async {
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
                              // Export as JSON
                              exportEmployees.generateEmployeesJsonFile(employees);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
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
                source: EmployeeDataSource(employees),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sort<T>(Comparable<T> Function(User user) getField, int columnIndex, bool ascending) {
    employees.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
    });

    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  void onSearchTextChanged(String text) {
    setState(() {
      employees = allUsers.isNotEmpty
          ? allUsers
          .where(
            (user) => user.fullName.toLowerCase().contains(text.toLowerCase()),
      )
          .toList()
          : [];
      //exclude clients
      employees = employees.where((user) => !user.roles.contains('Client')).toList();
    });
  }

}

class EmployeeDataSource extends DataTableSource {
  final List<User> _employees;
  int _selectedRowCount = 0;

  EmployeeDataSource(this._employees);

  @override
  DataRow getRow(int index) {
    final employee = _employees[index];
    return DataRow(cells: [
      DataCell(Text(employee.fullName)),
      DataCell(Text(employee.roles.join(', '))),
      DataCell(Text(employee.gender)),
      DataCell(Text(employee.phone)),
      DataCell(Text(employee.email)),
      DataCell(
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined),
              onPressed: () {

              },
            ),
            IconButton(
              icon: Icon(Icons.delete_outline_rounded),
              onPressed: () {

              },
            ),
          ],
        ),
      ),
    ]);
  }


  @override
  int get rowCount => _employees.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedRowCount;
}