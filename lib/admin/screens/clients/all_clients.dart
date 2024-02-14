import 'package:flutter/material.dart';
import 'package:pma/admin/widgets/admin_drawer.dart';
import 'package:pma/services/user_service.dart';

import '../../../models/user_model.dart';
import '../../../services/export_utils.dart';
import '../../../services/shared_preferences.dart';
import 'package:pma/admin/widgets/search_bar.dart';

import 'edit_client_popup.dart';

class AllClients extends StatefulWidget {
  const AllClients({Key? key}) : super(key: key);

  @override
  State<AllClients> createState() => _AllClientsState();
}

class _AllClientsState extends State<AllClients> {
  late Future<List<User>> futureUsers;
  late String userFullName;
  late String userId;
  List<User> allClients = [];
  List<User> clients = [];

  int _rowsPerPage = 2;
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

    futureUsers = UserService().getAllClients();

    await futureUsers.then((users) {
      setState(() {
        allClients = users;

        clients = allClients;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('employees: $clients');
    return Scaffold(
      appBar: AppBar(
        title: Text('All Clients'),
        centerTitle: true,
      ),
      drawer: AdminDrawer(selectedRoute: '/allclients'),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: PaginatedDataTable(
                header:
                   Row(
                    children: [
                      Expanded(
                        child: UserSearchBar(
                          onChanged: onSearchTextChanged,
                          onTap: (){_initializeData();print("refresh tapped");},
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Image.asset('assets/images/txt.png', width: 24, height: 24),
                            onPressed: () async {
                              print("Employees before export: $clients");
                              await exportEmployees.generateEmployeesTextFile(clients);
                            },
                          ),
                          IconButton(
                            icon: Image.asset('assets/images/csv.png', width: 24, height: 24),
                            onPressed: () {
                              exportEmployees.generateEmployeesCsvFile(clients);
                            },
                          ),
                          IconButton(
                            icon: Image.asset('assets/images/xlsx.png', width: 24, height: 24),
                            onPressed: () async {
                              await exportEmployees.generateEmployeesXlsxFile(clients);
                            },
                          ),
                          IconButton(
                            icon: Image.asset('assets/images/json.png', width: 24, height: 24),
                            onPressed: () {
                              // Export as JSON
                              exportEmployees.generateEmployeesJsonFile(clients);
                            },
                          ),
                        ],
                      )
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
                source: EmployeeDataSource(clients,context,deleteClient),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sort<T>(Comparable<T> Function(User user) getField, int columnIndex, bool ascending) {
    clients.sort((a, b) {
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
    print('Search text changed: $text');
    setState(() {
      clients = allClients.isNotEmpty
          ? allClients.where((user) {
        final fullNameMatch = user.fullName.toLowerCase().contains(text.toLowerCase());
        final rolesMatch = user.roles.join(', ').toLowerCase().contains(text.toLowerCase());
        final genderMatch = user.gender.toLowerCase().contains(text.toLowerCase());
        final phoneMatch = user.phone.toLowerCase().contains(text.toLowerCase());
        final emailMatch = user.email.toLowerCase().contains(text.toLowerCase());

        return fullNameMatch || rolesMatch || genderMatch || phoneMatch || emailMatch;
      }).toList()
          : [];
    });
  }

  void deleteClient(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this client?"),
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
                  clients.removeWhere((user) => user.id == id);
                });
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }


}

class EmployeeDataSource extends DataTableSource {

  final Function(String) onDelete;
  final List<User> _clients;
  int _selectedRowCount = 0;
  final BuildContext context; // Add this line


  EmployeeDataSource(this._clients, this.context,this.onDelete);

  @override
  DataRow getRow(int index) {
    final employee = _clients[index];
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return EditClientPopup(client: employee);
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete_outline_rounded),
              onPressed: () {
                onDelete(employee.id);
              },
            ),
          ],
        ),
      ),
    ]);
  }


  @override
  int get rowCount => _clients.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedRowCount;
}