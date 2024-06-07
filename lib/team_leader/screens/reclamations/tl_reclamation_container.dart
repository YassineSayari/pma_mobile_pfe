import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pma/models/reclamation_model.dart';
import 'package:pma/team_leader/screens/reclamations/tl_edit_reclamation.dart';
import 'package:pma/theme.dart';

class TlReclamationContainer extends StatefulWidget {
  final Reclamation reclamation;
  const TlReclamationContainer({super.key, required this.reclamation});

  @override
  State<TlReclamationContainer> createState() => _TlReclamationContainerState();
}

class _TlReclamationContainerState extends State<TlReclamationContainer> {
    bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    
        String formattedDate = DateFormat('MMMM dd, yyyy').format(DateTime.parse(widget.reclamation.addedDate));
        print("added date::::${widget.reclamation.addedDate}}");
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
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
                  Text("${widget.reclamation.title}",
                  style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 25.sp,
                            fontFamily: AppTheme.fontName,
                            
                          ),
                          ),
                  Spacer(),
                  Text("${widget.reclamation.status}",
                  style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: AppTheme.fontName,
                            color: getColorForStatus(widget.reclamation.status),
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
                                  Text("Client: ",
                                   style: TextStyle(
                                                fontSize: 20.sp,
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w500
                                              ),
                                              ),
                                   Text("${widget.reclamation.client['fullName']}",
                                      style: TextStyle(
                                                fontSize: 20.sp,
                                                fontFamily: AppTheme.fontName,
                                              ),
                                              ),
                                 ],
                               ),
                               SizedBox(height: 10.h),
                                Row(
                                  children: [
                                    Text("Type:",style: TextStyle(
                                                fontSize: 20.sp,
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w500
                                              ),
                                              ),
                                    Flexible(
                                      child: Text(" ${widget.reclamation.typeReclamation}",
                                        style: TextStyle(
                                                  fontSize: 18.sp,
                                                  fontFamily: AppTheme.fontName,
                                                ),
                                                ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
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
                           child: Text("${widget.reclamation.project['Projectname']}",
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
                        Text("Comment: ",
                         style: TextStyle(
                                      fontSize: 20.sp,
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500
                                    ),
                                    ),
                         Expanded(
                           child: Text("${widget.reclamation.comment}",
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
                    Text("Date: ", style: TextStyle(
                            fontSize: 20.sp,
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w500,
                          ),),
                    Text(formattedDate,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontFamily: AppTheme.fontName,
                          ),),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                      GestureDetector(
                      onTap: () {
                        showDialog(context: context, builder: (context)=> TlEditReclamationPopup(reclamation: widget.reclamation));                    
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

    Color getColorForStatus(String status) {
    switch (status) {
      case 'Pending':
        return  Colors.red;
      case 'In treatment':
        return Colors.blue;
      case 'Treated':
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}