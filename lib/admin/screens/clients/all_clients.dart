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

  void _sort<T>(Comparable<T> Function(User user) getField, int columnIndex, bool ascending) {
    clients.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
    });

    // setState(() {
    //   _sortColumnIndex = columnIndex;
    //   _sortAscending = ascending;
    // });
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