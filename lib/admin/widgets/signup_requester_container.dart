import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:pma/const.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/theme.dart';

import '../../services/user_service.dart';

class SignUpRequester extends StatelessWidget {
  final String userId;
  final String name;
  final String role;
  final String mobile;
  final String email;
  final String image;

  const SignUpRequester({
    Key? key,
    required this.name,
    required this.role,
    required this.mobile,
    required this.email,
    required this.userId,
     required this.image,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
                Container(
                  width: 200.w,
                  height: 200.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage("$imageUrl/${image}"),
                      fit: BoxFit.cover,
                    ),
              ),
              ),
              SizedBox(height: 20.h),
                  Text(
                    "Details",
                style: TextStyle(fontSize: 35.sp, fontWeight: FontWeight.w600,fontFamily: AppTheme.fontName),
                  ),
                  SizedBox(height: 15.h),
                  buildInfoRow(Icons.person, "Full Name:", name),
                  buildInfoRow(Icons.people_rounded, "Role:", role),
                  buildInfoRow(Icons.email, "Email:", email),
                  buildInfoRow(Icons.phone, "Phone:", mobile),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      _showAcceptionDialog(context, userId);
                      },
                    icon: Icon(Icons.check_box_outlined),
                    tooltip: 'Approve',
                    iconSize: 40.sp,
                    color: Colors.blue,

                  ),
                  SizedBox(width: 50.w),
                  IconButton(
                    onPressed: () {
                      _showDeleteDialog(context, userId);
                    },
                    icon: Icon(Icons.delete_outline_rounded),
                    tooltip: 'Delete',
                    iconSize: 40.sp,
                    color: Colors.red,
                  ),
                ],
              ),
                ),
              ),
            ],
          ),
        ),
      );
  }

    Widget buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 8.0.h,horizontal: 8.0.h),
      child: Row(
        children: [
          Icon(
            icon,
           // color: AppTheme.buildLightTheme().primaryColor,
            size: 25.sp,
          ),
          SizedBox(width: 10.h),
          Text(
            label,
            style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.w500,fontFamily: AppTheme.fontName),
          ),
                    SizedBox(width: 10.w),

          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 20.sp,fontFamily: AppTheme.fontName),
            ),
          ),
        ],
      ),
    );
  }



  void _showDeleteDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
           shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 28.h),
      child:Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
        child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

          Text("Denial Confirmation",
          style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w600,fontFamily: AppTheme.fontName),
          ),
          SizedBox(height: 10.h),
          Text(
            "Are you sure you want to deny $name's signup?",  
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500,fontFamily: AppTheme.fontName),
          ),
          SizedBox(height: 10.h),
          Text("Name: $name",
            style: TextStyle(fontSize: 20.sp,fontFamily: AppTheme.fontName),
          ),
          Text("Email: $email",
             style: TextStyle(fontSize: 20.sp,fontFamily: AppTheme.fontName),
          ),
          Text("Role: $role",
             style: TextStyle(fontSize: 20.sp,fontFamily: AppTheme.fontName),
          ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    print("delete pressed");
                    UserService userService = GetIt.I<UserService>();
                    await userService.deleteUser(userId);
                    Navigator.of(context).pushReplacementNamed('/signuprequests');
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: SuccessSnackBar(message: "Request denied successfully !"),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                      );
                  },
                  child: Text("Delete",style: TextStyle(color:Colors.red,fontFamily: AppTheme.fontName,fontWeight: FontWeight.w500,fontSize: 20.sp)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel",style: TextStyle(fontFamily: AppTheme.fontName,fontWeight: FontWeight.w500,fontSize: 20.sp)),
                ),
              ],
            ),
          ],
                      
            ),
        ),
      ),
      ).animate(delay: 100.ms).fade().scale();
      },
    );
  }
  void _showAcceptionDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
           shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 28.h),
      child:Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
        child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

          Text("Acceptance Confirmation",
          style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w600,fontFamily: AppTheme.fontName),
          ),
          SizedBox(height: 10.h),
          Text(
            "Are you sure you want to accept $name's signup?",  
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500,fontFamily: AppTheme.fontName),
          ),
          SizedBox(height: 10.h),
          Text("Name: $name",
            style: TextStyle(fontSize: 20.sp,fontFamily: AppTheme.fontName),
          ),
          Text("Email: $email",
             style: TextStyle(fontSize: 20.sp,fontFamily: AppTheme.fontName),
          ),
          Text("Role: $role",
             style: TextStyle(fontSize: 20.sp,fontFamily: AppTheme.fontName),
          ),
          SizedBox(height: 10.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    UserService userService = GetIt.I<UserService>();
                    await userService.confirmSignupRequests(userId);
                    Navigator.of(context).pushReplacementNamed('/signuprequests');
                    ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: SuccessSnackBar(message: "Request accepted successfully !"),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                          );
                  },
                  child: Text("Accept",style: TextStyle(fontFamily: AppTheme.fontName,fontWeight: FontWeight.w500,fontSize: 20.sp)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel",style: TextStyle(fontFamily: AppTheme.fontName,fontWeight: FontWeight.w500,fontSize: 20.sp)),
                ),
              ],
            ),

          ],
                      
            ),
        ),
      ),
      ).animate(delay: 100.ms).fade().scale();
      },
    );
  }


}
