import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma/const.dart';
import 'package:pma/theme.dart';

import '../../models/user_model.dart';



class ClientInfo extends StatelessWidget {
  final User user;


  const ClientInfo({Key? key, required this.user}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 28.h),
      child: Container(
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
                      image: NetworkImage("$imageUrl/${user.image}"),
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
                  buildInfoRow(Icons.person, "Full Name:", user.fullName),
                  //buildInfoRow(Icons.people_rounded, "Role:", user.roles[0]),
                  buildInfoRow(Icons.email, "Email:", user.email),
                  buildInfoRow(Icons.phone, "Phone:", user.phone),
                  buildInfoRow(Icons.factory_outlined, "Company Name:", user.company ?? 'N/A'),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: Color.fromARGB(255, 20, 91, 150),
                      fontWeight:FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: 100.ms).fade(duration: 500.ms).slideY();
    // ).animate(delay: 200.ms).fade().shimmer(duration: 1000.ms);
  }

  Widget buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 8.0.h,horizontal: 8.0.h),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.buildLightTheme().primaryColor,
            size: 25.sp,
          ),
          SizedBox(width: 10.h),
          Text(
            label,
            style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.w500,fontFamily: AppTheme.fontName),
          ),
                    SizedBox(width: 10.w),

          Text(
            value,
            style: TextStyle(fontSize: 20.sp,fontFamily: AppTheme.fontName),
          ),
        ],
      ),
    );
  }
}