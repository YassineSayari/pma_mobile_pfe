import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma/admin/screens/clients/edit_client_popup.dart';
import 'package:pma/admin/widgets/client_info_popup.dart';
import 'package:pma/const.dart';
import 'package:pma/models/user_model.dart';
import 'package:pma/theme.dart';


class ClientContainer extends StatelessWidget {
  final User user;

        
  final Function(String) onDelete;

  ClientContainer({required this.user, required this.onDelete});

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0.r),
                    child: Image.network(
                      "$imageUrl/${user.image}",
                      width: 100.0.w,
                      height: 100.0.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          noImageUrl,
                          width: 100.0.w,
                          height: 100.0.h,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.sp,
                          
                        ),
                      ),

                      Text(
                        user.email,
                        style: TextStyle(fontSize: 15.sp,color: Colors.grey[600],fontFamily: AppTheme.fontName),
                      ),
                      Text(
                        user.phone,
                        style: TextStyle(fontSize: 15.sp,color: Colors.grey[600],fontFamily: AppTheme.fontName),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 2.h),
              child: Row(
                children: [
                                GestureDetector(
                        onTap: () {
                        print("info clicked");
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                          return ClientInfo(user: user);
                           },
                        );
                      },
                  child: Icon(
                    Icons.info_outline,
                    size:30.sp,
                    color: Color.fromARGB(255, 102, 31, 184),
                  ),
                ),
                Spacer(),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                        return EditClientPopup(client: user);
                         },
                      );
                    },
                    child: Icon(
                      Icons.edit_outlined,
                      size: 30.sp,
                      color: Color.fromARGB(255, 102, 31, 184),
                    ),
                  ),
                  SizedBox(width: 20.h),
                  GestureDetector(
                    onTap: () => onDelete(user.id),
                    child: Icon(
                      Icons.delete_outline,
                      size: 30.sp,
                      color: Color.fromARGB(255, 188, 14, 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate(delay: 100.ms).slideX().shimmer(duration: 1500.ms),
    );
  }
}
