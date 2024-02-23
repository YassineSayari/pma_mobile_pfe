import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pma/services/shared_preferences.dart';

import '../models/project_model.dart';

const ip = "192.168.0.19";
const port = 3002;

class ProjectService {

  final String apiUrl = 'http://$ip:$port/api/v1/projects';
  
  
  Future<List<Map<String, dynamic>>> getAllProjects() async{
    print("getting projects...");
    try{
      final response=await http.get(
        Uri.parse('$apiUrl/getAllProjects')
      );
      if (response.statusCode==200)
        {
          print("got projects");
          List<dynamic> projectsJson = json.decode(response.body);
          return projectsJson.cast<Map<String, dynamic>>();
        }
      else {
        print("Failed to load projects. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to load projects. Server error.');
      }
    }catch(error){
      print("Error loading projects: $error");
      throw Exception('Failed to load projects. $error');
    }
  }

  Future<Project> addProject(Map<String, dynamic> projectData) async {
    print("adding project");
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/addProject'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(projectData),
      );

      if (response.statusCode == 200) {
        print("project added");
        print(response.statusCode);
        return Project.fromJson(jsonDecode(response.body));
      } else {
        print("Failed to add project. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to add project. Server error.');
      }
    } catch (error) {
      print("Error adding project: $error");
      throw Exception('Failed to add project. $error');
    }
  }

  Future<void> deleteProject(String projectId)async  {
       print("deleting project");
       String? authToken = await SharedPrefs.getAuthToken();

    try {
        final response = await http.delete(
          Uri.parse('$apiUrl/deleteProject/$projectId'),
                  headers: {
          'Authorization': 'Bearer $authToken',
        },
          );
          if (response.statusCode == 200) {
            print("project deleted");
          } else {
              print("Failed to delete project. Status code: ${response.statusCode}");
              print("Response body: ${response.body}");
              throw Exception('Failed to delete project. Server error.');
      }
      } catch (error) {
      print("Error deleting project: $error");
      throw Exception('Failed to delete project. $error');
    }


}
}