import 'package:flutter/material.dart';

class ProjectContainer extends StatelessWidget {
  final String projectName;
  final String status;
  final String description;
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
    , required this.status,
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
          Text('Project Name: $projectName'),
          Text('Status: $status'),
          Text('Description: $description'),
          Text('Start Date: $dateDebut'),
          Text('Team Leader ID: $teamLeaderId'),
          Text('Priority: $priority'),
          Text('Deadline: $dateFin'),
          Text('Client ID: $client'),
          Text('Team: ${getTeamNames(equipe)}'),
          //Text('Team: $equipe'),
          Text('Progress: $progress%'),
        ],
      ),
    );
  }
  String getTeamNames(List<dynamic> equipe) {
    if (equipe.isEmpty) {
      return 'No Team Members';
    }
    return equipe.map((member) => member['fullName']).join(', ');
  }
}
