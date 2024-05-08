import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/models/user_model.dart';
import 'package:pma/services/project_service.dart';
import 'package:pma/services/shared_preferences.dart';
import 'package:pma/services/task_service.dart';
import 'package:pma/services/user_service.dart';
import 'package:pma/theme.dart';

class TlAddTask extends StatefulWidget {
  const TlAddTask({super.key});

  @override
  State<TlAddTask> createState() => _TlAddTaskState();
}

class _TlAddTaskState extends State<TlAddTask> {

    final _formKey = GlobalKey<FormState>();

    late TextEditingController titleController= TextEditingController();
    late Future<List<Map<String, dynamic>>> projects;
    late Future<List<User>> teamLeaders;
    late Future<List<User>> engineers;

    String? projectid;
  final MultiSelectController executorController = MultiSelectController();
  List<User> selectedExecutors = [];


    late String priority="High";

    DateTime? startDate;
    final TextEditingController startDateController = TextEditingController();


    DateTime? deadLine;
    final TextEditingController deadLineController = TextEditingController();

    late TextEditingController descriptionController= TextEditingController();

  final ProjectService projectService = GetIt.I<ProjectService>();
  final TaskService taskService=GetIt.I<TaskService>();

  @override
  void initState() {
    super.initState();
      _loadUserInfo().then((_) {
    projects = projectService.getProjectsByTeamLeader(userId!);
});
    teamLeaders=UserService().getAllTeamLeaders();
    engineers=UserService().getAllEngineers();

  }
     final SharedPrefs sharedPrefs = GetIt.instance<SharedPrefs>();
  late Map<String, String> userInfo = {};
  late String? userId = " ";
    Future<void> _loadUserInfo() async {
    try {
      final data = await SharedPrefs.getUserInfo();
      setState(() {
        userInfo = data;
        userId = data["userId"];
        print("user loaded::::::: id $userId");
      });
    } catch (error) {
      print("error loading user");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0.r),
        
      ),
            insetPadding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 28.h),

      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text("Add",style: TextStyle(fontFamily: AppTheme.fontName,fontWeight: FontWeight.w600,fontSize: 34.sp),)),
                SizedBox(height: 30.h),
                TextFormField(
                  controller: titleController,
                  style: TextInputDecorations.textStyle,
                  decoration: TextInputDecorations.customInputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.h),
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future: projects,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return SpinKitThreeBounce(color: Colors.blueAccent,size: 30,);
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return Text('No projects available.');
                                } else {
                                  print('Projects:: $projects');
                                  return DropdownButtonFormField(
                                    value: projectid,
                                    style: TextInputDecorations.textStyle,
                                    decoration: TextInputDecorations.customInputDecoration(labelText: 'Project'),

                                    items: snapshot.data!.map<DropdownMenuItem<String>>((Map<String, dynamic> project) {
                                      return DropdownMenuItem<String>(
                                        value: project['_id'],
                                        child: Text(project['Projectname'], style: TextStyle(fontSize: 20.sp, fontFamily: AppTheme.fontName)),
                                      );
                                    }).toList(),

                                    onChanged: (selectedValue) {
                                      setState(() {
                                        projectid = selectedValue as String?;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Project is required';
                                      }
                                      return null;
                                    },
                                    
                                  );
                                }
                              },
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
                                  return Text('No engineers available.');
                                } else {
                                      
                                  // padding + (length * height per option)
                                  double dropdownHeight = 50.0 + (snapshot.data!.length * 50.0);
                                  return MultiSelectDropDown(
                                    borderColor:Colors.grey, 
                                    borderWidth: 3,
                                    focusedBorderWidth: 3,
                                    
                                    controller: executorController,
                                    onOptionSelected: (options) {
                                      setState(() {
                                        selectedExecutors = options
                                            .map((valueItem) => snapshot.data!
                                            .firstWhere((user) => user.fullName == valueItem.label))
                                            .toList();
                                      });
                                    },
                                    options: snapshot.data!
                                        .map((user) => ValueItem(label: user.fullName, value: user.id.toString()))
                                        .toList(),
                                    maxItems: 11,
                  hint: "Executor",
                  hintStyle: AppTheme.multiSelectDropDownTextStyle,
                  hintFontSize: 20,
                  selectionType: SelectionType.multi,
                  chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                  dropdownHeight: dropdownHeight,
                  optionTextStyle: AppTheme.multiSelectDropDownTextStyle,
                  selectedOptionIcon: const Icon(Icons.check_circle),
                                    
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                   SizedBox(height: 10.h),

                   DropdownButtonFormField(
                          value: priority,
                          style: TextInputDecorations.textStyle,
                          decoration: TextInputDecorations.customInputDecoration(labelText: 'Priority'),
                          items: [
                            DropdownMenuItem(child: Text('High',style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName),), value: 'High'),
                            DropdownMenuItem(child: Text('Medium',style: TextStyle(fontSize: 20.sp,fontFamily:AppTheme.fontName),), value: 'Medium'),
                            DropdownMenuItem(child: Text('Low',style: TextStyle(fontSize: 20.sp,fontFamily:AppTheme.fontName),), value: 'Low'),

                          ],
                          
                          onChanged: (selectedValue) {
                            setState(() {
                              priority = selectedValue as String;
                            });
                          },
                          validator: (value) {
                            if (value == null ) {
                              return 'priority is required';
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
                                        lastDate: DateTime.now().add(Duration(days: 365 * 2)),
                                      );
                                      if (pickedDate != null && pickedDate != startDate) {
                                        setState(() {
                                          startDate = pickedDate;
                                          startDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                        });
                                      }
                                    },
                                    controller: startDateController,
                                    readOnly: true,
                                    style: DateFieldsStyle.textStyle,
                                    decoration: InputDecoration(
                                    labelText: 'Start Date*',
                                    labelStyle: DateFieldsStyle.labelStyle,
                                    enabledBorder: DateFieldsStyle.enabledBorder,
                                    focusedBorder: DateFieldsStyle.focusedBorder,
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                   
                                    validator: (value) {
                                      if (startDate == null) {
                                        return 'start date is required';
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
                                        lastDate: DateTime.now().add(Duration(days: 365 * 2)),
                                      );
                                      if (pickedDate != null && pickedDate != deadLine) {
                                        setState(() {
                                          deadLine = pickedDate;
                                          deadLineController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                        });
                                      }
                                    },
                                    controller: deadLineController,
                                    readOnly: true,
                                    style: DateFieldsStyle.textStyle,
                                    decoration: InputDecoration(
                                    labelText: 'Deadline*',
                                    labelStyle: DateFieldsStyle.labelStyle,
                                    enabledBorder: DateFieldsStyle.enabledBorder,
                                    focusedBorder: DateFieldsStyle.focusedBorder,
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                   
                                    validator: (value) {
                                      if (deadLine == null) {
                                        return 'deadline is required';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 10.h),
                                  TextFormField(
                                  controller: descriptionController,
                                  maxLines: 3,
                                  style: TextInputDecorations.textStyle,
                                  decoration: TextInputDecorations.customInputDecoration(labelText: 'Description'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a valid description';
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
                                    if (_formKey.currentState!.validate()) {
                                      _addTask();
                                      Navigator.of(context).pushReplacementNamed('/reclamations');
                                    }
                                  },
                               
                                             child: Text("Save",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25.sp,fontFamily:AppTheme.fontName),),
                                             style: AppButtonStyles.submitButtonStyle
                                              ),
                              ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: (){
                                Navigator.of(context).pop();
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
      ),
    );
  }

   Future<void> _addTask() async {


        try {
              Map<String, dynamic> newTask= {
      'Title': titleController.text,
      'Project': {'_id': projectid},
      'Details': descriptionController.text,
      'Executor': selectedExecutors.map((user) => {'_id': user.id}).toList(),
      'StartDate': startDateController.text,
      'Deadline': deadLineController.text,
      'Priority': priority,
    };


          await taskService.addTask(newTask) ;
          Navigator.of(context).pushReplacementNamed('/tlalltasks');
           ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
            content: SuccessSnackBar(message: "task added !"),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          );
          print("cbon::::");
        }catch(error) {
        print('Error adding task: $error');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
            content: FailSnackBar(message: "failed to add task!"),
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
