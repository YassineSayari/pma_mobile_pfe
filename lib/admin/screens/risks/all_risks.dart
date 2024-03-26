import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pma/admin/screens/risks/risk__container.dart';
import 'package:pma/admin/widgets/admin_drawer.dart';
import 'package:pma/admin/widgets/search_bar.dart';
import 'package:pma/custom_appbar.dart';
import 'package:pma/models/risk_model.dart';
import 'package:pma/services/risk_service.dart';
import 'package:pma/theme.dart';

class AllRisks extends StatefulWidget {
  const AllRisks({super.key});

  @override
  State<AllRisks> createState() => _AllRisksState();
}

class _AllRisksState extends State<AllRisks> {
  late List<Risk> allRisks;
  List<Risk> displayedRisks = [];
  late Risk risk;
    String _selectedSortOption=" ";


  @override
  void initState() {
    super.initState();
    allRisks = [];
    RiskService().getAllProblemes().then((risks) {
      setState(() {
        allRisks = risks;
        displayedRisks = allRisks;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(selectedRoute: '/risks'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(title: "Risks"),
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
                Text("Total Risks : ${displayedRisks.length}",
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
                      value: 'Impact Ascending',
                      child: ListTile(
                        title: Row(
                          children: [
                            Radio(
                              value: 'Impact Ascending',
                              groupValue: _selectedSortOption,
                              onChanged: (_) {},
                            ),
                            Text('Impact ',
                            style:TextStyle(fontSize: 17.sp),
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_upward_outlined),
                        dense: true,
                      ),
                    ),
                    PopupMenuItem(
                      value: 'Impact Descending',
                      child: ListTile(
                        title: Row(
                          children: [
                            Radio(
                              value: 'Impact Descending',
                              groupValue: _selectedSortOption,
                              onChanged: (_) {},
                            ),
                            Text('Impact ',
                              style:TextStyle(fontSize: 17.sp),
                              ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_downward_rounded),
                        dense: true,
                      ),  
                    ),
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
            child: displayedRisks.isEmpty
                ? Center(child: SpinKitCubeGrid(color: Colors.blue))
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                    child: ListView.builder(
                      itemCount: displayedRisks.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            //Text("${displayedReclamations[index].title}"),
                            RiskContainer(risk: displayedRisks[index]),
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
      displayedRisks = allRisks
          .where((risk) => risk.title.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  void _handleSortOption(String selectedOption) {
  setState(() {
    _selectedSortOption = selectedOption;
    switch (_selectedSortOption) {
      case 'Impact Ascending':
        _sort((risk) => risk.impact, ascending: true);
        break;
      case 'Impact Descending':
        _sort((risk) => risk.impact, ascending: false);
        break;
      case 'Date Ascending':
        _sort((risk) => risk.date, ascending: true);
        break;
      case 'Date Descending':
        _sort((risk) =>risk.date, ascending: false);
        break;
    }
  });
}

void _sort<T>(Comparable<T> Function(Risk risk) getField, {required bool ascending}) {
  displayedRisks.sort((a, b) {
    final aValue = getField(a);
    final bValue = getField(b);
    return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
  });
}
}
