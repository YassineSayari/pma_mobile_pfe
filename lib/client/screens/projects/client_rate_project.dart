import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:pma/services/project_service.dart';
import 'package:pma/theme.dart';

class ClientRate extends StatefulWidget {
  final String? projectId;
  final String projectname;
  ClientRate({Key? key, required this.projectId, required this.projectname}) : super(key: key);
  @override
  _ClientRateState createState() => _ClientRateState();
}

class _ClientRateState extends State<ClientRate> {
  String? timelineSatisfaction;
  String? reportingSatisfaction;
  String? communicationSatisfaction;
  String? incidentHandlingSatisfaction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback',style: TextStyle(
            fontSize: AppTheme.appBarFontSize,
            fontWeight: FontWeight.w600,
            fontFamily: AppTheme.fontName,
            overflow: TextOverflow.visible
          ),),
        centerTitle: true,
      ),
      body: Expanded(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Center(
                    child: Text("How would you rate your experience:",style: TextStyle(
                                fontSize: 25.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppTheme.fontName,
                              ),),
                  ),
                  buildQuestion('Are you satisfied with the project timeline?', timelineSatisfaction, (value) {
                    setState(() {
                      timelineSatisfaction = value;
                    });
                  }),
                  SizedBox(height: 10.h),
                  buildQuestion('Are you satisfied with the reporting level?', reportingSatisfaction, (value) {
                    setState(() {
                      reportingSatisfaction = value;
                    });
                  }),
                  SizedBox(height: 10.h),
                  buildQuestion('Are you satisfied with the communication on the progress of the project?', communicationSatisfaction, (value) {
                    setState(() {
                      communicationSatisfaction = value;
                    });
                  }),
                  SizedBox(height: 10.h),
                  buildQuestion('Are you satisfied with the handling of incidents?', incidentHandlingSatisfaction, (value) {
                    setState(() {
                      incidentHandlingSatisfaction = value;
                    });
                  }),
                  SizedBox(height: 20.h),
                   Row(
                children: [
                    Expanded(
                         child: ElevatedButton(
                               onPressed: calculateRate,
            
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
          ],
        ),
      ),
    );
  }

  Widget buildQuestion(String question, String? satisfaction, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),
        Text(
          question,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            fontFamily: AppTheme.fontName
          ),
        ),
        Row(
          children: [
            Radio<String>(
              value: 'Yes',
              groupValue: satisfaction,
              onChanged: onChanged,
            ),
            Text('Yes',
            style: TextStyle(
            fontSize: 18.sp,
            fontFamily: AppTheme.fontName
          ),
          ),
          SizedBox(width: 10.w),
            Radio<String>(
              value: 'No',
              groupValue: satisfaction,
              onChanged: onChanged,
            ),
            Text('No',
            style: TextStyle(
            fontSize: 18.sp,
            fontFamily: AppTheme.fontName
          ),
          ),
          ],
        ),
      ],
    );
  }

  Future<void> calculateRate() async{
    print("calculating rate");
    int totalSatisfaction = 0;
    int totalQuestions = 4;

    totalSatisfaction += satisfactionValue(timelineSatisfaction);

    totalSatisfaction += satisfactionValue(reportingSatisfaction);

    totalSatisfaction += satisfactionValue(communicationSatisfaction);

    totalSatisfaction += satisfactionValue(incidentHandlingSatisfaction);

    int rate = totalQuestions == 0 ? 0 : (totalSatisfaction / totalQuestions).toInt();

    print('Rate: $rate');
    ProjectService projectService = GetIt.I<ProjectService>(); 
    projectService.noteClient(widget.projectId!, rate);
 
  }

  int satisfactionValue(String? satisfaction) {
    if (satisfaction == 'Yes') {
      return 100;
    } else if (satisfaction == 'No') {
      return 0;
    } else {
      return 0; // Default value for unanswered questions
    }
  }
}



