import 'package:flutter/material.dart';
import 'package:pma/admin/widgets/admin_drawer.dart';
import 'package:pma/services/user_service.dart';

import '../../models/user_model.dart';
import '../../services/export_utils.dart';
import '../../services/shared_preferences.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late Future<List<User>> futureUsers;
  late String userFullName;
  late String userId;
  List<User> allUsers = [];
  List<User> employees = [];

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

    futureUsers = UserService().getAllUsers(); //

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
        title: Text('Welcome $userFullName'),
        actions: [
          IconButton(
            icon: Image.asset('assets/images/txt.png', width: 24, height: 24),
            onPressed: () async {
              print("Employees before export: $employees");
              // Export as Text
              await exportEmployees.generateEmployeesTextFile(employees);
            },
          ),
          IconButton(
            icon: Image.asset('assets/images/csv.png', width: 24, height: 24),
            onPressed: () {
              // Export as CSV
              exportEmployees.generateEmployeesCsvFile(employees);
            },
          ),
          IconButton(
            icon: Image.asset('assets/images/xlsx.png', width: 24, height: 24),
            onPressed: () async {
              // Export as XLSX
              await exportEmployees.generateEmployeesXlsxFile(employees);
              // Handle saving or sharing the XLSX file
              // You can use path_provider to save it to the device's documents directory.
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
      ),

      drawer: AdminDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 150,
                child: TextField(
                  onChanged: onSearchTextChanged,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: futureUsers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    allUsers = snapshot.data as List<User>;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Roles')),
                          DataColumn(label: Text('Gender')),
                          DataColumn(label: Text('Mobile')),
                          DataColumn(label: Text('Email')),
                        ],
                        rows: employees.isNotEmpty
                            ? employees
                            .map(
                              (user) => DataRow(
                            cells: [
                              DataCell(Text(user.fullName)),
                              DataCell(Text(user.roles.join(', '))),
                              DataCell(Text(user.gender)),
                              DataCell(Text(user.phone)),
                              DataCell(Text(user.email)),
                            ],
                          ),
                        )
                            .toList()
                            : allUsers
                            .where((user) => !user.roles.contains('Client'))
                            .map(
                              (user) => DataRow(
                            cells: [
                              DataCell(Text(user.fullName)),
                              DataCell(Text(user.roles.join(', '))),
                              DataCell(Text(user.gender)),
                              DataCell(Text(user.phone)),
                              DataCell(Text(user.email)),
                            ],
                          ),
                        )
                            .toList(),
                      ),
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

  void onSearchTextChanged(String text) {
    setState(() {
      employees = allUsers.isNotEmpty
          ? allUsers
          .where((user) =>
          user.fullName.toLowerCase().contains(text.toLowerCase()))
          .toList()
          : [];

      //exclude clients
      employees = employees.where((user) => !user.roles.contains('Client')).toList();

    });
  }
}
