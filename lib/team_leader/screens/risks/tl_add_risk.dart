import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/models/user_model.dart';
import 'package:pma/services/project_service.dart';
import 'package:pma/services/risk_service.dart';
import 'package:pma/services/shared_preferences.dart';
import 'package:pma/services/user_service.dart';
import 'package:pma/theme.dart';

class TlAddRisk extends StatefulWidget {
  const TlAddRisk({super.key});

  @override
  State<TlAddRisk> createState() => _TlAddRiskState();
}

class _TlAddRiskState extends State<TlAddRisk> {

    final _formKey = GlobalKey<FormState>();

    final TextEditingController titleController = TextEditingController();

    late Future<List<Map<String, dynamic>>> projects;
    String? projectid;

    late TextEditingController actionController= TextEditingController();
    late String impact;

    DateTime? creationDate;
    final TextEditingController creationDateController = TextEditingController();
    late TextEditingController detailsController= TextEditingController();

  final ProjectService projectService = GetIt.I<ProjectService>();
  final RiskService riskService=GetIt.I<RiskService>();
  final SharedPrefs prefs = GetIt.I<SharedPrefs>();
  final UserService userService=GetIt.I<UserService>();


      @override
  void initState() {
    super.initState();
    projects = projectService.getAllProjects();
    impact="High";
  }

    @override
  void dispose() {
    super.dispose();
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
                Center(child: Text("New Risk",style: TextStyle(fontFamily: AppTheme.fontName,fontWeight: FontWeight.w600,fontSize: 34.sp),)),
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
                          value: impact,
                          style: TextInputDecorations.textStyle,
                          decoration: TextInputDecorations.customInputDecoration(labelText: 'Impact'),
                          items: [
                            DropdownMenuItem(child: Text('High',style: TextStyle(fontSize:20,fontFamily:AppTheme.fontName),), value: 'High'),
                            DropdownMenuItem(child: Text('Medium',style: TextStyle(fontSize: 20,fontFamily:AppTheme.fontName),), value: 'Medium'),
                            DropdownMenuItem(child: Text('Low',style: TextStyle(fontSize: 20,fontFamily:AppTheme.fontName),), value: 'Low'),
                          ],
                          
                          onChanged: (selectedValue) {
                            setState(() {
                              impact = selectedValue as String;
                            });
                          },
                          validator: (value) {
                            if (value == null ) {
                              return 'impact is required';
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
                                      if (pickedDate != null && pickedDate != creationDate) {
                                        setState(() {
                                          creationDate = pickedDate;
                                          creationDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                        });
                                      }
                                    },
                                    controller: creationDateController,
                                    readOnly: true,    
                                    style: DateFieldsStyle.textStyle,
                                    decoration: InputDecoration(
                                    labelText: 'Creation Date*',
                                    labelStyle: DateFieldsStyle.labelStyle,
                                    enabledBorder: DateFieldsStyle.enabledBorder,
                                    focusedBorder: DateFieldsStyle.focusedBorder,
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                    validator: (value) {
                                      if (creationDate == null) {
                                        return 'Creation date is required';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 10.h),
                                  TextFormField(
                                  controller: detailsController,
                                  maxLines: 3,
                                  style: TextInputDecorations.textStyle,
                                  decoration: TextInputDecorations.customInputDecoration(labelText: 'Details'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter valid details';
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
                                   _addRisk();
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

   Future<void> _addRisk() async {
    final List<Map<String, dynamic>> projectsList = await projects;
    String? userId = await prefs.getLoggedUserIdFromPrefs();
    print("user id:::: $userId");
    User user = await userService.getUserbyId(userId!);
    print("user:::: ${user.id} ::::  ${user.fullName}");
        try {
          Map<String, dynamic> newRisk = {
                  'title' : titleController.text,
                  'action': actionController.text,
                  'date': creationDate?.toIso8601String(),
                  'project': projectsList
                  .firstWhere((project) => project['_id'] == projectid),
                  'impact' : impact,
                  'details': detailsController.text,
                  'user':userId,
                  
            
          };

          await riskService.addRisk(newRisk) ;
          Navigator.of(context).pushReplacementNamed('/tlrisks');
           ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
            content: SuccessSnackBar(message: "Risk added !"),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          );
          print("cbon::::");
        }catch(error) {
        print('Error adding risk: $error');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
            content: FailSnackBar(message: "failed to add risk!"),
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