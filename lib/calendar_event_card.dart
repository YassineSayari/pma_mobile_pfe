import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pma/calendar_edit_popup.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/models/event_model.dart';
import 'package:pma/services/event_service.dart';
import 'package:pma/theme.dart';

class EventCard extends StatefulWidget {
  final Event event;

  EventCard({Key? key, required this.event}) : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
          bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Container(
        //height: 220,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.grey, // Change to your desired color
          borderRadius: BorderRadius.circular(28),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.event.title, // Display event title
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: AppTheme.fontName,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                icon: Icon(
                  isExpanded ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down,
                  size: 35,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
                ],
              ),
               SizedBox(height: 20.h),
               Row(
                 children: [
                   Text(
                    'Details: ', 
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: AppTheme.fontName,
                      fontSize: 28,
                    ),
                                 ),
                   Flexible(
                     child: Text(
                      '${widget.event.details}',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: AppTheme.fontName,
                        fontSize: 28,
                      ),
                                   ),
                   ),
                 ],
               ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('h:mm a').format(widget.event.startDate), // Display event start time
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        "Start",
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 40,
                    width: 75,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Center(
                      child: Text(
                        "     ", // Display event duration
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('h:mm a').format(widget.event.endDate), // Display event end time
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        "End",
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                     
                    ],
                  ),
                ],
              ),
               SizedBox(height: 10.h),
                      if(isExpanded)
                          Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(context: context, builder: (context)=> EditEventPopup(event: widget.event));                     
                                  },
                              child: Icon(
                                Icons.edit_outlined,
                                size: 25.sp,
                                color: Colors.white,
                              ),
                            ),
                          SizedBox(width: 20.w),
                          GestureDetector(
                              onTap: () {
                                print("deleting event : ${widget.event.id}");
                              deleteEvent(widget.event.id);
                              },
                              child: Icon(
                                Icons.delete_outline,
                                size: 25.sp,
                                color: Color.fromARGB(255, 188, 14, 14),
                              ),
                            ),
                          ],
                        ),
            ],
          ),
        ),
      ),
    );
  }


    void deleteEvent(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
                shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 225.h),
      child:Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
          width: double.infinity,
             child: Column(
               children: [
                 Text("Confirm Deletion",style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 35.sp,fontWeight: FontWeight.w600)),
                           Text("Are you sure you want to delete this Event?",style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 24.sp)),
                           
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel",style: TextStyle(fontFamily: AppTheme.fontName,fontWeight: FontWeight.w500,fontSize: 24.sp)),
                      ),
                      TextButton(
                        onPressed: () {
                          EventService().deleteEvent(id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: SuccessSnackBar(message: "Event deleted !"),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                          );
                          Navigator.of(context).pushReplacementNamed("/calendar");
                        },
                        child: Text("Delete",style: TextStyle(color: Colors.red,fontFamily: AppTheme.fontName,fontWeight: FontWeight.w500,fontSize: 24.sp),),
                      ),
                    ],
                  ),
               ],
             ),
           ),
        
        ).animate(delay: 100.ms)
        .fade().scale();
      },
    );
  }
}
