// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pma/add_event.dart';
// import 'package:pma/calendar/calender_page.dart';
// import 'package:pma/calendar/utils/task_cards.dart';
// import 'package:pma/services/shared_preferences.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class TodayPage extends StatefulWidget {
//   const TodayPage({Key? key});

//   @override
//   State<TodayPage> createState() => _TodayPageState();
// }

// class _TodayPageState extends State<TodayPage> {
//   late Timer _timer;
//   String _currentTime = "";
//   String _currentMonth = "";

//   @override
//   void initState() {
//     super.initState();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         _currentTime = DateTime.now().toString().substring(11, 19);
//         _currentMonth = DateTime.now().toString().substring(5, 7);
//       });
//     });
//   }
//   Future<void> createEvent() async {
//     String? userId = await SharedPrefs().getLoggedUserIdFromPrefs();
//        showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         //print("id:::::::$userId");
//         return AddEventContainer(userId: userId!);
//       });
// }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("Scaffold Built today's page");
//     return Scaffold(
//       body: SlidingUpPanel(
//         maxHeight: 440,
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
//                     Text(
//                       "Today's Tasks",
//                       style: GoogleFonts.poppins(
//                           fontSize: 18, fontWeight: FontWeight.w600),
//                     ),
//                     Container(
//                       height: 45,
//                       width: 110,
//                       decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(22)),
//                       child: Center(
//                         child: Text(
//                           "Reminders",
//                           style: GoogleFonts.poppins(fontSize: 15),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       TaskCard(clr: const Color.fromARGB(255, 173, 155, 140)),
//                       TaskCard(clr: const Color.fromARGB(255, 169, 172, 139))
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: SafeArea(
//           child: Container(
//             height: ScreenUtil().screenHeight,
//             width: ScreenUtil().screenWidth,
//             color: Color.fromARGB(255, 186, 187, 190),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           GestureDetector(
//                             child: Container(
//                               height: 50,
//                               decoration: BoxDecoration(
//                                   color: Colors.black,
//                                   borderRadius: BorderRadius.circular(24)),
//                               child: Padding(
//                                 padding:
//                                 const EdgeInsets.symmetric(horizontal: 20),
//                                 child: Center(
//                                   child: Text(
//                                     "Today",
//                                     style: GoogleFonts.poppins(
//                                         color: Colors.white, fontSize: 16),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           GestureDetector(
//                             onTap: () => Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => const CalenderPage())),
//                             child: Container(
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(24),
//                                 border: Border.all(),
//                               ),
//                               child: Padding(
//                                 padding:
//                                 const EdgeInsets.symmetric(horizontal: 20),
//                                 child: Center(
//                                   child: Text(
//                                     "Calender",
//                                     style: GoogleFonts.poppins(
//                                         color: Colors.black, fontSize: 16),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                       Container(
//                         height: 50,
//                         width: 50,
//                         decoration: BoxDecoration(
//                           border: Border.all(),
//                           borderRadius: BorderRadius.circular(50),
//                           color: const Color.fromARGB(255, 153, 154, 157),
//                         ),
//                         child:  GestureDetector(
//                           onTap: (){
//                             createEvent();
//                           },
//                           child: Icon(CupertinoIcons.add),
//                         ),
//                       )
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   Text(
//                     "Tuesday",
//                     style: GoogleFonts.poppins(fontSize: 20),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                     height: 200,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Wrap(
//                                 direction: Axis.vertical,
//                                 spacing: -30,
//                                 children: [
//                                   Text(
//                                     _currentTime,
//                                     style: GoogleFonts.poppins(
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 70),
//                                   ),
//                                   Text(
//                                     _currentMonth,
//                                     style: GoogleFonts.poppins(
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 70),
//                                   ),
//                                 ]),
//                           ],
//                         ),
//                         const VerticalDivider(
//                           width: 20,
//                           thickness: 1,
//                           indent: 30,
//                           endIndent: 30,
//                           color: Colors.grey,
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Text(
//                               "1:20 PM ",
//                               style: TextStyle(
//                                 fontSize: 28,
//                               ),
//                             ),
//                             Text(
//                               "New York ",
//                               style: TextStyle(
//                                 fontSize: 16,
//                               ),
//                             ),
//                             Text(
//                               "6:20 PM ",
//                               style: TextStyle(
//                                 fontSize: 28,
//                               ),
//                             ),
//                             Text(
//                               "UK",
//                               style: TextStyle(
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
