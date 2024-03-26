import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pma/engineer/screens/tasks/engineer_edit_task.dart';
import 'package:pma/models/task_model.dart';
import 'package:pma/theme.dart';

class MyTaskContainer extends StatefulWidget {
  final Task task;
  const MyTaskContainer({super.key, required this.task});

  @override
  State<MyTaskContainer> createState() => _MyTaskContainerState();
}

class _MyTaskContainerState extends State<MyTaskContainer> {
    bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    
        String formattedStartDate = DateFormat('MMMM dd, yyyy').format(DateTime.parse(widget.task.startDate));
        String formattedDeadline = DateFormat('MMMM dd, yyyy').format(DateTime.parse(widget.task.deadLine));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 8.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.nearlyWhite,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("${widget.task.title}",
                  style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 25.sp,
                            fontFamily: AppTheme.fontName,
                            
                          ),
                          ),
                  Spacer(),
                  Text("${widget.task.priority}",
                  style: TextStyle(
                            fontSize: 19.sp,
                            fontFamily: AppTheme.fontName,
                            color: getColorForPriority(widget.task.priority),
                          ),
                          ),
              IconButton(
                icon: Icon(
                  isExpanded ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down,
                  size: 35,
                  color: Color.fromARGB(255, 102, 31, 184),
                ),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
                ],
              ),
          if(isExpanded)
            Column(
              children: [ 
                SizedBox(height: 20),
                      Row(
                       children: [
                        Text("Project: ",
                         style: TextStyle(
                                      fontSize: 20.sp,
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500
                                    ),
                                    ),
                         Expanded(
                           child: Text("${widget.task.project['Projectname']}",
                              style: TextStyle(
                                        fontSize: 20.sp,
                                        fontFamily: AppTheme.fontName,
                                      ),
                                      ),
                         ),
                       ],
                     ),
                     SizedBox(height: 10.h),
                      Row(
                       children: [
                        Text("Status: ",
                         style: TextStyle(
                                      fontSize: 20.sp,
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500
                                    ),
                                    ),
                         Expanded(
                           child: Text("${widget.task.status}",
                              style: TextStyle(
                                        fontSize: 20.sp,
                                        fontFamily: AppTheme.fontName,
                                      ),
                                      ),
                         ),
                       ],
                     ),
                     SizedBox(height: 10.h),
                      Row(
                       children: [
                        Text("Description: ",
                         style: TextStyle(
                                      fontSize: 20.sp,
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500
                                    ),
                                    ),
                         Expanded(
                           child: Text("${widget.task.details}",
                              style: TextStyle(
                                        fontSize: 20.sp,
                                        fontFamily: AppTheme.fontName,
                                        overflow: TextOverflow.ellipsis
                                      ),
                                      ),
                         ),
                       ],
                     ),
                     SizedBox(height: 10.h),
                Row(
                  children: [
                    Text("Start date: ", style: TextStyle(
                            fontSize: 20.sp,
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w500,
                          ),),
                    Text(formattedStartDate,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontFamily: AppTheme.fontName,
                          ),),
                  ],
                ),
                SizedBox(height: 10.h),
                                Row(
                  children: [
                    Text("Deadline: ", style: TextStyle(
                            fontSize: 20.sp,
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w500,
                          ),),
                    Text(formattedDeadline,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontFamily: AppTheme.fontName,
                          ),),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Text("Progress: ",style: TextStyle(
                                  fontSize: 20.sp,
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                ),
                                ),
                    Text("${widget.task.progress} %", style: TextStyle(
                            fontSize: 20.sp,
                            fontFamily: AppTheme.fontName,
                          ),
                          ),
                  ],
                ),
                                SizedBox(height: 10.h),

                Container(
                width: 400.0.w,
                child: LinearPercentIndicator(
                  lineHeight: 10,
                  percent: widget.task.progress!.toDouble()/100,
                  progressColor: Colors.blue,
                  animation: true,
                  animationDuration: 800,
                ),
                            ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(context: context, builder: (context)=> EngineerEditTaskPopup(task: widget.task));                     
                          },
                      child: Icon(
                        Icons.edit_outlined,
                        size: 35.sp,
                        color: Color.fromARGB(255, 102, 31, 184),
                      ),
                    ),
                  ],
                ),
              ],
            ).animate().slideX(),
            ],
          ),
        ),
      ),
    ).animate(delay: 200.ms).slideX().shimmer(duration: 1500.ms);
  }

    Color getColorForPriority(String? priority) {
    switch (priority) {
      case 'Low':
        return  Colors.green;
      case 'Medium':
        return Colors.blue;
      case 'High':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

}