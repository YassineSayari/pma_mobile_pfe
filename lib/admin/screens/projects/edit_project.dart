import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:pma/custom_appbar.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/models/user_model.dart';
import 'package:pma/services/user_service.dart';

 import 'package:pma/services/project_service.dart';
import 'package:pma/theme.dart';

class EditProject extends StatefulWidget {
  final String projectId;
  final String projectTitle;
  final String description;
  final String type;
  final String status;
  final String priority;
  final String dateFin;
  final String teamLeaderId;
  final List<dynamic> equipe;

  const EditProject({
    Key? key,
    required this.projectId,
    required this.projectTitle,
    required this.description,
    required this.type,
    required this.status,
    required this.priority,
    required this.dateFin,
     required this.teamLeaderId,
      required this.equipe,
  }) : super(key: key);

  @override
  State<EditProject> createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {

    final _formKey = GlobalKey<FormState>();
  final TextEditingController title = TextEditingController();

  String? projectStatus;
  String? projectType;

  String? projectPriority;
  
  DateTime? projectEndDate;
  final TextEditingController projectEndDateController = TextEditingController();

  String? team;
  final MultiSelectController teamController = MultiSelectController();
  late Future<List<User>> engineers; 
  List<User> selectedEngineers = [];
  

  String? teamLeader;
   late Future<List<User>> teamLeaders;
  final UserService userService = GetIt.I<UserService>();
  final ProjectService projectService = GetIt.I<ProjectService>();


  final TextEditingController description = TextEditingController();



    Future<void> _updateProject() async {
        print("equipe::::::${widget.equipe}");
              List<String> equipe = selectedEngineers.map((user) => user.id).toList();

    try {
      Map<String, dynamic> updatedProjectData = {
        'Projectname': title.text,
        'status': projectStatus,
        'description': description.text,
        'type': projectType,
        'priority': projectPriority,
        'dateFin': DateFormat('yyyy-MM-dd').format(projectEndDate!),
        'teamLeaderId': teamLeader,
        'equipe': jsonEncode(equipe),
      };

      await projectService.updateProject(widget.projectId, updatedProjectData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:SuccessSnackBar(message: "Project Updated successfully!"),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
         backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      );
    } catch (error) {
            ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: FailSnackBar(message: "Failed to update project, please try again"),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      );
      print("Error updating project: $error");
    }
  }



