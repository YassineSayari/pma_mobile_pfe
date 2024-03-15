import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/models/risk_model.dart';
import 'package:pma/services/risk_service.dart';
import 'package:pma/theme.dart';

class RiskContainer extends StatefulWidget {
  final Risk risk;
  const RiskContainer({super.key, required this.risk});

  @override
  State<RiskContainer> createState() => _RiskContainerState();
}

class _RiskContainerState extends State<RiskContainer> {
    bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    
        String formattedDate = DateFormat('MMMM dd, yyyy').format(DateTime.parse(widget.risk.date));

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
                  Text("${widget.risk.title}",
                  style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 25.sp,
                            fontFamily: AppTheme.fontName,
                            
                          ),
                          ),
                  Spacer(),
                  Text("${widget.risk.impact}",
                  style: TextStyle(
                            fontSize: 19.sp,
                            fontFamily: AppTheme.fontName,
                            color: getColorForImpact(widget.risk.impact),
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
                                  Text("User: ",
                                   style: TextStyle(
                                                fontSize: 20.sp,
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w500
                                              ),
                                              ),
                                   Text("${widget.risk.user['fullName']}",
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
                                    Text("Action:",style: TextStyle(
                                                fontSize: 20.sp,
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w500
                                              ),
                                              ),
                                    Flexible(
                                      child: Text(" ${widget.risk.action}",
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
                           child: Text("${widget.risk.project['Projectname']}",
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
                        Text("Details: ",
                         style: TextStyle(
                                      fontSize: 20.sp,
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    ),
                         Expanded(
                           child: Text("${widget.risk.details}",
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
                        print("deleting risk : ${widget.risk.id}");
                       deleteRisk(widget.risk.id);
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

    Color getColorForImpact(String impact) {
    switch (impact) {
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


  void deleteRisk(String id) {
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
                           Text("Are you sure you want to delete this Risk?",style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 24.sp)),
                           
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
                          RiskService().deleteRisk(id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: SuccessSnackBar(message: "Risk deleted !"),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                          );
                          Navigator.of(context).pushReplacementNamed("/risks");
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