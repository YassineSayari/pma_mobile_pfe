
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pma/custom_appbar.dart';
import 'package:pma/theme.dart';

import '../../../services/user_service.dart';
import '../../widgets/admin_drawer.dart';

class AddClient extends StatefulWidget {
  const AddClient({super.key});

  @override
  State<AddClient> createState() => _AddClientState();
}


class _AddClientState extends State<AddClient> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController company = TextEditingController();

  final TextEditingController mail = TextEditingController();
  final TextEditingController mobile = TextEditingController();

  DateTime? clientDate;
  TextEditingController dateController = TextEditingController();


  final TextEditingController password = TextEditingController();
  final TextEditingController passwordconf = TextEditingController();

  UserService userService= UserService();


  XFile? selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = pickedFile;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: AdminDrawer(selectedRoute: '/addclient'),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          CustomAppBar(title: "Add Client"),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal:8.w,vertical: 8.h),
                  child:
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: name,
                          keyboardType: TextInputType.text,
                                    style: TextInputDecorations.textStyle,
                          decoration: TextInputDecorations.customInputDecoration(labelText: 'Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.h),
                        TextFormField(
                          controller: company,
                          keyboardType: TextInputType.text,
                          style: TextInputDecorations.textStyle,
                          decoration: TextInputDecorations.customInputDecoration(labelText: 'Company'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Company name is required';
                            }
                            return null;
                          },
                        ),
            
                        SizedBox(height: 10.h),

                        TextFormField(
                          controller: mail,
                          keyboardType: TextInputType.text,
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
                        
                        TextFormField(
                          controller: mobile,
                          keyboardType: TextInputType.number,
                          style: TextInputDecorations.textStyle,
                          decoration: TextInputDecorations.customInputDecoration(labelText: 'Mbile'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mobile number is required';
                            }
                            return null;
                          },
                        ),
            
                        SizedBox(height: 10),
                        Column(
                            children: [
                              // Hiring Date Field
                              TextFormField(
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );
            
                                  if (pickedDate != null && pickedDate != clientDate) {
                                    setState(() {
                                      clientDate = pickedDate;
                                      dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                    });
                                  }
                                },
                                controller: dateController,
                                readOnly: true,
                                style: TextInputDecorations.textStyle,
                          decoration: TextInputDecorations.customInputDecoration(labelText: 'Date'),
                                validator: (value) {
                                  if (clientDate == null) {
                                    return 'Date is required';
                                  }
                                  return null;
                                },
                              )
                            ],
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
                        SizedBox(height: 10.h),
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
            
                        SizedBox(height: 30.h),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Column(
                            children: [
                              if (selectedImage != null)
                                Container(
                                  width: 100.w,
                                  height: 100.h,
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
                                  fontSize: 15.sp,
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
            
                        SizedBox(height: 10.h),
            
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    print("submit pressed");
                                    if (_formKey.currentState!.validate()) {
                                        addClient();
                                    }
                                  },
                                  style: AppButtonStyles.submitButtonStyle,
                                  child: Text('Submit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30.sp,
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                      print("resetting...");
                                      resetForm();
                                  },
                                  style: AppButtonStyles.cancelButtonStyle,
                                  
                                  child: Text('Cancel',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30.sp,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Future<void> addClient() async {
    try {
      Map<String, dynamic> userData = {
        'fullName': name.text,
        'company': company.text,
        'email': mail.text,
        'phone': mobile.text,
        'hiringDate': dateController.text,
        'password': password.text,
      };
      await userService.addUser(userData);
    } catch (error) {
      print('Error adding client: $error');
    }
  }


  void resetForm() {
    setState(() {
      name.clear();
      company.clear();
      mail.clear();
      mobile.clear();
      clientDate = null;
      dateController.clear();
      password.clear();
      passwordconf.clear();
      selectedImage = null;
    });
  }
}
