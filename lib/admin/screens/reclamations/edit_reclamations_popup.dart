import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/models/reclamation_model.dart';
import 'package:pma/models/user_model.dart';
import 'package:pma/services/project_service.dart';
import 'package:pma/services/reclamation_service.dart';
import 'package:pma/services/user_service.dart';
import 'package:pma/theme.dart';

class EditReclamationPopup extends StatefulWidget {
  final Reclamation reclamation;
  const EditReclamationPopup({super.key, required this.reclamation});

  @override
  State<EditReclamationPopup> createState() => _EditReclamationPopupState();
}

class _EditReclamationPopupState extends State<EditReclamationPopup> {

    final _formKey = GlobalKey<FormState>();

    late TextEditingController titleController;
    late Future<List<Map<String, dynamic>>> projects;
    late Future<List<User>> clients;

    String? projectid;
    String? clientid;

    late String reclamationStatus;
    String? reclamationType;

    DateTime? creationDate;
    final TextEditingController creationDateController = TextEditingController();
    late TextEditingController commentController;
    late TextEditingController responseController;

  final ProjectService projectService = GetIt.I<ProjectService>();
  final ReclamationService reclamationService = GetIt.I<ReclamationService>();

      @override
  void initState() {
    super.initState();
    projects = projectService.getAllProjects();
    clients=UserService().getAllClients();

    titleController = TextEditingController(text: widget.reclamation.title);
    commentController= TextEditingController(text: widget.reclamation.comment);
    responseController=TextEditingController(text: widget.reclamation.reponse);
    projectid = widget.reclamation.project["_id"];
    clientid=widget.reclamation.client["_id"];
    reclamationStatus= widget.reclamation.status;
    reclamationType= widget.reclamation.typeReclamation;

    creationDate = DateTime.parse(widget.reclamation.addedDate);
    creationDateController.text = DateFormat('yyyy-MM-dd').format(creationDate!);

    

    print("proejct id::::: $projectid");
    print("client id::::: $clientid");
    

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
                          value: reclamationStatus,
                          style: AppTextFieldStyles.textStyle,
                                decoration: InputDecoration(
                                  labelText: 'Status*',
                                  labelStyle: AppTextFieldStyles.labelStyle,
                                  enabledBorder: AppTextFieldStyles.enabledBorder,
                                  focusedBorder: AppTextFieldStyles.focusedBorder,
                                ),
                          items: [
                            DropdownMenuItem(child: Text('Pending',style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName),), value: 'Pending'),
                            DropdownMenuItem(child: Text('In Treatment',style: TextStyle(fontSize: 20.sp,fontFamily:AppTheme.fontName),), value: 'In treatment'),
                            DropdownMenuItem(child: Text('Treated',style: TextStyle(fontSize: 20.sp,fontFamily:AppTheme.fontName),), value: 'Treated'),
                          ],
                          
                          onChanged: (selectedValue) {
                            setState(() {
                              reclamationStatus = selectedValue as String;
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
                       DropdownButtonFormField(
                          value: reclamationType,
                          style: AppTextFieldStyles.textStyle,
                                decoration: InputDecoration(
                                  labelText: 'Type*',
                                  labelStyle: AppTextFieldStyles.labelStyle,
                                  enabledBorder: AppTextFieldStyles.enabledBorder,
                                  focusedBorder: AppTextFieldStyles.focusedBorder,
                                ),
                          items: [
                            DropdownMenuItem(child: Text('Technical',style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName),), value: 'Technical'),
                            DropdownMenuItem(child: Text('Commercial',style: TextStyle(fontSize: 20.sp,fontFamily:AppTheme.fontName),), value: 'Commercial'),
                          ],
                          
                          onChanged: (selectedValue) {
                            setState(() {
                              reclamationType = selectedValue as String?;
                            });
                          },
                          validator: (value) {
                            if (value == null ) {
                              return 'type is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        FutureBuilder<List<User>>(
                              future: clients,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return SpinKitThreeBounce(color: Colors.blueAccent,size: 30,);
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return Text('No clients available.');
                                } else {
                                  print('clients:: $clients');
                                  return DropdownButtonFormField(
                                    value: clientid,
                                    itemHeight: 60,
                                    style: AppTextFieldStyles.textStyle,
                                          decoration: InputDecoration(
                                            labelText: 'Client*',
                                            labelStyle: AppTextFieldStyles.labelStyle,
                                            enabledBorder: AppTextFieldStyles.enabledBorder,
                                            focusedBorder: AppTextFieldStyles.focusedBorder,
                                          ),

                                    items: snapshot.data!.map<DropdownMenuItem<String>>((User client) {
                                      return DropdownMenuItem<String>(
                                        value: client.id,
                                        child: Text(client.fullName, style: TextStyle(fontSize: 20.sp, fontFamily: AppTheme.fontName)),
                                      );
                                    }).toList(),

                                    onChanged: (selectedValue) {
                                      setState(() {
                                        clientid = selectedValue as String?;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Client is required';
                                      }
                                      return null;
                                    },
                                    
                                  );
                                }
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
                                    style: AppTextFieldStyles.textStyle,
                                          decoration: InputDecoration(
                                            labelText: 'Creation Date*',
                                            labelStyle: AppTextFieldStyles.labelStyle,
                                            enabledBorder: AppTextFieldStyles.enabledBorder,
                                            focusedBorder: AppTextFieldStyles.focusedBorder,
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
                                  controller: commentController,
                                  maxLines: 3,
                                    style: AppTextFieldStyles.textStyle,
                                          decoration: InputDecoration(
                                            labelText: 'Comment*',
                                            labelStyle: AppTextFieldStyles.labelStyle,
                                            enabledBorder: AppTextFieldStyles.enabledBorder,
                                            focusedBorder: AppTextFieldStyles.focusedBorder,
                                          ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a valid comment';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10.h),

                                  TextFormField(
                                  controller: responseController,
                                  maxLines: 3,
                                  style: AppTextFieldStyles.textStyle,
                                        decoration: InputDecoration(
                                          labelText: 'response*',
                                          labelStyle: AppTextFieldStyles.labelStyle,
                                          enabledBorder: AppTextFieldStyles.enabledBorder,
                                          focusedBorder: AppTextFieldStyles.focusedBorder,
                                        ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a valid response';
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
                                    _updateReclamation();
                                        Navigator.of(context).pushReplacementNamed('/reclamations');
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

   Future<void> _updateReclamation() async {
        try {
          Reclamation updatedReclamation = Reclamation(
            id: widget.reclamation.id,
            title: titleController.text,
            status:reclamationStatus,
            comment: commentController.text,
            typeReclamation:reclamationType! ,
            client: {'_id': clientid},
            addedDate: DateFormat('yyyy-MM-dd').format(creationDate!),
            project: {'_id': projectid},
            
          );
          await reclamationService.updateReclamation(widget.reclamation.id,updatedReclamation);

           ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
            content: SuccessSnackBar(message: "Reclamation updated !"),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          );
          Navigator.of(context).pushReplacementNamed('/reclamations');
        }catch(error) {
        print('Error updating reclamation: $error');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
            content: FailSnackBar(message: "failed to update reclamation!"),
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