  @override
  void initState() {
    super.initState();
      teamLeaders = userService.getAllTeamLeaders();
      engineers = userService.getAllEngineers();


      
    title.text = widget.projectTitle;
    projectStatus= widget.status;
    description.text=widget.description;
    projectType = widget.type;
    projectPriority = widget.priority;
    projectEndDate = DateTime.parse(widget.dateFin);
    projectEndDateController.text = DateFormat('yyyy-MM-dd').format(projectEndDate!);
  
    teamLeader!=widget.teamLeaderId;
    

    selectedEngineers = widget.equipe.map((engineerData) {

      return User(
        id: engineerData['_id'],
        fullName: engineerData['fullName'],
         phone:engineerData['phone'] ,
          email: engineerData['email'], 
          roles:List<String>.from(engineerData['roles']), 
          gender: engineerData['gender'], 
          isEnabled: true,
           experience: 0, 
           title:engineerData['title'],
            hiringDate: DateTime.parse( engineerData['hiringDate']),
      );
    }).toList();


    print("team ::::${widget.equipe}");

  }



@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        CustomAppBar(title: "Edit Project"),
        Expanded(
          child: ListView(
            children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
                child: Form(
                        key: _formKey,
          
                  child:Column(
                    children: [
                        TextFormField(
                          controller: title,
                          keyboardType: TextInputType.text,
                          style: TextInputDecorations.textStyle,
                          decoration: TextInputDecorations.customInputDecoration(labelText: 'Project Title'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Project title is required';
                            }
                            return null;
                          },
                        ),
                         SizedBox(height: 10.h),
                        
                        DropdownButtonFormField(
                          value: projectStatus,
                          style: TextInputDecorations.textStyle,
                          decoration: TextInputDecorations.customInputDecoration(labelText: 'Status'),
                          items: [
                            DropdownMenuItem(child: Text('Pending',style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName),), value: 'Pending'),
                            DropdownMenuItem(child: Text('In Progress',style: TextStyle(fontSize: 20.sp,fontFamily:AppTheme.fontName),), value: 'In Progress'),
                            DropdownMenuItem(child: Text('On Hold',style: TextStyle(fontSize: 20.sp,fontFamily:AppTheme.fontName),), value: 'On Hold'),
                            DropdownMenuItem(child: Text('Completed',style: TextStyle(fontSize: 20.sp,fontFamily:AppTheme.fontName),), value: 'Completed'),
                          ],
                          onChanged: (selectedValue) {
                            setState(() {
                              projectStatus = selectedValue as String?;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Status is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.h),
                        // Project Type and Priority
                        DropdownButtonFormField(
                          value: projectType,
                          isExpanded: true,
                          style: TextInputDecorations.textStyle,
                          decoration: TextInputDecorations.customInputDecoration(labelText: 'Type'),
                          items: [
                            DropdownMenuItem(child: Text('-Systems Infrastructure',style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName),), value: 'Systems Infrastructure'),
                            DropdownMenuItem(child: Text('-Network Infrastructure',style: TextStyle(fontSize: 20.sp,fontFamily:AppTheme.fontName),), value: 'Network Infrastructure'),
                            DropdownMenuItem(child: Flexible(child: Text('-Systems And Networks Infrastructure',style: TextStyle(fontSize: 20.sp,fontFamily:AppTheme.fontName),)), value: 'Systems And Networks Infrastructure'),
                            DropdownMenuItem(child: Text('-Development',style: TextStyle(fontSize: 20.sp,fontFamily:AppTheme.fontName),), value: 'Development'),
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
                          style: TextInputDecorations.textStyle,
                          decoration: TextInputDecorations.customInputDecoration(labelText: 'Priority'),
                          items: [
                            DropdownMenuItem(child: Text('Low',style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName),), value: 'Low'),
                            DropdownMenuItem(child: Text('Medium',style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName),), value: 'Medium'),
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
                                    style: DateFieldsStyle.textStyle,
                                    decoration: InputDecoration(
                                    labelText: 'End Date*',
                                    labelStyle: DateFieldsStyle.labelStyle,
                                    enabledBorder: DateFieldsStyle.enabledBorder,
                                    focusedBorder: DateFieldsStyle.focusedBorder,
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
                                  SizedBox(height: 10),
                            FutureBuilder<List<User>>(
                              future: teamLeaders,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return SpinKitThreeBounce(color: Colors.blueAccent,size: 30,);
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return Text('No team leaders available.');
                                } else {
                                  print('team leaders: $teamLeaders');
                                  return DropdownButtonFormField(
                                    value: teamLeader,
                                    style: TextInputDecorations.textStyle,
                                    decoration: TextInputDecorations.customInputDecoration(labelText: 'Team Leader'),
                                    items: snapshot.data!.map<DropdownMenuItem<String>>((User user) {
                                      return DropdownMenuItem<String>(
                                        value: user.id.toString(),
                                        child: Text(user.fullName,style: TextStyle(fontSize:20,fontFamily:AppTheme.fontName),),
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
                            SizedBox(height: 10.h),
                                                  FutureBuilder<List<User>>(
                              future: engineers,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return SpinKitThreeBounce(color: Colors.blueAccent,size: 30);
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
                                    hintStyle: TextStyle(fontSize:25,fontFamily:AppTheme.fontName),
                                    hintFontSize: 25,
                                    //disabledOptions: const [ValueItem(label: 'Option 1', value: '1')],
                                    selectionType: SelectionType.multi,
                                    chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                                    dropdownHeight: dropdownHeight,
                                    optionTextStyle: const TextStyle(fontSize: 25,fontFamily:AppTheme.fontName),
                                    selectedOptionIcon: const Icon(Icons.check_circle),
                                    
                                  );
                                }
                              },
                            ),
                            SizedBox(height: 10),
          
                          TextFormField(
                          controller: description,
                          keyboardType: TextInputType.text,
                          maxLines: 3,
                          style: TextInputDecorations.textStyle,
                          decoration: TextInputDecorations.customInputDecoration(labelText: 'Description'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Description is required';
                            }
                            return null;
                          },
                        ),
                         SizedBox(height: 10.h),
          
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: (){
                                    _updateProject();
                                        Navigator.of(context).pushReplacementNamed('/allprojects');
                                  },
                                             child: Text("Save",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25.sp,fontFamily:AppTheme.fontName),),
                                             style: AppButtonStyles.submitButtonStyle
                                              ),
                              ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: (){
                                Navigator.of(context).pushReplacementNamed('/allprojects');
                              },
                                         child: Text("Cancel",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25.sp,fontFamily:AppTheme.fontName),),
                                         style: AppButtonStyles.cancelButtonStyle
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
}