import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pma/admin/screens/reclamations/add_reclamation.dart';
import 'package:pma/admin/screens/reclamations/reclamation_container.dart';
import 'package:pma/admin/widgets/admin_drawer.dart';
import 'package:pma/admin/widgets/search_bar.dart';
import 'package:pma/custom_appbar.dart';
import 'package:pma/models/reclamation_model.dart';
import 'package:pma/services/reclamation_service.dart';
import 'package:pma/theme.dart';

class AllReclamations extends StatefulWidget {
  const AllReclamations({super.key});

  @override
  State<AllReclamations> createState() => _AllReclamationsState();
}

class _AllReclamationsState extends State<AllReclamations> {
  late List<Reclamation> allReclamations;
  List<Reclamation> displayedReclamations = [];
  late Reclamation reclamation;
    String _selectedSortOption=" ";


  @override
  void initState() {
    super.initState();
    allReclamations = [];
    ReclamationService().getAllReclamations().then((reclamations) {
      setState(() {
        allReclamations = reclamations;
        displayedReclamations = allReclamations;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(selectedRoute: '/reclamations'),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(context: context, builder: (context) => AddReclamation());
            // Navigator.of(context).pushReplacementNamed('/addreclamation');
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
          CustomAppBar(title: "Claims"),
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
                Text("Total Reclmations : ${displayedReclamations.length}",
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
                      PopupMenuItem(
                      value: 'Creation date Ascending',
                      child: ListTile(
                        title: Row(
                          children: [
                            Radio(
                              value: 'Creation date Ascending',
                              groupValue: _selectedSortOption,
                              onChanged: (_) {},
                            ),
                            Text('Creation date ',
                            style:TextStyle(fontSize: 17.sp),
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_upward_outlined),
                        dense: true,
                      ),
                    ),
                    PopupMenuItem(
                      value: 'Creation date Descending',
                      child: ListTile(
                        title: Row(
                          children: [
                            Radio(
                              value: 'Creation date Descending',
                              groupValue: _selectedSortOption,
                              onChanged: (_) {},
                            ),
                            Text('Creation date ',
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
          //SizedBox(height: 15.h),
          Expanded(
            child: displayedReclamations.isEmpty
                ? Center(child: SpinKitCubeGrid(color: Colors.blue))
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                    child: ListView.builder(
                      itemCount: displayedReclamations.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            //Text("${displayedReclamations[index].title}"),
                            ReclamationContainer(reclamation: displayedReclamations[index]),
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
      displayedReclamations = allReclamations
          .where((reclamation) => reclamation.title.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  void _handleSortOption(String selectedOption) {
  setState(() {
    _selectedSortOption = selectedOption;
    switch (_selectedSortOption) {
      case 'Status Ascending':
        _sort((reclamation) => reclamation.status, ascending: true);
        break;
      case 'Status Descending':
        _sort((reclamation) => reclamation.status, ascending: false);
        break;
      case 'Creation date Ascending':
        _sort((reclamation) => reclamation.addedDate, ascending: true);
        break;
      case 'Creation date Descending':
        _sort((reclamation) => reclamation.addedDate, ascending: false);
        break;
    }
  });
}

void _sort<T>(Comparable<T> Function(Reclamation reclamation) getField, {required bool ascending}) {
  displayedReclamations.sort((a, b) {
    final aValue = getField(a);
    final bValue = getField(b);
    return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
  });
}
}
