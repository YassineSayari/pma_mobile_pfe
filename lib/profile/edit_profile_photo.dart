import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma/services/user_service.dart';
import 'package:pma/theme.dart';

class EditProfileImageDialog extends StatelessWidget {
  final String idUser;

  EditProfileImageDialog({ required this.idUser});
  

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(horizontal:16.0.w,vertical: 16.0.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Edit Profile Image',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () async {
                await UserService().UploadImageUser(idUser);
                //Navigator.pop(context);
              },
              child: Text('Import New Photo'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Close'),
              style: TextButton.styleFrom(
                primary: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}