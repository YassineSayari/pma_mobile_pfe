import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
//import 'package:pma/custom_snackbar.dart';
import 'package:pma/models/procesv_model.dart';
//import 'package:pma/services/procesv_service..dart';
import 'package:pma/theme.dart';

class ClientProcesvContainer extends StatefulWidget {
  final Procesv procesv;
  const ClientProcesvContainer({super.key, required this.procesv});

  @override
  State<ClientProcesvContainer> createState() => _ClientProcesvContainerState();
}

class _ClientProcesvContainerState extends State<ClientProcesvContainer> {
    bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    
        String formattedStartDate = DateFormat('MMMM dd, yyyy').format(DateTime.parse(widget.procesv.date));

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
                  Text("${widget.procesv.title}",
                  style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 25.sp,
                            fontFamily: AppTheme.fontName,
                            
                          ),
                          ),
                  Spacer(),
                  
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
                SizedBox(height: 20.h),
                   Row(
                    children: [
                      Text(
                              "Project: ",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                      Text("${widget.procesv.project['Projectname']}",
                  style: TextStyle(
                            fontSize: 19.sp,
                            fontFamily: AppTheme.fontName,
                          ),
                          ),
                    ],
                   ),
                   SizedBox(height: 10.h),
                    Row(
                          children: [
                                Text(
                              "Members: ",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                             Flexible(
                               child: Text( widget.procesv.equipe.map((executor)  => executor['fullName']).join(', '),
                               style: TextStyle(
                                          fontSize: 20.sp,
                                          fontFamily: AppTheme.fontName,
                                        ),),
                             ),
                          

                          ],
                        ),
                       SizedBox(height: 10.h),
                      Row(
                       children: [
                        Text("Sender: ",
                         style: TextStyle(
                                      fontSize: 20.sp,
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500
                                    ),
                                    ),
                         Expanded(
                           child: Text("${widget.procesv.sender["fullName"]}",
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
                        Text("Communication : ",
                         style: TextStyle(
                                      fontSize: 20.sp,
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500
                                    ),
                                    ),
                         Expanded(
                           child: Text("${widget.procesv.Type_Communication}",
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
                        Text("Description: ",
                         style: TextStyle(
                                      fontSize: 20.sp,
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    ),
                         Expanded(
                           child: Text("${widget.procesv.description}",
                              style: TextStyle(
                                        fontSize: 20.sp,
                                        fontFamily: AppTheme.fontName,
                                        overflow: TextOverflow.ellipsis
                                      ),
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


}