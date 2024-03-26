import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pma/admin/screens/reclamations/edit_reclamations_popup.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/models/reclamation_model.dart';
import 'package:pma/services/reclamation_service.dart';
import 'package:pma/theme.dart';

class ReclamationContainer extends StatefulWidget {
  final Reclamation reclamation;
  const ReclamationContainer({super.key, required this.reclamation});

  @override
  State<ReclamationContainer> createState() => _ReclamationContainerState();
}

class _ReclamationContainerState extends State<ReclamationContainer> {
    bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    
        String formattedDate = DateFormat('MMMM dd, yyyy').format(DateTime.parse(widget.reclamation.addedDate));
        print("added date::::${widget.reclamation.addedDate}}");
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
                            fontSize: 19.sp,
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
              //  Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //    children: [
              //      Expanded(
              //        child: Row(
              //          children: [
              //           Text("Client: ",
              //            style: TextStyle(
              //                         fontSize: 20.sp,
              //                         fontFamily: AppTheme.fontName,
              //                         fontWeight: FontWeight.w500
              //                       ),
              //                       ),
              //            Text("${widget.reclamation.client['fullName']}",
              //               style: TextStyle(
              //                         fontSize: 20.sp,
              //                         fontFamily: AppTheme.fontName,
              //                       ),
              //                       ),
              //          ],
              //        ),
              //      ),
              //       Expanded(
              //         child: Row(
              //           children: [
              //             Text("Type:",style: TextStyle(
              //                         fontSize: 20.sp,
              //                         fontFamily: AppTheme.fontName,
              //                         fontWeight: FontWeight.w500
              //                       ),
              //                       ),
              //             Flexible(
              //               child: Text(" ${widget.reclamation.typeReclamation}",
              //                 style: TextStyle(
              //                           fontSize: 18.sp,
              //                           fontFamily: AppTheme.fontName,
              //                         ),
              //                         ),
              //             ),
              //           ],
              //         ),
              //       ),                      
              //    ],
              //  ),
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
                        showDialog(context: context, builder: (context)=> EditReclamationPopup(reclamation: widget.reclamation));                    
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
                        print("deleting reclamation : ${widget.reclamation.id}");
                       deleteReclamation(widget.reclamation.id);
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


  void deleteReclamation(String id) {
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
                           Text("Are you sure you want to delete this Reclamation?",style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 24.sp)),
                           
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
                          ReclamationService().deleteReclamation(id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: SuccessSnackBar(message: "Reclamation deleted !"),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                          );
                          Navigator.of(context).pushReplacementNamed("/reclamations");
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