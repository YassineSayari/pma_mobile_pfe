
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pma/const.dart';
import 'package:pma/custom_appbar.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/services/shared_preferences.dart';
import 'package:pma/theme.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;


import '../../widgets/admin_drawer.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}


class _AddEmployeeState extends State<AddEmployee> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullname = TextEditingController();
  final TextEditingController mail = TextEditingController();

  String? gender;
  final TextEditingController mobile = TextEditingController();

  final TextEditingController password = TextEditingController();
  final TextEditingController passwordconf = TextEditingController();

  final TextEditingController address = TextEditingController();
  String? department;
  String? role;

  final TextEditingController hiredate = TextEditingController();
  final TextEditingController birthdate = TextEditingController();

  DateTime? birthDate;
  TextEditingController birthDateController = TextEditingController();

  DateTime? hiringDate;
  TextEditingController hiringDateController = TextEditingController();


  XFile? selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = pickedFile;
      });
    }
  }

  Future<void> _handleAddUser() async {
     String? authToken = await SharedPrefs.getAuthToken();

    print("adding user");
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('$baseUrl/api/v1/users/adduser'), 
    
  );

  request.headers['Authorization'] = 'Bearer $authToken';
  print("token:::: ${request.headers}");
  request.fields['fullName'] = fullname.text;
  request.fields['email'] = mail.text;
  request.fields['password'] = password.text;
  request.fields['gender'] = gender!;
  request.fields['roles[]'] = role!;
  request.fields['phone'] = mobile.text;
  request.fields['address'] = address.text;
  request.fields['department'] = department!;
  request.fields['birthDate'] = DateFormat('yyyy-MM-dd').format(birthDate!);
  request.fields['hiringDate'] = DateFormat('yyyy-MM-dd').format(hiringDate!);

  if (selectedImage != null) {
    var file = await http.MultipartFile.fromPath(
      'image',
      selectedImage!.path,
      filename: path.basename(selectedImage!.path),
      contentType: MediaType('image', 'jpg'), 
    );
    request.files.add(file);
  }

  print("sending requestt::::: $request");
  var response = await request.send();

  // Handle the response
  if (response.statusCode == 200) {
    print("User added successfully");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SuccessSnackBar(message: "Employee added successfully"),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
    resetForm();
  } else {
    print("Failed to add user");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: FailSnackBar(message: "Failed to add Employee"),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: AdminDrawer(selectedRoute: '/addemployee'),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          CustomAppBar(title: 'Add Employee'),
          Expanded(
            child: ListView(
              children: [
                
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:20.w,vertical: 8.h ),
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: fullname,
                        keyboardType: TextInputType.text,
                        style: TextInputDecorations.textStyle,
                                decoration: TextInputDecorations.customInputDecoration(labelText: 'Full Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Full Name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: mail,
                        style: TextInputDecorations.textStyle,
                                decoration: TextInputDecorations.customInputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          return null;
                        },
                      ),
            
                      SizedBox(height: 10.h),
            
                      DropdownButtonFormField(
                        value: gender,
                        isExpanded: true,
                        style: TextInputDecorations.textStyle,
                                decoration: TextInputDecorations.customInputDecoration(labelText: 'Gender'),
                        items: [
                          DropdownMenuItem(child: Text('Male',style: TextStyle(fontSize: 20,fontFamily: AppTheme.fontName,),),value:'Male'),
                          DropdownMenuItem(child: Text('Female',style: TextStyle(fontSize: 20,fontFamily: AppTheme.fontName,),),value:'Female'),
                          ],
                        onChanged:(selectedValue)
                        {
                          gender = selectedValue as String?;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Gender is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
                      
                      TextFormField(
                        controller: mobile,
                        keyboardType: TextInputType.number,
                        style: TextInputDecorations.textStyle,
                                decoration: TextInputDecorations.customInputDecoration(labelText: 'Mobile'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mobile number is required';
                          }
                          return null;
                        },
                      ),
            
                      SizedBox(height: 10.h),
            
                      TextFormField(
                        controller: password,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        style: TextInputDecorations.textStyle,
                                decoration: TextInputDecorations.customInputDecoration(labelText: 'Password'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: passwordconf,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        style: TextInputDecorations.textStyle,
                                decoration: TextInputDecorations.customInputDecoration(labelText: 'Re-Enter Password'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Re-Enter password is required';
                          }
                          return null;
                        },
                      ),
            
                      SizedBox(height: 10.h),
            
                      TextFormField(
                        controller: address,
                        keyboardType: TextInputType.text,

                        style: TextInputDecorations.textStyle,
                                decoration: TextInputDecorations.customInputDecoration(labelText: 'Address'),
                      ),
                      SizedBox(height: 10.h),
                      DropdownButtonFormField(
                        value: department,
                        isExpanded: true,
                        style: TextInputDecorations.textStyle,
                                decoration: TextInputDecorations.customInputDecoration(labelText: 'Department'),
                        items: [
                          DropdownMenuItem(child: Text('Development',style: TextStyle(fontSize: 18,fontFamily: AppTheme.fontName,),),value:'Development'),
                          DropdownMenuItem(child: Text('System',style: TextStyle(fontSize: 18,fontFamily: AppTheme.fontName,),),value:'System'),
                          DropdownMenuItem(child: Text('Networking',style: TextStyle(fontSize: 18,fontFamily: AppTheme.fontName,),),value:'Networking'),
                        ],
                        
                        onChanged:(selectedDepartment)
                        {
                          department = selectedDepartment as String?;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Department is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
                      DropdownButtonFormField(
                        value: role,
                        style: TextInputDecorations.textStyle,
                        decoration: TextInputDecorations.customInputDecoration(labelText: 'Role'),
                        items: [
                          DropdownMenuItem(child: Text('Engineer', style: TextStyle(fontSize: 20.sp, fontFamily: AppTheme.fontName)), value: 'Engineer'),
                          DropdownMenuItem(child: Text('Client', style: TextStyle(fontSize: 20.sp, fontFamily: AppTheme.fontName)), value: 'Client'),
                          DropdownMenuItem(child: Text('Team Leader', style: TextStyle(fontSize: 20.sp, fontFamily: AppTheme.fontName)), value: 'Team Leader'),
                        ],
                        onChanged: (selectedRole) {
                          setState(() {
                            role = selectedRole as String?;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Department is required';
                          }
                          return null;
                        },
                      ),
            
                      SizedBox(height: 10.h),
            
                      TextFormField(
                        onTap: () async {
                            
                          DateTime today = DateTime.now();
                          DateTime eighteenYearsAgo = today.subtract(Duration(days: 18 * 365));
                          DateTime sixtyYearsAgo = today.subtract(Duration(days: 60 * 365));
                            
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: eighteenYearsAgo,
                            firstDate: sixtyYearsAgo,
                            lastDate: eighteenYearsAgo,
                          );
                          if (pickedDate != null && pickedDate != birthDate) {
                            setState(() {
                              birthDate = pickedDate;
                              birthDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        },
                        controller: birthDateController,
                        readOnly: true,
                        style: DateFieldsStyle.textStyle,
                              decoration: InputDecoration(
                              labelText: 'Birth Date*',
                              labelStyle: DateFieldsStyle.labelStyle,
                              enabledBorder: DateFieldsStyle.enabledBorder,
                              focusedBorder: DateFieldsStyle.focusedBorder,
                              prefixIcon: Icon(
                                Icons.calendar_today,
                                color: Colors.grey[400],
                              ),
                            ),
                        validator: (value) {
                          if (birthDate == null) {
                            return 'Birthdate is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
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
                              hiringDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                            
                            });
                          }
                        },
                        controller:hiringDateController ,
                        readOnly: true,
                        style: DateFieldsStyle.textStyle,
                              decoration: InputDecoration(
                              labelText: 'Hiring Date*',
                              labelStyle: DateFieldsStyle.labelStyle,
                              enabledBorder: DateFieldsStyle.enabledBorder,
                              focusedBorder: DateFieldsStyle.focusedBorder,
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
            
                      SizedBox(height: 30.h),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Column(
                          children: [
                            if (selectedImage != null)
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: FileImage(File(selectedImage!.path)), // Convert XFile to File
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            else
                              Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.grey[600],
                              ),
                            SizedBox(height: 8),
                            Text(
                              'Upload Image',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
            
                      SizedBox(height: 20),
            
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _handleAddUser,
                                    style: AppButtonStyles.submitButtonStyle,
                                    child: Text('Submit',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print("reset");
                                      resetForm();
                                    },
                                    style: AppButtonStyles.cancelButtonStyle,
                                    child: Text('Cancel',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void resetForm() {
    setState(() {
      fullname.clear();
      mail.clear();
      gender = null;
      mobile.clear();
      password.clear();
      passwordconf.clear();
      address.clear();
      department = null;
      birthDate = null;
      birthDateController.clear();
      hiringDate = null;
      hiringDateController.clear();
      selectedImage = null;
    });
  }

}
