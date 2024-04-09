import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/models/task_model.dart';
import 'package:pma/services/task_service.dart';
import 'package:pma/team_leader/screens/tasks/my_tasks/tl_edit_tasks.dart';
import 'package:pma/theme.dart';

class TlTaskContainer extends StatefulWidget {
  final Task task;
  const TlTaskContainer({super.key, required this.task});

  @override
  State<TlTaskContainer> createState() => _TlTaskContainerState();
}

class _TlTaskContainerState extends State<TlTaskContainer> {
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
                        showDialog(context: context, builder: (context)=> TlEditTask(task: widget.task));                     
                          },
                      child: Icon(
                        Icons.edit_outlined,
                        size: 35.sp,
                        color: Color.fromARGB(255, 102, 31, 184),
                      ),
                    ),
                    SizedBox(width: 10.w),
                   GestureDetector(
                      onTap: () {
                        print("deleting task : ${widget.task.id}");
                        deleteTask(widget.task.id);
                       },
                      child: Icon(
                        Icons.delete_outline,
                        size: 35,
                        color: Color.fromARGB(255, 188, 14, 14),
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

    void deleteTask(String id) {
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
                           Text("Are you sure you want to delete this Task?",style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 24.sp)),
                           
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
                          TaskService().deleteTask(id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: SuccessSnackBar(message: "Task deleted !"),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                          );
                          Navigator.of(context).pushReplacementNamed("/tltasks");
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