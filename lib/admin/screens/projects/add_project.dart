import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:pma/custom_appbar.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/models/user_model.dart';
import 'package:pma/services/project_service.dart';
import 'package:pma/theme.dart';
import '../../../services/user_service.dart';
import '../../widgets/admin_drawer.dart';
class AddProject extends StatefulWidget {
  const AddProject({super.key});

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController title = TextEditingController();

  String? projectType;
  String? projectPriority;

  String? client;
  DateTime? projectStartDate;
  final TextEditingController projectStartDateController = TextEditingController();

  DateTime? projectEndDate;
  final TextEditingController projectEndDateController = TextEditingController();

  String? team;
  final MultiSelectController teamController = MultiSelectController();

  String? teamLeader;

  List<User> selectedEngineers = [];

  final TextEditingController description = TextEditingController();

  late Future<List<User>> clients;
  late Future<List<User>> engineers; 
  late Future<List<User>> teamLeaders;

  final UserService userService = GetIt.I<UserService>();
  final ProjectService projectService = GetIt.I<ProjectService>();

  @override
  void initState() {
    super.initState();
    clients = userService.getAllClients();
    engineers = userService.getAllEngineers();
    teamLeaders = userService.getAllTeamLeaders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: AdminDrawer(selectedRoute: '/addproject'),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          CustomAppBar(title: "Add Project"),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Project Title
                        TextFormField(
                          controller: title,
                          keyboardType: TextInputType.text,
                                           style: AppTextFieldStyles.textStyle,
                                                decoration: InputDecoration(
                                                  labelText: 'Project Title*',
                                                  labelStyle: AppTextFieldStyles.labelStyle,
                                                  enabledBorder: AppTextFieldStyles.enabledBorder,
                                                  focusedBorder: AppTextFieldStyles.focusedBorder,
                                                ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Project title is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.h),
                
                        // Project Type and Priority
                        DropdownButtonFormField(
                          value: projectType,
                                          style: AppTextFieldStyles.textStyle,
                                          isExpanded: true,
                                                decoration: InputDecoration(
                                                  labelText: 'Project Type*',
                                                  labelStyle: AppTextFieldStyles.labelStyle,
                                                  enabledBorder: AppTextFieldStyles.enabledBorder,
                                                  focusedBorder: AppTextFieldStyles.focusedBorder,
                                                ),
                          items: [
                            DropdownMenuItem(child: Text('-Systems Infrastructure',style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName),), value: 'Systems Infrastructure'),
                            DropdownMenuItem(child: Text('-Network Infrastructure',style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName),), value: 'Network Infrastructure'),
                            DropdownMenuItem(child: Text('-Systems And Networks Infrastructure',style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName),), value: 'Systems And Networks Infrastructure'),
                            DropdownMenuItem(child: Text('-Development',style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName),), value: 'Development'),
                          ],
                          onChanged: (selectedValue) {
                            setState(() {
                              projectType = selectedValue as String?;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Project Type is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.h),
                        
                        DropdownButtonFormField(
                          value: projectPriority,
                                          style: AppTextFieldStyles.textStyle,
                                                decoration: InputDecoration(
                                                  labelText: 'Project priority*',
                                                  labelStyle: AppTextFieldStyles.labelStyle,
                                                  enabledBorder: AppTextFieldStyles.enabledBorder,
                                                  focusedBorder: AppTextFieldStyles.focusedBorder,
                                                ),
                          items: [
                            DropdownMenuItem(child: Text('Low',style:TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName),), value: 'Low'),
                            DropdownMenuItem(child: Text('Medium',style:TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName),), value: 'Medium'),
                            DropdownMenuItem(child: Text('High',style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName),), value: 'High'),
                          ],
                          onChanged: (selectedValue) {
                            setState(() {
                              projectPriority = selectedValue as String?;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Project Priority is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.h),
                
                        // Client Dropdown
                        FutureBuilder<List<User>>(
                          future: clients,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Text('No clients available.');
                            } else {
                              return DropdownButtonFormField(
                                value: client,
                                          style: AppTextFieldStyles.textStyle,
                                                decoration: InputDecoration(
                                                  labelText: 'Client*',
                                                  labelStyle: AppTextFieldStyles.labelStyle,
                                                  enabledBorder: AppTextFieldStyles.enabledBorder,
                                                  focusedBorder: AppTextFieldStyles.focusedBorder,
                                                ),
                                items: snapshot.data!.map<DropdownMenuItem<String>>((User user) {
                                  return DropdownMenuItem<String>(
                                    value: user.id.toString(),
                                    child: Text(user.fullName,style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName),),
                                  );
                                }).toList(),
                                onChanged: (selectedValue) {
                                  setState(() {
                                    client = selectedValue as String?;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Client is required';
                                  }
                                  return null;
                                },
                              );
                            }
                          },
                        ),
                        SizedBox(height: 10.h),
                
                        // Project Dates
                        Column(
                          children: [
                            // Project Start Date
                            TextFormField(
                              onTap: () async {
                                
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null && pickedDate != projectStartDate) {
                                  setState(() {
                                    projectStartDate = pickedDate;
                                    projectStartDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                  });
                                }
                              },
                              controller: projectStartDateController,
                              readOnly: true,
                                          style: AppTextFieldStyles.textStyle,
                                                decoration: InputDecoration(
                                                  labelText: 'Start Date*',
                                                  labelStyle: AppTextFieldStyles.labelStyle,
                                                  enabledBorder: AppTextFieldStyles.enabledBorder,
                                                  focusedBorder: AppTextFieldStyles.focusedBorder,
                                                
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey[400],
                                ),
                              ),
                              validator: (value) {
                                if (projectStartDate == null) {
                                  return 'Project Start Date is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Column(
                          children: [
                            // Project End Date
                            TextFormField(
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2025),
                                );
                                if (pickedDate != null && pickedDate != projectEndDate) {
                                  setState(() {
                                    projectEndDate = pickedDate;
                                    projectEndDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                  });
                                }
                              },
                              controller: projectEndDateController,
                              readOnly: true,
                                          style: AppTextFieldStyles.textStyle,
                                                decoration: InputDecoration(
                                                  labelText: 'Client*',
                                                  labelStyle: AppTextFieldStyles.labelStyle,
                                                  enabledBorder: AppTextFieldStyles.enabledBorder,
                                                  focusedBorder: AppTextFieldStyles.focusedBorder,
                                                
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey[400],
                                ),
                              ),
                              validator: (value) {
                                if (projectEndDate == null) {
                                  return 'Project End Date is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                
                        Column(
                          children: [
                            FutureBuilder<List<User>>(
                              future: engineers,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return Text('No engineers available.');
                                } else {
                                      
                                  // padding + (length * height per option)
                                  double dropdownHeight = 50.0 + (snapshot.data!.length * 50.0);
                                  return MultiSelectDropDown(
                                    borderColor:Colors.grey, 
                                    borderWidth: 3,
                                    focusedBorderWidth: 3,
                                    
                                    controller: teamController,
                                    onOptionSelected: (options) {
                                      setState(() {
                                        selectedEngineers = options
                                            .map((valueItem) => snapshot.data!
                                            .firstWhere((user) => user.fullName == valueItem.label))
                                            .toList();
                                      });
                                    },
                                    options: snapshot.data!
                                        .map((user) => ValueItem(label: user.fullName, value: user.id.toString()))
                                        .toList(),
                                    maxItems: 11,
                  hint: "Select Team",
                  hintStyle: AppTheme.multiSelectDropDownTextStyle,
                  hintFontSize: 20,
                  selectionType: SelectionType.multi,
                  chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                  dropdownHeight: dropdownHeight,
                  optionTextStyle: AppTheme.multiSelectDropDownTextStyle,
                  selectedOptionIcon: const Icon(Icons.check_circle),
                  // border: AppTheme.multiSelectDropDownEnabledBorder,
                  // focusedBorder: AppTheme.multiSelectDropDownFocusedBorder,
                                    
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Column(
                          children: [
                            FutureBuilder<List<User>>(
                              future: teamLeaders,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return Text('No team leaders available.');
                                } else {
                                  print('team leaders: $teamLeaders');
                                  return DropdownButtonFormField(
                                    value: teamLeader,
                                          style: AppTextFieldStyles.textStyle,
                                                decoration: InputDecoration(
                                                  labelText: 'Team Leader*',
                                                  labelStyle: AppTextFieldStyles.labelStyle,
                                                  enabledBorder: AppTextFieldStyles.enabledBorder,
                                                  focusedBorder: AppTextFieldStyles.focusedBorder,
                                                ),
                                    items: snapshot.data!.map<DropdownMenuItem<String>>((User user) {
                                      return DropdownMenuItem<String>(
                                        value: user.id.toString(),
                                        child: Text(user.fullName,style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName),),
                                      );
                                    }).toList(),
                                    onChanged: (selectedValue) {
                                      setState(() {
                                        teamLeader = selectedValue as String?;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Team Leader is required';
                                      }
                                      return null;
                                    },
                                    
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        TextFormField(
                                controller: description,
                                keyboardType: TextInputType.text,
                                maxLines: 3,
                                style: AppTextFieldStyles.textStyle,
                                                decoration: InputDecoration(
                                                  labelText: 'Description*',
                                                  labelStyle: AppTextFieldStyles.labelStyle,
                                                  enabledBorder: AppTextFieldStyles.enabledBorder,
                                                  focusedBorder: AppTextFieldStyles.focusedBorder,
                                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Description is required';
                                  }
                                  return null;
                                },
                              ),
                
                        SizedBox(height: 10.h),
                
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  print("add project button pressed");
                                  addProject();
                                },
                                style: AppButtonStyles.submitButtonStyle,
                                
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  resetForm();
                                },
                                style: AppButtonStyles.cancelButtonStyle,
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addProject() async {
    try {
      if (!_formKey.currentState!.validate()) {
        print("Invalid information");
      }
      print("team leader: $teamLeader , client : $client");

      List<String> equipe = selectedEngineers.map((user) => user.id).toList();

      Map<String, dynamic> projectData = {
        'Projectname': title.text,
        'description':description.text,
        'TeamLeader': teamLeader,
        'type': projectType,
        'equipe': jsonEncode(equipe),
        'client': client,
        'dateFin': projectEndDate?.toIso8601String(),
        'dateDebut': projectStartDate?.toIso8601String(),
        'priority':projectPriority,
        'status':'Pending',
      };
        print("preparing project data $projectData");
      // Extract team members' IDs

      print("equipe: $equipe");

      print("prepared project data");


      print("calling add project method from service");
      await projectService.addProject(projectData);
      Navigator.of(context).pushReplacementNamed('/allprojects');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: SuccessSnackBar(message: "Project added successfully!"),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      );

      resetForm();
    } catch (error) {

      //Navigator.of(context).pushReplacementNamed('/allprojects');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: FailSnackBar(message: "Failed to add project. Please try again!"),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }


  void resetForm() {
    setState(() {
      title.clear();
      description.clear();
      projectPriority = null;
      projectStartDate = null;
      projectEndDate = null;
      team = null;
      teamLeader = null;
      client=null;
      projectType = null;
    });
  }
}
