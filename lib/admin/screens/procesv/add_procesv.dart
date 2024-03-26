import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/models/user_model.dart';
import 'package:pma/services/procesv_service..dart';
import 'package:pma/services/project_service.dart';
import 'package:pma/services/shared_preferences.dart';
import 'package:pma/services/user_service.dart';
import 'package:pma/theme.dart';

class AddProcesv extends StatefulWidget {
  const AddProcesv({super.key});

  @override
  State<AddProcesv> createState() => _AddProcesvState();
}

class _AddProcesvState extends State<AddProcesv> {

    final _formKey = GlobalKey<FormState>();

    late Future<List<Map<String, dynamic>>> projects;
    late Future<List<User>> teamLeaders;

    String? projectid;
  final MultiSelectController executorController = MultiSelectController();
  List<User> selectedExecutors = [];

    DateTime? date;
    final TextEditingController dateController = TextEditingController();


    late String type_com='internal meeting';
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController= TextEditingController();


    final TextEditingController progressController= TextEditingController();

    DateTime? deadLine;
    final TextEditingController deadLineController = TextEditingController();

  final ProjectService projectService = GetIt.I<ProjectService>();
  final UserService userService = GetIt.I<UserService>();
  final ProcesVService procesvService = GetIt.I<ProcesVService>();
  final SharedPrefs prefs = GetIt.I<SharedPrefs>();


  @override
void initState() {
  super.initState();
  initializeData();
}

Future<void> initializeData() async {
  projects = projectService.getAllProjects();
  teamLeaders = UserService().getAllTeamLeaders();
  //print("sender::::: $sender");
  print("proejct id::::: $projectid");
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
                  style: AppTextFieldStyles.textStyle,
                        decoration: InputDecoration(
                          labelText: 'Title*',
                          labelStyle: AppTextFieldStyles.labelStyle,
                          enabledBorder: AppTextFieldStyles.enabledBorder,
                          focusedBorder: AppTextFieldStyles.focusedBorder,
                        ),
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
                                    style: AppTextFieldStyles.textStyle,
                                          decoration: InputDecoration(
                                            labelText: 'Project*',
                                            labelStyle: AppTextFieldStyles.labelStyle,
                                            enabledBorder: AppTextFieldStyles.enabledBorder,
                                            focusedBorder: AppTextFieldStyles.focusedBorder,
                                          ),

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
                          value: type_com,
                          style: AppTextFieldStyles.textStyle,
                                decoration: InputDecoration(
                                  labelText: 'Communication Type*',
                                  labelStyle: AppTextFieldStyles.labelStyle,
                                  enabledBorder: AppTextFieldStyles.enabledBorder,
                                  focusedBorder: AppTextFieldStyles.focusedBorder,
                                ),
                          items: [
                            DropdownMenuItem(child: Text('internal meeting',style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName),), value: 'internal meeting'),
                            DropdownMenuItem(child: Text('official meeting',style: TextStyle(fontSize: 20.sp,fontFamily:AppTheme.fontName),), value: 'official meeting'),
                            DropdownMenuItem(child: Text('client request',style: TextStyle(fontSize: 20.sp,fontFamily:AppTheme.fontName),), value: 'client request'),

                          ],
                          
                          onChanged: (selectedValue) {
                            setState(() {
                              type_com = selectedValue as String;
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
                  hint: "Present Members",
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
                            TextFormField(
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(Duration(days: 365 * 2)),
                                      );
                                      if (pickedDate != null && pickedDate != date) {
                                        setState(() {
                                          date = pickedDate;
                                          dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                        });
                                      }
                                    },
                                    controller: dateController,
                                    readOnly: true,
                                    style: AppTextFieldStyles.textStyle,
                                          decoration: InputDecoration(
                                            labelText: 'Date*',
                                            labelStyle: AppTextFieldStyles.labelStyle,
                                            enabledBorder: AppTextFieldStyles.enabledBorder,
                                            focusedBorder: AppTextFieldStyles.focusedBorder,
                                            prefixIcon: Icon(
                                                        Icons.calendar_today,
                                                        color: Colors.grey[400],
                                             ),
                                          ),
                                      
                                   
                                    validator: (value) {
                                      if (date == null) {
                                        return 'start date is required';
                                      }
                                      return null;
                                    },
                                  ),

                                  SizedBox(height: 10.h),
                                  TextFormField(
                                  controller: descriptionController,
                                  maxLines: 3,
                                    style: AppTextFieldStyles.textStyle,
                                          decoration: InputDecoration(
                                            labelText: 'Description',
                                            labelStyle: AppTextFieldStyles.labelStyle,
                                            enabledBorder: AppTextFieldStyles.enabledBorder,
                                            focusedBorder: AppTextFieldStyles.focusedBorder,
                                          ),
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
                                    _addProcesv();
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

   Future<void> _addProcesv() async {
        try {
    List<String> memberIds = selectedExecutors.map((user) => user.id).toList();
    print("equipe:::$memberIds");
    String? userId = await prefs.getLoggedUserIdFromPrefs();
    print("used id:::: $userId");
    User sender = await userService.getUserbyId(userId!);
    print("sender:::: ${sender.id} ::::  ${sender.fullName}");
          Map<String, dynamic> procesv = {
     
            'Titre' : titleController.text,
            'description': descriptionController.text,
            'Project': {'_id': projectid},
            'Type_Communication': type_com,
            'Sender':sender.toJson(),
            'equipe': memberIds,
            'Date' : DateFormat('yyyy-MM-dd').format(date!),
            };  
          
          await procesvService.addProcesv(procesv);

           ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
            content: SuccessSnackBar(message: "Proces Verbal updated !"),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          );
          Navigator.of(context).pushReplacementNamed('/procesv');
        }catch(error) {
        print('Error updating task: $error');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
            content: FailSnackBar(message: "failed to update Proces Verbal!"),
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