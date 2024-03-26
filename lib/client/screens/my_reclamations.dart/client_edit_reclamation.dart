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

class ClientEditReclamationPopup extends StatefulWidget {
  final Reclamation reclamation;
  const ClientEditReclamationPopup({Key? key, required this.reclamation});

  @override
  State<ClientEditReclamationPopup> createState() =>
      _ClientEditReclamationPopupState();
}

class _ClientEditReclamationPopupState
    extends State<ClientEditReclamationPopup> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late Future<List<User>> clients;
  late Future<List<Map<String, dynamic>>> projects;
  String? projectid;
  String? clientid;

  late String validateStatus;
  String? reclamationType;

  DateTime? creationDate;
  final TextEditingController creationDateController = TextEditingController();
  late TextEditingController commentController;

  final ProjectService projectService = GetIt.I<ProjectService>();
  final ReclamationService reclamationService = GetIt.I<ReclamationService>();

  @override
  void initState() {
    super.initState();
    clients = UserService().getAllClients();
    projects = projectService.getProjectsByClient(widget.reclamation.client["_id"]);
    clientid=widget.reclamation.client["_id"];
    titleController = TextEditingController(text: widget.reclamation.title);
    commentController = TextEditingController(text: widget.reclamation.comment);
    projectid = widget.reclamation.project["_id"];
    validateStatus = widget.reclamation.status;
    reclamationType = widget.reclamation.typeReclamation;
    creationDate = DateTime.parse(widget.reclamation.addedDate);
    //creationDateController.text = DateFormat('yyyy-MM-dd').format(creationDate!);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 28.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Text(
                  "Edit",
                  style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontWeight: FontWeight.w600,
                      fontSize: 34.sp),
                )),
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
                      return SpinKitThreeBounce(
                        color: Colors.blueAccent,
                        size: 30,
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No projects available.');
                    } else {
                      return DropdownButtonFormField(
                        value: projectid,
                        style: AppTextFieldStyles.textStyle,
                        decoration: InputDecoration(
                          labelText: 'Project*',
                          labelStyle: AppTextFieldStyles.labelStyle,
                          enabledBorder: AppTextFieldStyles.enabledBorder,
                          focusedBorder: AppTextFieldStyles.focusedBorder,
                        ),
                        items: snapshot.data!.map<DropdownMenuItem<String>>(
                          (Map<String, dynamic> project) {
                            return DropdownMenuItem<String>(
                              value: project['_id'],
                              child: Text(
                                project['Projectname'],
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontFamily: AppTheme.fontName),
                              ),
                            );
                          },
                        ).toList(),
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
                // Conditionally show the Status field
                if (validateStatus == 'Treated' ) ...[
                  DropdownButtonFormField(
                    value: validateStatus,
                    style: AppTextFieldStyles.textStyle,
                    decoration: InputDecoration(
                      labelText: 'Status*',
                      labelStyle: AppTextFieldStyles.labelStyle,
                      enabledBorder: AppTextFieldStyles.enabledBorder,
                      focusedBorder: AppTextFieldStyles.focusedBorder,
                    ),
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          'Validate',
                          style: TextStyle(
                              fontSize: 20.sp, fontFamily: AppTheme.fontName),
                        ),
                        value: 'Validate',
                      ),
                      DropdownMenuItem(
                        child: Text(
                          ' ',
                          style: TextStyle(
                              fontSize: 20.sp, fontFamily: AppTheme.fontName),
                        ),
                        value: '${widget.reclamation.status}',
                      ),
                    ],
                    onChanged: (selectedValue) {
                      setState(() {
                        validateStatus = selectedValue as String;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Status is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),
                ],
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
                    DropdownMenuItem(
                      child: Text(
                        'Technical',
                        style: TextStyle(
                            fontSize: 20.sp, fontFamily: AppTheme.fontName),
                      ),
                      value: 'Technical',
                    ),
                    DropdownMenuItem(
                      child: Text(
                        'Commercial',
                        style: TextStyle(
                            fontSize: 20.sp, fontFamily: AppTheme.fontName),
                      ),
                      value: 'Commercial',
                    ),
                  ],
                  onChanged: (selectedValue) {
                    setState(() {
                      reclamationType = selectedValue as String?;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'type is required';
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
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _updateReclamation();
                          Navigator.of(context)
                              .pushReplacementNamed('/client_reclamations');
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.sp,
                              fontFamily: AppTheme.fontName),
                        ),
                        style: AppButtonStyles.submitButtonStyle,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.sp,
                              fontFamily: AppTheme.fontName),
                        ),
                        style: AppButtonStyles.cancelButtonStyle,
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
        status: validateStatus,
        comment: commentController.text,
        typeReclamation: reclamationType!,
        client: {'_id': clientid},
        addedDate: DateFormat('yyyy-MM-dd').format(creationDate!),
        project: {'_id': projectid},
      );
      await reclamationService
          .updateReclamation(widget.reclamation.id, updatedReclamation);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: SuccessSnackBar(message: "Reclamation updated !"),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
      // Navigator.of(context).pushReplacementNamed('/reclamations');
    } catch (error) {
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
      //Navigator.of(context).pop();
    }
  }
}
