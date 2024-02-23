import 'package:flutter/material.dart';
import 'package:pma/admin/widgets/admin_drawer.dart';
import 'package:pma/admin/widgets/client_container.dart';
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

  String _selectedSortOption = ' ';


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
    print('clients:: $clients');
    return Scaffold(

      drawer: AdminDrawer(selectedRoute: '/allclients'),
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
          title: Text('All Clients',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 30),),
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
                    child: Text("Total Clients : ${clients.length}",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)
                    ),
                
                Spacer(),   


                PopupMenuButton<String>(
            onSelected: (value) {
              _handleExportOption(value);
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'Export as Text',
                child: Row(
                  children: [
                    Image.asset('assets/images/txt.png', width: 40, height: 40),
                    SizedBox(width: 8),
                    Text('Export as Text',
                    style:TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Export as CSV',
                child: Row(
                  children: [
                    Image.asset('assets/images/csv.png', width: 40, height: 40),
                    SizedBox(width: 8),
                    Text('Export as CSV',
                    style:TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Export as Excel',
                child: Row(
                  children: [
                    Image.asset('assets/images/xlsx.png', width: 40, height: 40),
                    SizedBox(width: 8),
                    Text('Export as Excel',
                    style:TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Export as JSON',
                child: Row(
                  children: [
                    Image.asset('assets/images/json.png', width: 40, height: 40),
                    SizedBox(width: 8),
                    Text('Export as JSON',
                    style:TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              // Add more export options as needed
            ],
            icon: Icon(
              Icons.file_download,
              size: 35,
            ),
          ),
            
                
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
                            style:TextStyle(fontSize: 20),
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
                              style:TextStyle(fontSize: 20),
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
                    size: 35,
                  ),
                )

              ],
            ),
          ),  

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child:
                  ListView.builder(
                  itemCount: clients.length,
                  itemBuilder: (context, index) {
                    print(clients[index].image);
                    return Column(
                      children: [
                        ClientContainer(user: clients[index],onDelete: deleteClient
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


Future<void> _handleExportOption(String selectedOption) async {
  switch (selectedOption) {
    case 'Export as Text':
      print("Export as Text option selected");
        await exportEmployees.generateEmployeesTextFile(clients);
      break;
    case 'Export as CSV':
      print("Export as CSV option selected");
        exportEmployees.generateEmployeesCsvFile(clients);
      break;
    case 'Export as Excel':
      print("Export as Excel option selected");
         await exportEmployees.generateEmployeesXlsxFile(clients);
      break;
    case 'Export as JSON':
      print("Export as JSON option selected");
          exportEmployees.generateEmployeesJsonFile(clients);
      break;
  }
}


void _sort<T>(Comparable<T> Function(User user) getField, {required bool ascending}) {
  clients.sort((a, b) {
    final aValue = getField(a);
    final bValue = getField(b);
    return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
  });
}

void _handleSortOption(String selectedOption) {
  setState(() {
    _selectedSortOption = selectedOption;
    if (_selectedSortOption == 'Name Ascending') {
      _sort((user) => user.fullName, ascending: true);
    } else if (_selectedSortOption == 'Name Descending') {
      _sort((user) => user.fullName, ascending: false);
    }
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
          title: Text("Confirm Deletion",style: TextStyle(fontWeight: FontWeight.w600),),
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
              child: Text("Delete",style: TextStyle(color: Colors.red),),
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
  final BuildContext context;


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