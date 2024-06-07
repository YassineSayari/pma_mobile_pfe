import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/services/user_service.dart';
import 'package:pma/theme.dart';
import 'package:pma/services/shared_preferences.dart';
import 'dart:io';

class EditProfileImageDialog extends StatefulWidget {
  final String idUser;

  EditProfileImageDialog({required this.idUser});

  @override
  _EditProfileImageDialogState createState() => _EditProfileImageDialogState();
}

class _EditProfileImageDialogState extends State<EditProfileImageDialog> {
  File? selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (selectedImage != null) {
      String? authToken = await SharedPrefs.getAuthToken();
      await UserService().uploadImageUser(widget.idUser, selectedImage!, authToken!);

          ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SuccessSnackBar(message: "Image changed successfully!"),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
      Navigator.of(context).pushReplacementNamed("/profile"); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an image'),
        ),
      );
    }
  }

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
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display selected image preview
            if (selectedImage != null)
              Container(
                height: 200.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: FileImage(selectedImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(height: 12.h),
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
              onPressed: _pickImage,
              child: Text('Import New Photo',
              style:TextStyle(fontFamily: AppTheme.fontName,fontSize: 15.sp,fontWeight: FontWeight.w500),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _uploadImage,
                    child: Text('Save New Image',
                     style:TextStyle(fontFamily: AppTheme.fontName,fontSize: 15.sp,fontWeight: FontWeight.w500,color: Colors.white),
                     ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      primary: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: TextButton(
                                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                                },
                                child: Text('Cancel',
                                 style:TextStyle(fontFamily: AppTheme.fontName,fontSize: 15.sp,fontWeight: FontWeight.w500,color: Colors.white),
                                 ),
                                 style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      primary: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                              ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            
          ],
        ),
      ),
    );
  }
}