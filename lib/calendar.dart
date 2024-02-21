import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:pma/admin/widgets/admin_drawer.dart';
import 'package:table_calendar/table_calendar.dart';

import 'models/event_model.dart';
import 'services/event_service.dart';
import 'services/shared_preferences.dart';

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
    ValueItem(label: "Work", value: "Work"),
    ValueItem(label: "Personal", value: "Personal"),
    ValueItem(label: "Important", value: "Important"),
    ValueItem(label: "Travel", value: "Travel"),
    ValueItem(label: "Friends", value: "Friends"),
  ];

  final EventService eventService = GetIt.instance<EventService>();
  List<Event> userEvents = [];
Map<DateTime, List<Event>> eventsByDay = {};

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

Future<void> _initializeData() async {
  String? userId = await SharedPrefs().getLoggedUserIdFromPrefs();

  try {
    if (userId != null) {
      userEvents = await eventService.getEventsByUser(userId);

      // Clear eventsByDay map
      eventsByDay.clear();

for (Event event in userEvents) {
  DateTime? startDate = event.startDate;
  DateTime? endDate = event.endDate;
  print("Start date: $startDate");
  print("End date : $endDate");

  DateTime day = startDate!;
  while (day.isBefore(endDate!) || isSameDay(day, endDate)) {
    eventsByDay[day] = eventsByDay[day] ?? [];
    eventsByDay[day]!.add(event);
    print("event added");
    print("Events that day: ${eventsByDay[day]!.length}");
    day = day.add(Duration(days: 1));
  }

  startDate = null;
  endDate = null;
}

      // Set state to trigger a rebuild with updated data
      setState(() {});
    } else {
      print('User ID is null.');
    }
  } catch (e) {
    print('Error fetching events for user: $e');
  }
}


  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    setState(() {
      today = selectedDay;
    });

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        String formattedDate = DateFormat('EEEE, MMM d y').format(selectedDay);
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 188, 199, 220),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  '$formattedDate',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: 17, // number of hours
                        itemBuilder: (context, index) {
                          int hour = index + 7;
                          String formattedHour =
                              DateFormat('HH:mm a').format(DateTime(2022, 1, 1, hour));
                          return ListTile(
                            title: Text('$formattedHour '),
                          );
                        },
                      ),
                    ),
                    VerticalDivider(
                      color: Colors.black,
                      thickness: 1,
                      width: 1,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


Widget _buildEventsMarker(DateTime date, List events) {
  return AnimatedContainer(
    duration: const Duration(milliseconds:  300),
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      color: _markerColor(date, events),
    ),
    width:  16.0,
    height:  16.0,
    child: Center(
      child: Text(
        '${events.length}',
        style: TextStyle().copyWith(
          color: Colors.white,
          fontSize:  12.0,
        ),
      ),
    ),
  );
}
Color _markerColor(DateTime date, List events) {
  if (events.length >  5) {
    return Colors.red;
  } else if (events.length >  3) {
    return Colors.orange;
  } else {
    return Colors.green;
  }
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    "Add Event",
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
                rowHeight: 70,
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                  return Positioned(
                    right:   1,
                    bottom:   1,
                    child: _buildEventsMarker(date, events),
                    );
                  }
                  else{return Container();}
  },
),

                availableGestures: AvailableGestures.all,
                startingDayOfWeek: StartingDayOfWeek.monday,
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: Color.fromARGB(255, 20, 27, 47),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  weekendStyle: TextStyle(
                    color: Color.fromARGB(255, 20, 27, 47),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                eventLoader: (day) {
                print("Loading events for day: $day");
                List<Event>? events = eventsByDay[day];
                print("Events for $day: ${events?.length ??  0}");
                return events ?? [];
                },


                focusedDay: today,
                firstDay: DateTime.utc(2010, 01, 01),
                lastDay: DateTime.utc(2030, 01, 01),
                selectedDayPredicate: (selectedDay) => isSameDay(selectedDay, today),
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