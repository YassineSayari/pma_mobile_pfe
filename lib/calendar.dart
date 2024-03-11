import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:pma/add_event.dart';
import 'package:pma/admin/widgets/admin_drawer.dart';
import 'package:pma/custom_appbar.dart';
import 'package:pma/theme.dart';
import 'package:table_calendar/table_calendar.dart';

import 'client/widgets/client_drawer.dart';
import 'engineer/widgets/engineer_drawer.dart';
import 'models/event_model.dart';
import 'services/event_service.dart';
import 'services/shared_preferences.dart';
import 'team_leader/widgets/teamleader_drawer.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  String? userId;


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

  DateTime day = startDate;
  print("day : $day ===== start date: $startDate");
  while (day.isBefore(endDate) || isSameDay(day, endDate)) {
    eventsByDay[day] = eventsByDay[day] ?? [];
    eventsByDay[day]!.add(event);
    print("event added");
    print("Events that day: ${eventsByDay[day]!.length}");
    day = day.add(Duration(days: 1));
  }

  startDate = null;
  endDate = null;
}

    setState(() {});
    } else {
      print('User ID is null.');
    }
  } catch (e) {
    print('Error fetching events for user: $e');
  }
}


Future<void> createEvent() async {
    String? userId = await SharedPrefs().getLoggedUserIdFromPrefs();
       showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        print("id:::::::$userId");
        return AddEventContainer(userId: userId!);
      });
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
          padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
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
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppTheme.fontName
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 125.w,
                      padding:EdgeInsets.symmetric(horizontal: 4.w,vertical: 4.h),
                      child: ListView.builder(
                        itemCount: 17, // number of hours
                        itemBuilder: (context, index) {
                          int hour = index + 7;
                          String formattedHour =
                              DateFormat('HH:mm a').format(DateTime(2022, 1, 1, hour));
                          return ListTile(
                            title: Text('$formattedHour ',style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 15.sp,fontWeight: FontWeight.w500),),
                          );
                        },
                      ),
                    ),
                    VerticalDivider(
                      color: Color.fromARGB(255, 67, 20, 125),
                      thickness: 1,
                      width: 40.w,
                      indent: 30,
                      endIndent: 40,
                    ),
                    Flexible(
                      child: Container(
                        height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.amber,
                          ),
                          child: Text(" "),
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
      borderRadius: BorderRadius.circular(3.r),
      shape: BoxShape.rectangle,
      color: _markerColor(date, events),
    ),
    width:  20.0.w,
    height:  20.0.h,
    child: Center(
      child: Text(
        '${events.length}',
        style: TextStyle().copyWith(
          color: Colors.white,
          fontSize:  15.0.sp,
          fontFamily: AppTheme.fontName
        ),
      ),
    ),
  );
}
Color _markerColor(DateTime date, List events) {
  if (events.length >  5) {
    return Colors.red;
  } else if (events.length >  2) {
    return Color.fromARGB(255, 136, 30, 198);
  } else {
    return Colors.green;
  }
}


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: Column(
        children: [
          CustomAppBar(title: 'Calendar'),
          SizedBox(height: 15.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
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
                        optionTextStyle:  TextStyle(fontSize: 20.sp,fontFamily: AppTheme.fontName),
                        selectedOptionIcon: const Icon(Icons.check_circle),
                      ),
                    ),
                    SizedBox(width: 15.h),
                    ElevatedButton(
                      onPressed: () {

                        createEvent();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0.r),
                        ),
                      ),
                      child: Text(
                        "Add Event",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppTheme.fontName,
                          fontSize: 20.sp
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Container(
                  child: TableCalendar(
                    rowHeight: 65.h,
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppTheme.fontName
                      ),
                    ),
          
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                      if (events.isNotEmpty &&eventsByDay.containsKey(date)) {
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
                        fontWeight: FontWeight.w500,
                        fontSize: 11.sp,
                        fontFamily: AppTheme.fontName
                      ),
                      weekendStyle: TextStyle(
                        color: Color.fromARGB(255, 20, 27, 47),
                        fontWeight: FontWeight.w500,
                        fontSize: 11.sp,
                        fontFamily: AppTheme.fontName
                      ),
                    ),
          eventLoader: (day) {
            print("Loading events for day: $day");
            List<Event> events = [];
          
            for (Event event in userEvents) {
          if ((event.startDate.isBefore(day) || isSameDay(event.startDate, day)) &&
              (event.endDate.isAfter(day) || isSameDay(event.endDate, day))) {
                events.add(event);
            }
          }
          
            print("Events for $day: ${events.length}");
            return events;
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
        ],
      ),
    );
  }
  
}

Widget _buildDrawer() {

  return FutureBuilder<String?>(
    future: SharedPrefs().getLoggedUserRoleFromPrefs(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      } else {
        String userRole = snapshot.data ?? '';

        if (userRole == 'Admin') {
          return AdminDrawer(selectedRoute: "/calendar");
        } else if (userRole == 'Engineer') {
          return EngineerDrawer(selectedRoute: "/calendar");
        } else if (userRole == 'Team Leader') {
          return TeamLeaderDrawer(selectedRoute: "/calendar");
        } else {
          return ClientDrawer(selectedRoute: "/calendar");
        }
      }
    },
  );
}


