import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pma/admin/screens/procesv/add_procesv.dart';
import 'package:pma/admin/screens/procesv/procesv_container.dart';
import 'package:pma/admin/widgets/admin_drawer.dart';
import 'package:pma/admin/widgets/search_bar.dart';
import 'package:pma/custom_appbar.dart';
import 'package:pma/models/procesv_model.dart';
import 'package:pma/services/procesv_service..dart';
import 'package:pma/theme.dart';

class AllProcesv extends StatefulWidget {
  const AllProcesv({super.key});

  @override
  State<AllProcesv> createState() => _AllProcesvState();
}

class _AllProcesvState extends State<AllProcesv> {
  late List<Procesv> allProcesv;
  List<Procesv> displayedProcesv = [];
  late Procesv procesv;
    String _selectedSortOption=" ";


  @override
  void initState() {
    super.initState();
    allProcesv = [];
    ProcesVService().getAllProcesV().then((procesVs) {
      setState(() {
        allProcesv = procesVs;
        displayedProcesv = allProcesv;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(selectedRoute: '/procesv'),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(context: context, builder: (context) => AddProcesv());
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
          CustomAppBar(title: "Proces Verbal"),
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
                Text("Total ProcesV : ${displayedProcesv.length}",
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
                      value: 'Date Ascending',
                      child: ListTile(
                        title: Row(
                          children: [
                            Radio(
                              value: 'Date Ascending',
                              groupValue: _selectedSortOption,
                              onChanged: (_) {},
                            ),
                            Text('Date ',
                            style:TextStyle(fontSize: 17.sp),
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_upward_outlined),
                        dense: true,
                      ),
                    ),
                    PopupMenuItem(
                      value: 'Date Descending',
                      child: ListTile(
                        title: Row(
                          children: [
                            Radio(
                              value: 'Date Descending',
                              groupValue: _selectedSortOption,
                              onChanged: (_) {},
                            ),
                            Text('Date ',
                              style:TextStyle(fontSize: 17.sp),
                              ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_downward_rounded),
                        dense: true,
                      ),  
                    ),
                      PopupMenuItem(
                      value: 'Sender Ascending',
                      child: ListTile(
                        title: Row(
                          children: [
                            Radio(
                              value: 'Sender Ascending',
                              groupValue: _selectedSortOption,
                              onChanged: (_) {},
                            ),
                            Text('Sender ',
                            style:TextStyle(fontSize: 17.sp),
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_upward_outlined),
                        dense: true,
                      ),
                    ),
                    PopupMenuItem(
                      value: 'Sender Descending',
                      child: ListTile(
                        title: Row(
                          children: [
                            Radio(
                              value: 'Sender Descending',
                              groupValue: _selectedSortOption,
                              onChanged: (_) {},
                            ),
                            Text('Sender ',
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
            child: displayedProcesv.isEmpty
                ? Center(child: SpinKitCubeGrid(color: Colors.blue))
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                    child: ListView.builder(
                      itemCount: displayedProcesv.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ProcesvContainer(procesv: displayedProcesv[index]),
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
      displayedProcesv = allProcesv
          .where((procesv) => procesv.title.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  void _handleSortOption(String selectedOption) {
  setState(() {
    _selectedSortOption = selectedOption;
    switch (_selectedSortOption) {
      case 'Date Ascending':
        _sort((procesv) => procesv.date, ascending: true);
        break;
      case 'Date Descending':
        _sort((procesv) => procesv.date, ascending: false);
        break;
      case 'Sender Ascending':
        _sort((procesv) => procesv.sender['fullName'], ascending: true);
        break;
      case 'Sender Descending':
        _sort((procesv) =>procesv.sender['fullName'], ascending: false);
        break;
    }
  });
}

void _sort<T>(Comparable<T> Function(Procesv procesv) getField, {required bool ascending}) {
  displayedProcesv.sort((a, b) {
    final aValue = getField(a);
    final bValue = getField(b);
    return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
  });
}
}
