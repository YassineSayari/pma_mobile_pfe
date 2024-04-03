import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:pma/custom_snackbar.dart';
import 'package:pma/services/event_service.dart';
import 'package:pma/theme.dart';

class AddEventContainer extends StatefulWidget {
  final String userId;
  const AddEventContainer({super.key, required this.userId});

  @override
  State<AddEventContainer> createState() => _AddEventState();
}

class _AddEventState extends State<AddEventContainer> {


  final _formKey = GlobalKey<FormState>();
  final TextEditingController title = TextEditingController();
  String? eventType;
  DateTime? eventStartDate;
  final TextEditingController eventStartDateController = TextEditingController();

  DateTime? eventEndDate;
  final TextEditingController eventEndDateController = TextEditingController();
  final TextEditingController details= TextEditingController();
    
  @override
  Widget build(BuildContext context) {
    return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 188, 199, 220),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            children: [
              Center(
                child: Text(
                  'New Event',
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 20.h),


                       Form(
                        key: _formKey,
                         child: Column(
                          children: [
                            TextFormField(
                            controller: title,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 25.sp,
                              fontFamily: AppTheme.fontName,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Title*',
                              labelStyle: TextStyle(
                                color: Color(0xFF7743DB),
                                fontSize: 20.sp,
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w600,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ' title is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.h),
                                             DropdownButtonFormField(
                                             value: eventType,
                                             decoration: InputDecoration(
                                               labelText: 'Type*',
                                               labelStyle: TextStyle(
                          color: Color(0xFF7743DB),
                          fontSize: 20.sp,
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w600,
                                               ),
                                               enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.grey,
                          ),
                                               ),
                                               focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.grey,
                          ),
                                               ),
                                             ),
                                             items: [
                                               DropdownMenuItem(child: Text('Work',style: TextStyle(fontSize:20),), value: 'Work'),
                                               DropdownMenuItem(child: Text('Presonal',style: TextStyle(fontSize: 20),), value: 'Personal'),
                                               DropdownMenuItem(child: Text('Important',style: TextStyle(fontSize: 20),), value: 'Important'),
                                               DropdownMenuItem(child: Text('Travel',style: TextStyle(fontSize: 20),), value: 'Travel'),
                                             ],
                                             onChanged: (selectedValue) {
                                               setState(() {
                          eventType = selectedValue as String?;
                                               });
                                             },
                                             validator: (value) {
                                               if (value == null || value.isEmpty) {
                          return ' Type is required';
                                               }
                                               return null;
                                             },
                                           ),
                                           SizedBox(height: 10.h),
                                           TextFormField(
                                onTap: () async {
                                   
                                  DateTime? pickedDate = await showOmniDateTimePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now().add(Duration(days: 365 * 2)),

                                  );
                                  if (pickedDate != null && pickedDate != eventStartDate) {
                                    setState(() {
                                      eventStartDate = pickedDate;
                                      eventStartDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                    });
                                  }
                                },
                                controller: eventStartDateController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: 'Start Date*',
                                  labelStyle: TextStyle(
                                    color: Color(0xFF7743DB),
                                    fontSize: 15.sp,
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                validator: (value) {
                                  if (eventStartDate == null) {
                                    return ' Start Date is required';
                                  }
                                  return null;
                                },
                              ),
                            
                                               
                          SizedBox(height: 10.h),
                          TextFormField(
                          onTap: () async {
                            DateTime? pickedDate = await showOmniDateTimePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2023),
                              lastDate: DateTime(2025),
                            );
                            if (pickedDate != null && pickedDate != eventEndDate) {
                              setState(() {
                                eventEndDate = pickedDate;
                                eventEndDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                              });
                            }
                          },
                          controller: eventEndDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'End Date*',
                            labelStyle: TextStyle(
                              color: Color(0xFF7743DB),
                              fontSize: 15.sp,
                              fontFamily: AppTheme.fontName,
                              fontWeight: FontWeight.w600,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.grey,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              color: Colors.grey[400],
                            ),
                          ),
                          validator: (value) {
                            if (eventEndDate == null) {
                              return ' End Date is required';
                            }
                            return null;
                          },
                                               ),
                                               SizedBox(height: 10),
                                               TextFormField(
                            controller: details,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 25.sp,
                              fontFamily: AppTheme.fontName,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Details',
                              labelStyle: TextStyle(
                                color: Color(0xFF7743DB),
                                fontSize: 20.sp,
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w600,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                                           Row(
                                             mainAxisAlignment: MainAxisAlignment.center,
                                             children: [
                                               Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              print("add event button pressed");
                              createEvent();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9F7BFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.sp,
                                fontFamily: AppTheme.fontName,
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
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.sp,
                                fontFamily: AppTheme.fontName,
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
            ],
          ),
        );

}

Future<void> createEvent() async{

try{
if (!_formKey.currentState!.validate()) {
        print("Invalid information");
        return;
      }
        if (title.text.isEmpty || eventType == null) {
    print("Title and category are required.");
    return;
  }

      EventService eventService = EventService();
     Map<String, dynamic> eventData = {
       'title':title.text,
       'category': eventType,
        'endDate': eventEndDate?.toIso8601String(),
        'startDate':eventStartDate?.toIso8601String(),
        'details':details.text,
        'user':widget.userId,
     };
     await eventService.addEvent(eventData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:SuccessSnackBar(message: "Event added successfully",
          ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
      ),
      );
      Navigator.of(context).pushReplacementNamed('/calendar');
      resetForm();
     }
     catch(error){
  ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
           content:FailSnackBar(message: "Failed to add event. Please try again",
          ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
        ),
      );
     }
}

  void resetForm() {
    setState(() {
      title.clear();
      details.clear();
      eventStartDate = null;
      eventEndDate = null;
      eventType = null;
    });
  }
}


