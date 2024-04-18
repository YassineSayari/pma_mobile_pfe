import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/models/task_model.dart';
import 'package:pma/models/user_model.dart';
import 'package:pma/services/project_service.dart';
import 'package:pma/services/task_service.dart';
import 'package:pma/services/user_service.dart';
import 'package:pma/theme.dart';

class EngineerEditTaskPopup extends StatefulWidget {
  final Task task;
  const EngineerEditTaskPopup({super.key, required this.task});

  @override
  State<EngineerEditTaskPopup> createState() => _EngineerEditTaskPopupState();
}

class _EngineerEditTaskPopupState extends State<EngineerEditTaskPopup> {

    final _formKey = GlobalKey<FormState>();

    late TextEditingController titleController;
    late Future<List<Map<String, dynamic>>> projects;
    late Future<List<User>> teamLeaders;
    late Future<List<User>> engineers;

    String? projectid;
  final MultiSelectController executorController = MultiSelectController();
  List<User> selectedExecutors = [];


    late String taskStatus;
    late int? taskProgress;
    late String priority;

    DateTime? startDate;
    final TextEditingController startDateController = TextEditingController();

    final TextEditingController progressController= TextEditingController();

    DateTime? deadLine;
    final TextEditingController deadLineController = TextEditingController();

    late TextEditingController descriptionController;

  final ProjectService projectService = GetIt.I<ProjectService>();
  final TaskService taskService = GetIt.I<TaskService>();

      @override
  void initState() {
    super.initState();
    projects = projectService.getAllProjects();
    teamLeaders=UserService().getAllTeamLeaders();
    engineers=UserService().getAllEngineers();

    titleController = TextEditingController(text: widget.task.title);
    descriptionController= TextEditingController(text: widget.task.details);
    projectid = widget.task.project["_id"];
    taskStatus= widget.task.status;
    priority=widget.task.priority;
    taskProgress=widget.task.progress;
    startDate = DateTime.parse(widget.task.startDate);
    startDateController.text = DateFormat('yyyy-MM-dd').format(startDate!);

    deadLine = DateTime.parse(widget.task.startDate);
    deadLineController.text = DateFormat('yyyy-MM-dd').format(deadLine!);

    print("proejct id::::: $projectid");
    //print("client id::::: $clientid");
    

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
                        
                        DropdownButtonFormField(
                          value: taskStatus,
                          style: TextInputDecorations.textStyle,
                          decoration: TextInputDecorations.customInputDecoration(labelText: 'Status'),
                          items: [
                            DropdownMenuItem(child: Text('Pending',style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName),), value: 'Pending'),
                            DropdownMenuItem(child: Text('Closed',style: TextStyle(fontSize: 20.sp,fontFamily:AppTheme.fontName),), value: 'Closed'),
                          ],
                          
                          onChanged: (selectedValue) {
                            setState(() {
                              taskStatus = selectedValue as String;
                            });
                          },
                          validator: (value) {
                            if (value == null ) {
                              return 'Status is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.h),

                        Text("Progress*",style: TextStyle(fontFamily:AppTheme.fontName,fontSize: 20.sp,fontWeight: FontWeight.w500),),
                        VerticalNumberPicker(
                  initialValue: taskProgress ?? 0,
                  minValue: 0,
                  maxValue: 100,
                  onChanged: (value) {
                    setState(() {
                      taskProgress = value;
                    });
                  },
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
                                      if (pickedDate != null && pickedDate != deadLine) {
                                        setState(() {
                                          deadLine = pickedDate;
                                          deadLineController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                        });
                                      }
                                    },
                                    controller: startDateController,
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
                                      if (startDate == null) {
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
                                  onPressed: (){
                                    _updateTask();
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

   Future<void> _updateTask() async {
        try {
    List<String> executorIds = selectedExecutors.map((user) => user.id).toList();
    if (executorIds.isEmpty) {
  executorIds = (widget.task.executor as List< dynamic>)
      .map((user) => user['_id'].toString())  // Assuming '_id' is the key for the user id
      .toList();
}
    print("executors:::$executorIds");

          Task updatedTask= Task(
            id: widget.task.id,
            title: titleController.text,
            project: {'_id': projectid},
            status:taskStatus,
            details: descriptionController.text,
            startDate: DateFormat('yyyy-MM-dd').format(startDate!),
            deadLine: DateFormat('yyyy-MM-dd').format(deadLine!),
            priority: priority,
            progress: taskProgress,
            executor: executorIds,
            
          );
          await taskService.updateTask(widget.task.id,updatedTask);

           ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
            content: SuccessSnackBar(message: "Task updated !"),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          );
          Navigator.of(context).pushReplacementNamed('/engineer_tasks');
        }catch(error) {
        print('Error updating task: $error');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
            content: FailSnackBar(message: "failed to update task!"),
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

class VerticalNumberPicker extends StatefulWidget {
  final int initialValue;
  final int minValue;
  final int maxValue;
  final Function(int) onChanged;

  VerticalNumberPicker({
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
  });

  @override
  _VerticalNumberPickerState createState() => _VerticalNumberPickerState();
}

class _VerticalNumberPickerState extends State<VerticalNumberPicker> {
  late int selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      child: ListWheelScrollView(
        itemExtent: 40,
        diameterRatio: 1.5,
        //useMagnifier: true,
       // magnification:1.5,
        physics: FixedExtentScrollPhysics(),
        children: List.generate(
          widget.maxValue - widget.minValue + 1,
          (index) => Center(
            child: Text(
              (widget.minValue + index).toString(),
              style: TextStyle(fontSize: 20.sp,fontFamily: AppTheme.fontName),
            ),
          ),
        ),
        onSelectedItemChanged: (index) {
          setState(() {
            selectedValue = widget.minValue + index;
            widget.onChanged(selectedValue);
          });
        },
        controller: FixedExtentScrollController(
          initialItem: widget.initialValue - widget.minValue,
        ),
      ),
    );
  }
}