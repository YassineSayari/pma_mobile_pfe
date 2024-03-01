import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
            content: Text('Employee updated successfully!',style:TextStyle(color: Colors.black45,fontWeight: FontWeight.w600),),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.yellowAccent,
          ),
        );
      } catch (error) {
        print('Error updating employee: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text("Edit Employee",style: TextStyle(fontFamily: AppTheme.fontName,fontWeight: FontWeight.w600,fontSize: 34),)),
                SizedBox(height: 30),
                TextFormField(
                  controller: nameController,
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 27,
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Name*',
                    labelStyle: TextStyle(
                      color: Color(0xFF7743DB),
                      fontSize: 25,
                      fontFamily:  AppTheme.fontName,
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid name';
                    }
                    return null;
                  },
                ),
            
                SizedBox(height: 15),
            
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
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 27,
                    fontFamily:  AppTheme.fontName,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Department*',
                    labelStyle: TextStyle(
                      color: Color(0xFF7743DB),
                      fontSize: 25,
                      fontFamily:  AppTheme.fontName,
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ),
            
                SizedBox(height: 15),
                TextFormField(
                  controller: roleController,
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 27,
                    fontFamily:  AppTheme.fontName,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Role*',
                    labelStyle: TextStyle(
                      color: Color(0xFF7743DB),
                      fontSize: 25,
                      fontFamily:  AppTheme.fontName,
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid role';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
            
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
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 27,
                    fontFamily:  AppTheme.fontName,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Gender*',
                    labelStyle: TextStyle(
                      color: Color(0xFF7743DB),
                      fontSize: 25,
                      fontFamily:  AppTheme.fontName,
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ),
            
                SizedBox(height: 15),
            
                TextFormField(
                  controller: mobileController,
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 27,
                    fontFamily:  AppTheme.fontName,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Mobile*',
                    labelStyle: TextStyle(
                      color: Color(0xFF7743DB),
                      fontSize: 25,
                      fontFamily:  AppTheme.fontName,
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid mobile';
                    }
                    return null;
                  },
                ),
            
                SizedBox(height: 15),
            
                TextFormField(
                  controller: emailController,
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 27,
                    fontFamily:  AppTheme.fontName,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email*',
                    labelStyle: TextStyle(
                      color: Color(0xFF7743DB),
                      fontSize: 25,
                      fontFamily:  AppTheme.fontName,
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
            
                SizedBox(height: 15),
            
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
                  decoration: InputDecoration(
                    labelText: 'Hiring Date*',
                    labelStyle: TextStyle(
                      color: Color(0xFF7743DB),
                      fontSize: 27,
                      fontFamily: AppTheme.fontName,
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.grey,
                      ),
                    ),
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
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          print("update pressed");
                          updateEmployee();
                        },
                        child: Text('Save',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25 ),),
                                   style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9F7BFF),
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25 ),),
                                   style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
