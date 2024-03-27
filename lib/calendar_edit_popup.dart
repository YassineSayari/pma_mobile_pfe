import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/models/event_model.dart';

import 'package:pma/services/event_service.dart';

import 'package:pma/theme.dart';

class EditEventPopup extends StatefulWidget {
  final Event event;
  const EditEventPopup({super.key, required this.event});

  @override
  State<EditEventPopup> createState() => _EditEventPopupState();
}

class _EditEventPopupState extends State<EditEventPopup> {

    final _formKey = GlobalKey<FormState>();

    late TextEditingController titleController;

    late String category;

    DateTime? startDate;
    final TextEditingController startDateController = TextEditingController();

    DateTime? endDate;
    final TextEditingController deadLineController = TextEditingController();

    late TextEditingController descriptionController;



      @override
  void initState() {
    super.initState();


    titleController = TextEditingController(text: widget.event.title);
    descriptionController= TextEditingController(text: widget.event.details);
    category= widget.event.category;
    startDate = widget.event.startDate;
    startDateController.text = DateFormat('yyyy-MM-dd').format(startDate!);

    endDate = widget.event.endDate;
    deadLineController.text = DateFormat('yyyy-MM-dd').format(endDate!);
    

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
                        DropdownButtonFormField(
                          value: category,
                          style: AppTextFieldStyles.textStyle,
                                decoration: InputDecoration(
                                  labelText: 'Category*',
                                  labelStyle: AppTextFieldStyles.labelStyle,
                                  enabledBorder: AppTextFieldStyles.enabledBorder,
                                  focusedBorder: AppTextFieldStyles.focusedBorder,
                                ),
                          items: [
                            DropdownMenuItem(child: Text('Work',style: TextStyle(fontSize:20.sp,fontFamily:AppTheme.fontName),), value: 'Work'),
                            DropdownMenuItem(child: Text('Personal',style: TextStyle(fontSize: 20.sp,fontFamily:AppTheme.fontName),), value: 'Personal'),
                            DropdownMenuItem(child: Text('Important',style: TextStyle(fontSize: 20.sp,fontFamily:AppTheme.fontName),), value: 'Important'),
                            DropdownMenuItem(child: Text('Travel',style: TextStyle(fontSize: 20.sp,fontFamily:AppTheme.fontName),), value: 'Travel'),
                            DropdownMenuItem(child: Text('Friends',style: TextStyle(fontSize: 20.sp,fontFamily:AppTheme.fontName),), value: 'Friends'),
                          ],
                          
                          onChanged: (selectedValue) {
                            setState(() {
                              category = selectedValue as String;
                            });
                          },
                          validator: (value) {
                            if (value == null ) {
                              return 'category is required';
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
                                      if (pickedDate != null && pickedDate != endDate) {
                                        setState(() {
                                          endDate = pickedDate;
                                          deadLineController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                        });
                                      }
                                    },
                                    controller: startDateController,
                                    readOnly: true,
                                    style: AppTextFieldStyles.textStyle,
                                          decoration: InputDecoration(
                                            labelText: 'Deadline*',
                                            labelStyle: AppTextFieldStyles.labelStyle,
                                            enabledBorder: AppTextFieldStyles.enabledBorder,
                                            focusedBorder: AppTextFieldStyles.focusedBorder,
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
                                    _updateEvent();
                                        //Navigator.of(context).pushReplacementNamed('/tasks');
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

   Future<void> _updateEvent() async {
        try {
          Event updatedEvent= Event(
            id: widget.event.id,
            title: titleController.text,
            category:category,
            details: descriptionController.text,
            startDate: startDate!,
            endDate: endDate!,
             className: widget.event.className, userId: widget.event.userId,          
          );
          await EventService().updatedEvent(widget.event.id,updatedEvent);

           ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
            content: SuccessSnackBar(message: "event updated !"),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          );
          Navigator.of(context).pushReplacementNamed('/calendar');
        }catch(error) {
        print('Error updating event: $error');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
            content: FailSnackBar(message: "failed to update event!"),
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
