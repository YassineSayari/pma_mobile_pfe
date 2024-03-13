import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pma/admin/screens/procesv/edit_procesv.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/models/procesv_model.dart';
import 'package:pma/services/procesv_service..dart';
import 'package:pma/theme.dart';

class ProcesvContainer extends StatefulWidget {
  final Procesv procesv;
  const ProcesvContainer({super.key, required this.procesv});

  @override
  State<ProcesvContainer> createState() => _ProcesvContainerState();
}

class _ProcesvContainerState extends State<ProcesvContainer> {
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
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                       showDialog(context: context, builder: (context)=> EditProcesv(procesv: widget.procesv));                     
                          },
                      child: Icon(
                        Icons.edit_outlined,
                        size: 35.sp,
                        color: Color.fromARGB(255, 102, 31, 184),
                      ),
                    ),
                   SizedBox(width: 20.w),
                   GestureDetector(
                      onTap: () {
                        print("deleting task : ${widget.procesv.id}");
                       deleteProcesv(widget.procesv.id);
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


  void deleteProcesv(String id) {
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
                           Text("Are you sure you want to delete this Procev verbal?",style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 24.sp)),
                           
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
                          ProcesVService().deleteProcesv(id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: SuccessSnackBar(message: "Procev Verbal deleted !"),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                          );
                          Navigator.of(context).pushReplacementNamed("/procesv");
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