import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/project_service.dart';

class ProjectContainer extends StatefulWidget {
  final String? projectId;
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
    this.projectId,
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
  _ProjectContainerState createState() => _ProjectContainerState();
}

class _ProjectContainerState extends State<ProjectContainer> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    DateTime? parsedDateDebut = DateTime.tryParse(widget.dateDebut)?.toLocal();
    DateTime? parsedDateFin = DateTime.tryParse(widget.dateFin)?.toLocal();

    String formattedDateDebut = parsedDateDebut != null
        ? DateFormat('MMM d, yyyy').format(parsedDateDebut)
        : 'Invalid Date';

    String formattedDateFin = parsedDateFin != null
        ? DateFormat('MMM d, yyyy').format(parsedDateFin)
        : 'Invalid Date';

    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.task_alt, size: 30),
                    Text(widget.projectName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                  ],
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: getColorForType(widget.type)['background'],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Text(
                          '${widget.type}',
                          style: TextStyle(
                            color: getColorForType(widget.type)['text'],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              IconButton(
                icon: Icon(
                  isExpanded ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down,
                  size: 35,
                  color: Color.fromARGB(255, 102, 31, 184),
                ),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
            ],
          ),
          ),
          if (isExpanded) ...[
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
                      child: Text('Description :',
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize:20)),
                    ),
                    TableCell(
                      child: Text(widget.description,
                      style: TextStyle(fontSize:20),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text('Start Date :',
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize:20)),
                    ),
                    TableCell(
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 18), // Calendar icon
                          SizedBox(width: 5),
                          Text(formattedDateDebut,
                          style: TextStyle(fontSize:20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              TableRow(
                  children: [
                    TableCell(
                      child: Text('Team Leader :',
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize:20)),
                    ),
                    TableCell(
                      child: Text(widget.teamLeaderId,
                      style: TextStyle(fontSize:20),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text('Status :',
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize:20)),
                    ),
                    TableCell(
                      child: Text(widget.status,
                      style: TextStyle(fontSize:20),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text('Priority :',
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize:20)),
                    ),
                    TableCell(
                      child: Row(
                        children: [
                          getPriorityIcon(widget.priority),
                          SizedBox(width: 5),
                          Text(widget.priority,
                          style: TextStyle(fontSize:20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text('Deadline :',
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize:20)),
                    ),
                    TableCell(
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 18), // Calendar icon
                          SizedBox(width: 5),
                          Text(formattedDateFin,
                          style: TextStyle(fontSize:20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text('Client :',
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize:20)),
                    ),
                    TableCell(
                      child: Text(widget.client,
                      style: TextStyle(fontSize:20),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text('Team :',
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize:20)),
                    ),
                    TableCell(
                      child: Text(getTeamNames(widget.equipe),
                      style: TextStyle(fontSize:20),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text('Progress',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                    ),
                    TableCell(
                      child: Text('${widget.progress}%',
                          style: TextStyle(color: Colors.grey,fontSize: 20)),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              width: 250.0,
              child: LinearProgressIndicator(
                value: widget.progress / 100.0,
                backgroundColor: Colors.grey,
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            SizedBox(height: 10),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              child: Row(
                children: [
                       GestureDetector(
                      onTap: () {
                      },
                      child: Icon(
                        Icons.edit_outlined,
                        size: 35,
                        color: Color.fromARGB(255, 102, 31, 184),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        print("deleting project : ${widget.projectId}");
                        deleteProject(widget.projectId!);},
                      child: Icon(
                        Icons.delete_outline,
                        size: 35,
                        color: Color.fromARGB(255, 188, 14, 14),
                      ),
                    ),
                ],
              ),
            )
          ],
        ],
      ),
    );
  }

  
  void deleteProject(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this Project?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                ProjectService().deleteProject(id);
                setState(() {
                });
                Navigator.of(context).pushReplacementNamed("/allprojects");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Project deleted successfully.'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.yellow,
                  ),
                );
              },
              child: Text("Delete",style: TextStyle(color: Colors.red),),
            ),
          ],
        );
      },
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

