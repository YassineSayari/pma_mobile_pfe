import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:pma/theme.dart";

class UserSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
   void Function()? onTap;

   UserSearchBar({Key? key, this.onChanged, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
            

      child: Row(
        children: [
          Expanded(
            child: Container(
              width: 300.w,
              height: 45.h,
                    decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius:BorderRadius.circular(8.r),
                    boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 1), 
            ),
                    ],
                  ),
              child: TextField(
                onChanged: onChanged,
                  style: TextStyle(
                    fontSize: 24.sp, 
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w500
                    ),
                          decoration: InputDecoration(
                            labelText: 'Search...',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 99, 174, 189),
                              fontSize: 24.sp,
                              fontFamily: AppTheme.fontName,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide.none,
            
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide.none,
                              
                            ),
                            prefixIcon: Icon(
                            Icons.search,
                              color: Color.fromARGB(255, 99, 174, 189),
                              size: 30.sp,
                              ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: onTap,
            child: CircleAvatar(
              radius: 30.r,
               backgroundColor: Colors.white,
              child: Icon(
                Icons.refresh,
                size: 50.sp,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
