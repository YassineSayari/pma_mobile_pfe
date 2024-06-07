import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/models/risk_model.dart';
import 'package:pma/services/project_service.dart';
import 'package:pma/services/risk_service.dart';
import 'package:pma/theme.dart';

class TlEditRiskPopup extends StatefulWidget {
  final Risk risk;
  const TlEditRiskPopup({super.key, required this.risk});

  @override
  State<TlEditRiskPopup> createState() => _TlEditRiskPopupState();
}

class _TlEditRiskPopupState extends State<TlEditRiskPopup> {

    final _formKey = GlobalKey<FormState>();

    late TextEditingController titleController;
    late TextEditingController actionController;
    late Future<List<Map<String, dynamic>>> projects;


    String? projectid;



    late String riskImpact;
    late String priority;

    DateTime? date;
    final TextEditingController dateController= TextEditingController();


    late TextEditingController descriptionController;

  final ProjectService projectService = GetIt.I<ProjectService>();
  final RiskService riskService = GetIt.I<RiskService>();

      @override
  void initState() {
    super.initState();
    projects = projectService.getAllProjects();
    riskImpact=widget.risk.impact;
    titleController = TextEditingController(text: widget.risk.title);
    actionController= TextEditingController(text: widget.risk.action);
    descriptionController= TextEditingController(text: widget.risk.details);
    projectid = widget.risk.project["_id"];
    date = DateTime.parse(widget.risk.date);
    dateController.text = DateFormat('yyyy-MM-dd').format(date!);

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
        padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
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
                        TextFormField(
                  controller: actionController,
                  style: TextInputDecorations.textStyle,
                  decoration: TextInputDecorations.customInputDecoration(labelText: 'Action'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid action';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.h),

                        DropdownButtonFormField(
                          value: riskImpact,
                          style: TextInputDecorations.textStyle,
                          decoration: TextInputDecorations.customInputDecoration(labelText: 'Status'),
                          items: [
                            DropdownMenuItem(child: Text('High',style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName),), value: 'High'),
                            DropdownMenuItem(child: Text('Medium',style: TextStyle(fontSize: 20.sp,fontFamily:AppTheme.fontName),), value: 'Medium'),
                            DropdownMenuItem(child: Text('Low',style: TextStyle(fontSize: 20.sp,fontFamily:AppTheme.fontName),), value: 'Low'),
                          ],
                          
                          onChanged: (selectedValue) {
                            setState(() {
                              riskImpact = selectedValue as String;
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
                                    style: DateFieldsStyle.textStyle,
                              decoration: InputDecoration(
                              labelText: 'Date*',
                              labelStyle: DateFieldsStyle.labelStyle,
                              enabledBorder: DateFieldsStyle.enabledBorder,
                              focusedBorder: DateFieldsStyle.focusedBorder,
                              prefixIcon: Icon(
                                Icons.calendar_today,
                                color: Colors.grey[400],
                              ),
                            ),
                                    validator: (value) {
                                      if (date == null) {
                                        return 'date is required';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 10.h),
                            
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
                                    _updateRisk();
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

Future<void> _updateRisk() async {
 try {
    final updatedRisk = {
      'title': titleController.text,
      'action': actionController.text,
      'details': descriptionController.text,
      'impact': riskImpact,
      'date': dateController.text,
      'user': widget.risk.user["_id"],
      'project':widget.risk.project["_id"], // Simplified project field
    };

    await riskService.updateRisk(widget.risk.id, updatedRisk);
    Navigator.of(context).pushReplacementNamed('/tlrisks');

      ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
            content: SuccessSnackBar(message: "Risk updated !"),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          );
        }catch(error) {
        print('Error updating risk: $error');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
            content: SuccessSnackBar(message: "Risk updated!"),
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
