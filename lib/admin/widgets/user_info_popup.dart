import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pma/const.dart';
import 'package:pma/theme.dart';

import '../../models/user_model.dart';



class EmployeeInfo extends StatelessWidget {
  final User employee;


  const EmployeeInfo({Key? key, required this.employee}) : super(key: key);

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
                      image: NetworkImage("$imageUrl/${employee.image}"),
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
              buildInfoRow(Icons.person, "Full Name:", employee.fullName),
              buildInfoRow(Icons.people_rounded, "Role:", employee.roles[0]),
              buildInfoRow(Icons.email, "Email:", employee.email),
              buildInfoRow(Icons.local_fire_department, "Department:", employee.department ?? "N/A"),
              buildInfoRow(Icons.phone, "Phone:", employee.phone),
              buildInfoRow(Icons.calendar_month, "Hiring Date:", DateFormat('MMM dd yyyy').format(employee.hiringDate)),
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
  }

  Widget buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 8.0.h,horizontal: 8.0.h),
      child: Row(
        children: [
          Icon(
            icon,
            //color: AppTheme.buildLightTheme().primaryColor,
            size: 25,
          ),
          SizedBox(width: 10.w),
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
}