import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pma/admin/screens/projects/edit_project.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/theme.dart';

import '../../services/project_service.dart';

class ProjectContainer extends StatefulWidget {
  final String? projectId;
  final String projectName;
  final String status;
  final String description;
  final String type;
  final String dateDebut;
  final String teamLeaderId;
  final String priority;
  final String dateFin;
  final String client;
  final List<dynamic> equipe;
  final int progress;

  ProjectContainer({
    Key? key,
    this.projectId,
    required this.projectName,
    required this.description,
    required this.dateDebut,
    required this.teamLeaderId,
    required this.priority,
    required this.dateFin,
    required this.client,
    required this.equipe,
    required this.progress,
    required this.status,
    required this.type,
  }) : super(key: key);

  @override
  _ProjectContainerState createState() => _ProjectContainerState();
}

class _ProjectContainerState extends State<ProjectContainer> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    DateTime? parsedDateDebut = DateTime.tryParse(widget.dateDebut)?.toLocal();
    DateTime? parsedDateFin = DateTime.tryParse(widget.dateFin)?.toLocal();

    String formattedDateDebut = parsedDateDebut != null
        ? DateFormat('MMM d, yyyy').format(parsedDateDebut)
        : 'Invalid Date';

    String formattedDateFin = parsedDateFin != null
        ? DateFormat('MMM d, yyyy').format(parsedDateFin)
        : 'Invalid Date';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 10.h),
        decoration: BoxDecoration(
          color: AppTheme.nearlyWhite,
          borderRadius: BorderRadius.circular(8.0.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.projectName,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 25.sp,fontFamily: AppTheme.fontName)),
                SizedBox(width: 10.h),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: getColorForType(widget.type)['background'],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                        child: Text(
                          '${widget.type}',
                          style: TextStyle(
                            color: getColorForType(widget.type)['text'],fontFamily: AppTheme.fontName,fontSize: 15.sp
                          ),
                        ),
                      ),
                    ],
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
          ),
          if (isExpanded) ...[
            SizedBox(height: 10),
            Table(
              columnWidths: {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(4),
              },
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Text('Description :',
                          overflow: TextOverflow.clip,
                          style:AppTheme.projectContainerTitlesStyle),
                    ),
                    TableCell(
                      child: Text(widget.description,
                      style:AppTheme.projectContainerTextStyle,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text('Start Date :',
                          style:AppTheme.projectContainerTitlesStyle,),
                    ),
                    TableCell(
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 18.sp),
                          SizedBox(width: 5),
                          Text(formattedDateDebut,
                          style:AppTheme.projectContainerTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              TableRow(
                  children: [
                    TableCell(
                      child: Text('Team Leader:',
                          style:AppTheme.projectContainerTitlesStyle,
                          ),
                    ),
                    TableCell(
                      child: Text(widget.teamLeaderId,
                      style:AppTheme.projectContainerTextStyle,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text('Status :',
                          style:AppTheme.projectContainerTitlesStyle,
                          ),
                    ),
                    TableCell(
                      child: Text(widget.status,
                      style:AppTheme.projectContainerTextStyle,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text('Priority :',
                          style:AppTheme.projectContainerTitlesStyle,
                          ),
                    ),
                    TableCell(
                      child: Row(
                        children: [
                          getPriorityIcon(widget.priority),
                          SizedBox(width: 5),
                          Text(widget.priority,
                         style:AppTheme.projectContainerTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text('Deadline :',
                         style:AppTheme.projectContainerTitlesStyle,
                         ),
                    ),
                    TableCell(
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 18), 
                          SizedBox(width: 5),
                          Text(formattedDateFin,
                         style:AppTheme.projectContainerTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text('Client :',
                          style:AppTheme.projectContainerTitlesStyle,
                          ),
                    ),
                    TableCell(
                      child: Text(widget.client,
                      style:AppTheme.projectContainerTextStyle,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text('Team :',
                         style:AppTheme.projectContainerTitlesStyle,
                         ),
                    ),
                    TableCell(
                      child: Text(getTeamNames(widget.equipe),
                       style:AppTheme.projectContainerTextStyle,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text('Progress',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,fontFamily: AppTheme.fontName)),
                    ),
                    TableCell(
                      child: Text('${widget.progress}%',
                          style: TextStyle(color: Colors.grey,fontSize: 20.sp,fontFamily: AppTheme.fontName)),
                    ),
                  ],
                ),
              ],
            ).animate()
            .slideX(duration: 700.ms),
            SizedBox(height: 10),
            Container(
              width: 400.0.w,
              child: LinearPercentIndicator(
                lineHeight: 10,
                percent: widget.progress.toDouble()/100,
                progressColor: Colors.blue,
                animation: true,
                animationDuration: 800,
              ),
            ),
            SizedBox(height: 10),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              child: Row(
                children: [
                       GestureDetector(
                      onTap: () {
                          Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProject(projectId: widget.projectId!, projectTitle: widget.projectName, description: widget.description, type: widget.type, status: widget.status, priority: widget.priority, dateFin: widget.dateFin, teamLeaderId: widget.teamLeaderId, equipe: widget.equipe,),
                                ),
                              );                      },
                      child: Icon(
                        Icons.edit_outlined,
                        size: 35,
                        color: Color.fromARGB(255, 102, 31, 184),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        print("deleting project : ${widget.projectId}");
                        deleteProject(widget.projectId!);},
                      child: Icon(
                        Icons.delete_outline,
                        size: 35,
                        color: Color.fromARGB(255, 188, 14, 14),
                      ),
                    ),
                ],
              ),
            )
          ],
        ],
      ),
    );
  }

  
  void deleteProject(String id) {
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
                           Text("Are you sure you want to delete this Project?",style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 20.sp)),
                           
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
                          ProjectService().deleteProject(id);
                          setState(() {
                          });
                          Navigator.of(context).pushReplacementNamed("/allprojects");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: SuccessSnackBar(message: "Project deleted successfylly!"),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                          );
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

  Map<String, dynamic> getColorForType(String type) {
    switch (type) {
      case 'Development':
        return {'background': Colors.blue, 'text': Colors.white};
      case 'Systems Infrastructure':
        return {'background': Colors.grey[400], 'text': Colors.black};
      case 'Network Infrastructure':
        return {'background': Colors.orange, 'text': Colors.white};
      case 'Systems And Networks Infrastructure':
        return {'background': Colors.green, 'text': Colors.white};
      default:
        return {'background': Colors.grey, 'text': Colors.black};
    }
  }
}


  Map<String, dynamic> getColorForType(String type) {
    switch (type) {
      case 'Development':
        return {'background': Colors.blue, 'text': Colors.white};
      case 'Systems Infrastructure':
        return {'background': Colors.grey[400], 'text': Colors.black};
      case 'Network Infrastructure':
        return {'background': Colors.orange, 'text': Colors.white};
      case 'Systems And Networks Infrastructure':
        return {'background': Colors.green, 'text': Colors.white};
      default:
        return {'background': Colors.grey, 'text': Colors.black};
    }
  }

  String getTeamNames(List<dynamic> equipe) {
    if (equipe.isEmpty) {
      return 'No Team Members';
    }
    return equipe.map((member) => member['fullName']).join(', ');
  }


  Widget getPriorityIcon(String priority) {
    switch (priority) {
      case 'High':
        return Icon(Icons.keyboard_double_arrow_up_rounded, color: Colors.red);
      case 'Medium':
        return Icon(Icons.swap_horiz_rounded, color: Colors.orange);
      case 'Low':
        return Icon(Icons.keyboard_double_arrow_down_rounded, color: Colors.green);
      default:
        return Icon(Icons.swap_horiz_rounded, color: Colors.grey); // Default icon
    }
  }

