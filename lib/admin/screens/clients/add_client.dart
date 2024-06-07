
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pma/const.dart';
import 'package:pma/custom_appbar.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/services/shared_preferences.dart';
import 'package:pma/theme.dart';

import '../../../services/user_service.dart';
import '../../widgets/admin_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

class AddClient extends StatefulWidget {
  const AddClient({super.key});

  @override
  State<AddClient> createState() => _AddClientState();
}


class _AddClientState extends State<AddClient> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController company = TextEditingController();
   String? gender;

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

  Future<void> _handleAddUser() async {
     String? authToken = await SharedPrefs.getAuthToken();

    print("adding user");
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('$baseUrl/api/v1/users/adduser'), 
    
  );

  request.headers['Authorization'] = 'Bearer $authToken';
  print("token:::: ${request.headers}");
  request.fields['fullName'] = name.text;
  request.fields['email'] = mail.text;
  request.fields['password'] = password.text;
  request.fields['gender'] = gender!;
  request.fields['roles[]'] = "Client";
  request.fields['phone'] = mobile.text;
    request.fields['company'] = company.text;

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
        content: SuccessSnackBar(message: "Client added successfully"),
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
        content: FailSnackBar(message: "Failed to add client"),
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

      drawer: AdminDrawer(selectedRoute: '/addclient'),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          CustomAppBar(title: "Add Client"),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal:20.w,vertical: 8.h),
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
                                  onPressed: _handleAddUser,
                                  // onPressed: () {
                                  //   print("submit pressed");
                                  //   if (_formKey.currentState!.validate()) {
                                  //       addClient();
                                  //   }
                                  // },
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


  // Future<void> addClient() async {
  //   try {
  //     Map<String, dynamic> userData = {
  //       'fullName': name.text,
  //       'company': company.text,
  //       'email': mail.text,
  //       'phone': mobile.text,
  //       'hiringDate': dateController.text,
  //       'password': password.text,
  //     };
  //     await userService.addUser(userData);
  //   } catch (error) {
  //     print('Error adding client: $error');
  //   }
  // }


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
