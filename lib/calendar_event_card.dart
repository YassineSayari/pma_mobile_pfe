import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pma/models/event_model.dart';
import 'package:pma/theme.dart';

// ignore: must_be_immutable
class EventCard extends StatelessWidget {
  final Event event;

  EventCard({Key? key, required this.event}) : super(key: key);

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
              Text(
                event.title, // Display event title
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: AppTheme.fontName,
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
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
                      '${event.details}',
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
                        DateFormat('h:mm a').format(event.startDate), // Display event start time
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
                        DateFormat('h:mm a').format(event.endDate), // Display event end time
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
