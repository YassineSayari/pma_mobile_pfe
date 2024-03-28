import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pma/const.dart';


// Define the StatefulWidget
class MyDashboardWidget extends StatefulWidget {
  @override
  _MyDashboardWidgetState createState() => _MyDashboardWidgetState();
}

// State class for MyDashboardWidget
class _MyDashboardWidgetState extends State<MyDashboardWidget> {
  int _clientsCount = 0;
  int _projectsCount = 0;
  int _teamLeadersCount = 0;
  int _engineersCount = 0;

  // Define getters for each variable
  int get clientsCount => _clientsCount;
  int get projectsCount => _projectsCount;
  int get teamLeadersCount => _teamLeadersCount;
  int get engineersCount => _engineersCount;

  @override
  void initState() {
    super.initState();
    loadCounts();
  }

  Future<void> loadCounts() async {
    _clientsCount = await fetchDataCount('clients');
    _projectsCount = await fetchDataCount('projects');
    _teamLeadersCount = await fetchDataCount('team-leaders');
    _engineersCount = await fetchDataCount('engineers');

    setState(() {}); // Notify the framework to redraw the widget
  }

  // Method to fetch data count
  final String apiUrl = '$baseUrl/api/v1/events';

  Future<int> fetchDataCount(String endpoint) async {
  final response = await http.get(
      Uri.parse('$apiUrl/getAllEvent'));

    if (response.statusCode == 200) {
      // Assuming the response body is a JSON array
      final data = jsonDecode(response.body);
      return data.length; // Return the count of items
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Widget build method
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Clients: $clientsCount'),
            Text('Projects: $projectsCount'),
            Text('Team Leaders: $teamLeadersCount'),
            Text('Engineers: $engineersCount'),
          ],
        ),
      ),
    );
  }
}
