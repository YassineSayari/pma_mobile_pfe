import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pma/theme.dart';


class MyProjectContainer extends StatefulWidget {
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

  MyProjectContainer({
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
  _MyProjectContainerState createState() => _MyProjectContainerState();
}

class _MyProjectContainerState extends State<MyProjectContainer> {
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
      margin: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
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
                          style: TextStyle(fontWeight: FontWeight.w500,fontSize:22.sp,fontFamily: AppTheme.fontName)),
                    ),
                    TableCell(
                      child: Text(widget.description,
                      style: TextStyle(fontSize:22.sp,fontFamily: AppTheme.fontName),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text('Start Date :',
                          style: TextStyle(fontWeight: FontWeight.w500,fontSize:22.sp,fontFamily: AppTheme.fontName)),
                    ),
                    TableCell(
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 18.sp), // Calendar icon
                          SizedBox(width: 5),
                          Text(formattedDateDebut,
                          style: TextStyle(fontSize:22.sp,fontFamily: AppTheme.fontName),
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
                          style: TextStyle(fontWeight: FontWeight.w500,fontSize:22.sp,fontFamily: AppTheme.fontName)),
                    ),
                    TableCell(
                      child: Text(widget.teamLeaderId,
                      style: TextStyle(fontSize:22.sp,fontFamily: AppTheme.fontName),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text('Status :',
                          style: TextStyle(fontWeight: FontWeight.w500,fontSize:22.sp,fontFamily: AppTheme.fontName)),
                    ),
                    TableCell(
                      child: Text(widget.status,
                      style: TextStyle(fontSize:22.sp,fontFamily: AppTheme.fontName),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text('Priority :',
                          style: TextStyle(fontWeight: FontWeight.w500,fontSize:22.sp,fontFamily: AppTheme.fontName)),
                    ),
                    TableCell(
                      child: Row(
                        children: [
                          getPriorityIcon(widget.priority),
                          SizedBox(width: 5),
                          Text(widget.priority,
                          style: TextStyle(fontSize:22.sp,fontFamily: AppTheme.fontName),
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
                          style: TextStyle(fontWeight: FontWeight.w500,fontSize:22.sp,fontFamily: AppTheme.fontName)),
                    ),
                    TableCell(
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 18), 
                          SizedBox(width: 5),
                          Text(formattedDateFin,
                          style: TextStyle(fontSize:22.sp,fontFamily: AppTheme.fontName),
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
                          style: TextStyle(fontWeight: FontWeight.w500,fontSize:22.sp,fontFamily: AppTheme.fontName)),
                    ),
                    TableCell(
                      child: Text(widget.client,
                      style: TextStyle(fontSize:22.sp,fontFamily: AppTheme.fontName),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text('Team :',
                          style: TextStyle(fontWeight: FontWeight.w500,fontSize:22.sp,fontFamily: AppTheme.fontName)),
                    ),
                    TableCell(
                      child: Text(getTeamNames(widget.equipe),
                      style: TextStyle(fontSize:22.sp,fontFamily: AppTheme.fontName),
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
                              fontSize: 22.sp,fontFamily: AppTheme.fontName)),
                    ),
                    TableCell(
                      child: Text('${widget.progress}%',
                          style: TextStyle(color: Colors.grey,fontSize: 22.sp,fontFamily: AppTheme.fontName)),
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
          ],
        ],
      ),
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

