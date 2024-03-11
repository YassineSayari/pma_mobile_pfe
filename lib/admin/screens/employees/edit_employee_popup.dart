import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/theme.dart';
import '../../../models/user_model.dart';
import '../../../services/user_service.dart';

class EditEmployeePopup extends StatefulWidget {
  final User employee;

  EditEmployeePopup({required this.employee});

  @override
  _EditEmployeePopupState createState() => _EditEmployeePopupState();
}

class _EditEmployeePopupState extends State<EditEmployeePopup> {

  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController roleController;
  late TextEditingController mobileController;
  late TextEditingController emailController;
  late DateTime? hiringDate;

  late String selectedDepartment;
  late String selectedGender;

  final List<String> departments = ['Development', 'Networking', 'Systems'];
  final List<String> genders = ['male', 'female'];
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data
    nameController = TextEditingController(text: widget.employee.fullName);
    roleController = TextEditingController(text: widget.employee.roles.join(', '));
    mobileController = TextEditingController(text: widget.employee.phone);
    emailController = TextEditingController(text: widget.employee.email);

    selectedDepartment = widget.employee.department ?? ' ';
    selectedGender = widget.employee.gender;

    hiringDate = widget.employee.hiringDate;
  }

  Future<void> updateEmployee() async {
    if (_formKey.currentState?.validate() == false) {
      print("form invalid ");
    } else {
      try {
        Map<String, dynamic> updatedData = {
          'fullName': nameController.text,
          'roles': roleController.text.split(','),
          'phone': mobileController.text,
          'email': emailController.text,
          'department': selectedDepartment,
          'gender': selectedGender,
          'hiringDate': hiringDate?.toUtc().toIso8601String(),
        };

        print("updating employee");
        await userService.updateUser(widget.employee.id, updatedData);
        Navigator.of(context).pushReplacementNamed("/allemployees");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: SuccessSnackBar(message: "Employee updated successfully!"),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
      } catch (error) {
        print('Error updating employee: $error');
                ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: FailSnackBar(message: "failed to update eployee!"),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
        Navigator.of(context).pop();
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
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text("Edit",style: TextStyle(fontFamily: AppTheme.fontName,fontWeight: FontWeight.w600,fontSize: 34.sp),)),
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
            
                SizedBox(height: 15.h),
            
                DropdownButtonFormField<String>(
                  value: departments.contains(selectedDepartment) ? selectedDepartment : null,
                  onChanged: (value) {
                    setState(() {
                      selectedDepartment = value!;
                    });
                  },
                  items: departments.map((department) {
                    return DropdownMenuItem<String>(
                      value: department,
                      child: Text(department),
                    );
                  }).toList(),
                                    style: AppTextFieldStyles.textStyle,
                                          decoration: InputDecoration(
                                            labelText: 'Department*',
                                            labelStyle: AppTextFieldStyles.labelStyle,
                                            enabledBorder: AppTextFieldStyles.enabledBorder,
                                            focusedBorder: AppTextFieldStyles.focusedBorder,
                                          ),
                ),
            
                SizedBox(height: 15.h),
                TextFormField(
                  controller: roleController,
                                    style: AppTextFieldStyles.textStyle,
                                          decoration: InputDecoration(
                                            labelText: 'Role*',
                                            labelStyle: AppTextFieldStyles.labelStyle,
                                            enabledBorder: AppTextFieldStyles.enabledBorder,
                                            focusedBorder: AppTextFieldStyles.focusedBorder,
                                          ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid role';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15.h),
            
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                  items: genders.map((gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                                    style: AppTextFieldStyles.textStyle,
                                          decoration: InputDecoration(
                                            labelText: 'Gender*',
                                            labelStyle: AppTextFieldStyles.labelStyle,
                                            enabledBorder: AppTextFieldStyles.enabledBorder,
                                            focusedBorder: AppTextFieldStyles.focusedBorder,
                                          ),
                ),
            
                SizedBox(height: 15.h),
            
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
            
                SizedBox(height: 15.h),
            
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
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
            
                SizedBox(height: 15.h),
            
                TextFormField(
                  controller: TextEditingController(
                    //toLocal khatr date was converted to utc earlier so we need to convert to local to prevent conflict
                    text: hiringDate != null ? DateFormat('MMM dd yyyy').format(hiringDate!.toLocal()) : '',
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null && pickedDate != hiringDate) {
                      setState(() {
                        hiringDate = pickedDate;
                      });
                    }
                  },
                  readOnly: true,
                                    style: AppTextFieldStyles.textStyle,
                                          decoration: InputDecoration(
                                            labelText: 'Hiring Date*',
                                            labelStyle: AppTextFieldStyles.labelStyle,
                                            enabledBorder: AppTextFieldStyles.enabledBorder,
                                            focusedBorder: AppTextFieldStyles.focusedBorder,
                                          
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: Colors.grey[400],
                    ),
                  ),
                  validator: (value) {
                    if (hiringDate == null) {
                      return 'Hiring Date is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          print("update pressed");
                          updateEmployee();
                        },
                        child: Text('Save',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25.sp,fontFamily: AppTheme.fontName ),),
                                   style: AppButtonStyles.submitButtonStyle
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25.sp,fontFamily: AppTheme.fontName ),),
                                   style: AppButtonStyles.cancelButtonStyle
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
