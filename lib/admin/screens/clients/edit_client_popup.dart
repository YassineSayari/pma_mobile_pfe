import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/services/user_service.dart';
import 'package:pma/theme.dart';
import '../../../models/user_model.dart';

class EditClientPopup extends StatefulWidget {
  final User client;

  EditClientPopup({required this.client});

  @override
  _EditClientPopupState createState() => _EditClientPopupState();
}

class _EditClientPopupState extends State<EditClientPopup> {

  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController mobileController;
  late TextEditingController emailController;
  late TextEditingController companyController;
  UserService userService= UserService();

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.client.fullName);
    mobileController = TextEditingController(text: widget.client.phone);
    emailController = TextEditingController(text: widget.client.email);
    companyController = TextEditingController(text: widget.client.company);

  }


  Future<void> updateClient() async {
    if (_formKey.currentState?.validate() == false ) {
        print("form invalid ");
    }
else{
    try {
      Map<String, dynamic> updatedData = {
        'fullName': nameController.text,
        'phone': mobileController.text,
        'email': emailController.text,
        'company': companyController.text,
      };
      print("updating client");
      await userService.updateUser(widget.client.id, updatedData);

      Navigator.of(context).pushReplacementNamed('/allclients');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: SuccessSnackBar(message: "Client updated successfully!"),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );

    } catch (error) {
      print('Error updating client: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: FailSnackBar(message: "Failed to  update client!"),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,          
        ),
      );
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
         shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 28.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
         child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Center(child: Text("Edit Client",style: TextStyle(fontFamily: AppTheme.fontName,fontWeight: FontWeight.w600,fontSize: 34.sp),)),
                SizedBox(height: 30.h),
                TextFormField(
                    controller: nameController,
                                    style: AppTextFieldStyles.textStyle,
                                          decoration: InputDecoration(
                                            labelText: 'Name*',
                                            labelStyle: AppTextFieldStyles.labelStyle,
                                            enabledBorder: AppTextFieldStyles.enabledBorder,
                                            focusedBorder: AppTextFieldStyles.focusedBorder,
                                          ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid name';
                    }
                    return null;
                  },
                ),
         
                SizedBox(height: 10.h),
         
                TextFormField(
                    controller: mobileController,
                                    style: AppTextFieldStyles.textStyle,
                                          decoration: InputDecoration(
                                            labelText: 'Mobile*',
                                            labelStyle: AppTextFieldStyles.labelStyle,
                                            enabledBorder: AppTextFieldStyles.enabledBorder,
                                            focusedBorder: AppTextFieldStyles.focusedBorder,
                                          ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid mobile';
                    }
                    return null;
                  },
                ),
         
                SizedBox(height: 10.h),
         
                TextFormField(
                    controller: emailController,
                                    style: AppTextFieldStyles.textStyle,
                                          decoration: InputDecoration(
                                            labelText: 'Email*',
                                            labelStyle: AppTextFieldStyles.labelStyle,
                                            enabledBorder: AppTextFieldStyles.enabledBorder,
                                            focusedBorder: AppTextFieldStyles.focusedBorder,
                                          ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),
         
                SizedBox(height: 10.h),
         
                TextFormField(
                    controller: companyController,
                                    style: AppTextFieldStyles.textStyle,
                                          decoration: InputDecoration(
                                            labelText: 'Company name*',
                                            labelStyle: AppTextFieldStyles.labelStyle,
                                            enabledBorder: AppTextFieldStyles.enabledBorder,
                                            focusedBorder: AppTextFieldStyles.focusedBorder,
                                          ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a company name';
                    }
                    return null;
                  },
                ),
         
                SizedBox(height: 10.h),
         
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          print("update pressed");
                        updateClient();
                        },
                        child: Text('Save',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25.sp,fontFamily: AppTheme.fontName ),),
                                     style: AppButtonStyles.submitButtonStyle,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25.sp,fontFamily: AppTheme.fontName ),),
                                     style: AppButtonStyles.cancelButtonStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
               ),
       ),
    ).animate(delay: 100.ms).fade(duration: 500.ms).slideY();
  }
}
