// import 'package:date_picker_timeline/date_picker_widget.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pma/calendar/utils/day_card.dart';
// import 'package:pma/calendar/utils/mainColors.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

// class CalenderPage extends StatefulWidget {
//   const CalenderPage({Key? key}) : super(key: key);

//   @override
//   State<CalenderPage> createState() => _CalenderPageState();
// }

// class _CalenderPageState extends State<CalenderPage> {
//   List<String> months = [
//     "JAN",
//     "FEB",
//     "MAR",
//     "APR",
//     "MAY",
//     "JUN",
//     "JUL",
//     "AUG",
//     "SEP",
//     "OCT",
//     "NOV",
//     "DEC"
//   ];
//   List<Color> cardColors = [
//     maincolors.color1,
//     maincolors.color2,
//     maincolors.color3,
//     maincolors.color4
//   ];
//   List<Color> dividerColors = [
//     maincolors.color1Dark,
//     maincolors.color2Dark,
//     maincolors.color3Dark,
//     maincolors.color4Dark
//   ];
//   DateTime _selectedDateTime = DateTime.now();

//   void setSelectedDate(DateTime date) {
//     setState(() {
//       _selectedDateTime = date;
//     });
//   }


  

//   @override
//   Widget build(BuildContext context) {
//     print("Scaffold Built calender's page");
//     return Scaffold(
//       body: SlidingUpPanel(
//         maxHeight: 750,
//         defaultPanelState: PanelState.OPEN,
//         isDraggable: false,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
//         panel: Padding(
//           padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () => Navigator.pop(context),
//                           child: Container(
//                             height: 50,
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 border: Border.all(),
//                                 borderRadius: BorderRadius.circular(24)),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 20),
//                               child: Center(
//                                 child: Text(
//                                   "Today",
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.black,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 10,),
//                         Container(
//                           height: 50,
//                           decoration: BoxDecoration(
//                             color: Colors.black,
//                             borderRadius: BorderRadius.circular(24),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 20),
//                             child: Center(
//                               child: Text(
//                                 "Calender",
//                                 style: GoogleFonts.poppins(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       height: 50,
//                       width: 50,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(50),
//                         color: const Color.fromARGB(255, 153, 154, 157),
//                       ),
//                       child: const Center(child: Icon(CupertinoIcons.add)),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20,),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 height: 100,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(22)
//                 ),
//                 child: DatePicker(
//                   DateTime.now(),
//                   initialSelectedDate: DateTime.now(),
//                   width: 60,
//                   selectionColor: const Color.fromARGB(255, 147, 139, 174),
//                   dateTextStyle: GoogleFonts.poppins(
//                       color: Colors.grey,
//                       fontSize: 26
//                   ),
//                   onDateChange: setSelectedDate,
//                 ),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: 4,
//                   itemBuilder: (context, index) {
//                     return DayCard(
//                       selectedDate: _selectedDateTime.add(Duration(days: index)),
//                       cardColor: cardColors[index],
//                       dividerColor: dividerColors[index],
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: SafeArea(
//           child: Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             color: const Color.fromARGB(255, 153, 154, 157),
//           ),
//         ),
//       ),
//     );
//   }
// }
