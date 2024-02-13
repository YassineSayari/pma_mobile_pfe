import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectContainer extends StatelessWidget {

  final String projectName;
  final String status;
  final String description;
  final String type;
  final String dateDebut;
  final String teamLeaderId;
  final String priority;
  final String dateFin;
  final String client;
  final List<dynamic> equipe;
  final int progress;

  ProjectContainer({
    Key? key,
    required this.projectName,
    required this.description,
    required this.dateDebut,
    required this.teamLeaderId,
    required this.priority,
    required this.dateFin,
    required this.client,
    required this.equipe,
    required this.progress,
    required this.status,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? parsedDateDebut = DateTime.tryParse(dateDebut)?.toLocal();
    DateTime? parsedDateFin = DateTime.tryParse(dateFin)?.toLocal();

    String formattedDateDebut = parsedDateDebut != null
        ? DateFormat('MMM d, yyyy').format(parsedDateDebut)
        : 'Invalid Date';

    String formattedDateFin = parsedDateFin != null
        ? DateFormat('MMM d, yyyy').format(parsedDateFin)
        : 'Invalid Date';

    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.task_alt,size: 30),
                  Text(projectName, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30)),
                  //Text('Project Name', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      decoration: BoxDecoration(
                        color: getColorForType(type)['background'],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Text(
                        '$type',
                        style: TextStyle(
                          color: getColorForType(type)['text'],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Table(
            columnWidths: {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: Text('Description :', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  TableCell(
                    child: Text(description),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text('Start Date :', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  TableCell(
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 18), // Calendar icon
                        SizedBox(width: 5),
                        Text(formattedDateDebut),
                      ],
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text('Team Leader :', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  TableCell(
                    child: Text(teamLeaderId),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text('Status :', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  TableCell(
                    child: Text(status),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text('Priority :', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  TableCell(
                    child:Row(
                      children: [
                        getPriorityIcon(priority), // Icon based on priority
                        SizedBox(width: 5),
                        Text(priority),
                      ],
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text('Deadline :', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  TableCell(
                    child:  Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 18), // Calendar icon
                        SizedBox(width: 5),
                        Text(formattedDateFin),
                      ],
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text('Client :', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  TableCell(
                    child: Text(client),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text('Team :', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  TableCell(
                    child: Text(getTeamNames(equipe)),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text('Progress', style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold)),
                  ),
                  TableCell(
                    child: Text('$progress%', style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            width: 250.0,
            child: LinearProgressIndicator(
              value: progress / 100.0,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> getColorForType(String type) {
    switch (type) {
      case 'Development':
        return {'background': Colors.blue, 'text': Colors.white};
      case 'Systems Infrastructure':
        return {'background': Colors.grey[400], 'text': Colors.black};
      case 'Network Infrastructure':
        return {'background': Colors.orange, 'text': Colors.white};
      case 'Systems And Networks Infrastructure':
        return {'background': Colors.green, 'text': Colors.white};
      default:
        return {'background': Colors.grey, 'text': Colors.black};
    }
  }

  String getTeamNames(List<dynamic> equipe) {
    if (equipe.isEmpty) {
      return 'No Team Members';
    }
    return equipe.map((member) => member['fullName']).join(', ');
  }


  Widget getPriorityIcon(String priority) {
    switch (priority) {
      case 'High':
        return Icon(Icons.keyboard_double_arrow_up_rounded, color: Colors.red);
      case 'Medium':
        return Icon(Icons.swap_horiz_rounded, color: Colors.orange);
      case 'Low':
        return Icon(Icons.keyboard_double_arrow_down_rounded, color: Colors.green);
      default:
        return Icon(Icons.swap_horiz_rounded, color: Colors.grey); // Default icon
    }
  }
}


/*import 'package:flutter/material.dart';

class ProjectContainer extends StatelessWidget {
  final String projectName;
  final String status;
  final String description;
  final String type;
  final String dateDebut;
  final String teamLeaderId;
  final String priority;
  final String dateFin;
  final String client;
  final List<dynamic> equipe;
  final int progress;

  ProjectContainer({
    Key? key,
    required this.projectName,
    required this.description,
    required this.dateDebut,
    required this.teamLeaderId,
    required this.priority,
    required this.dateFin,
    required this.client,
    required this.equipe,
    required this.progress
    , required this.status, required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(' $projectName',style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                    ),
                    Text(' '),
                    Text('Description:',style: TextStyle(fontWeight: FontWeight.w400),),
                    Text('Start Date:'),
                    Text('Team Leader ID:'),
                    Text('Status:'),
                    Text('Priority: '),
                    Text('Deadline:'),
                    Text('Client ID:'),
                    Text('Team: '),
                    Text('Progress:'),
                  ],
                ),
              ),
                SizedBox(width: 10),
              Align(
                alignment: Alignment.topRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Container(
                      decoration: BoxDecoration(
                        color: getColorForType(type)['background'], // Get background color based on type
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Text('$type',style: TextStyle(
                        color: getColorForType(type)['text'], // Get text color based on type
                      ),),
                    ),
                    Text(' '),

                    Text(' $description'),
                Text('$dateDebut'),
                Text(' $teamLeaderId'),
                Text('$status'),
                Text('$priority'),
                Text('$dateFin'),
                Text(' $client'),
                Text(' ${getTeamNames(equipe)}'),
                Text(' $progress%'),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: 250.0,
            child: LinearProgressIndicator(
              value: progress / 100.0,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Adjust color as needed
            ),
          ),
        ],
      ),
    );
  }


  Map<String, dynamic> getColorForType(String type) {
    switch (type) {
      case 'Development':
        return {'background': Colors.blue, 'text': Colors.white};
      case 'Systems Infrastructure':
        return {'background': Colors.grey[400], 'text': Colors.black};
      case 'Network Infrastructure':
        return {'background': Colors.orange, 'text': Colors.white};
      case 'Systems And Networks Infrastructure':
        return {'background': Colors.green, 'text': Colors.white};
      default:
        return {'background': Colors.grey, 'text': Colors.black}; // Default colors
    }
  }

  String getTeamNames(List<dynamic> equipe) {
    if (equipe.isEmpty) {
      return 'No Team Members';
    }
    return equipe.map((member) => member['fullName']).join(', ');
  }
}
 */