import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:pma/admin/widgets/admin_drawer.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime today = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;

  List<ValueItem<Object?>> selectedCategories = [];
  List<ValueItem<Object?>> categories = [
    ValueItem(label:"Work", value:"Work"),
    ValueItem(label:"Personal", value:"Personal"),
    ValueItem(label:"Important", value:"Important"),
    ValueItem(label:"Travel", value:"Travel"),
    ValueItem(label:"Friends", value:"Friends"),
  ];

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        centerTitle: true,
      ),
      drawer: AdminDrawer(selectedRoute: '/calendar'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: MultiSelectDropDown(
                    onOptionSelected: (options) {
                      setState(() {
                        selectedCategories = options;
                      });
                    },
                    options: categories,
                    selectionType: SelectionType.multi,
                    chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                    optionTextStyle: const TextStyle(fontSize: 16),
                    selectedOptionIcon: const Icon(Icons.check_circle),
                  ),
                ),

                SizedBox(width: 15),

                ElevatedButton(
                    onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                    child: Text("Add Event",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ),
              ],
            ),

            SizedBox(height: 10),

            Container(
              child: TableCalendar(
                focusedDay: today,
                firstDay: DateTime.utc(2010, 01, 01),
                lastDay: DateTime.utc(2030, 01, 01),
                selectedDayPredicate: (day) => isSameDay(day, today),
                onDaySelected: _onDaySelected,
                calendarFormat: calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    calendarFormat = format;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
