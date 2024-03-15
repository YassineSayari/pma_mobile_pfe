import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pma/const.dart';
import 'package:pma/services/shared_preferences.dart';

import '../models/project_model.dart';



class ProjectService {

  final String apiUrl = '$baseUrl/api/v1/projects';
  
  
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


Future<Project> getProject(String projectId) async {
  print("getting project $projectId");
  try {
    final response = await http.get(Uri.parse('$apiUrl/getproject/$projectId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> projectJson = json.decode(response.body);
      return Project.fromJson(projectJson);
    } else {
      print("Failed to get project. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to get project. Server error.');
    }
  } catch (error) {
    print("Error getting project: $error");
    throw Exception('Failed to get project. $error');
  }
}


Future<List<Map<String, dynamic>>> getProjectsByClient(String id) async{
  print("getting projects for :::: $id");
    try{
      final response=await http.get(
        Uri.parse('$apiUrl/getprojectbyClient/$id')
      );
      if (response.statusCode==200)
        {
          print("got projects for client");
          List<dynamic> projectsJson = json.decode(response.body);
          print("got ${projectsJson.length} projects for the client");
          return projectsJson.cast<Map<String, dynamic>>();
        }
      else {
        print("Failed to load projects for client. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to load projects for client. Server error.');
      }
    }catch(error){
      print("Error loading projects: $error");
      throw Exception('Failed to load projects for client. $error');
    }

}


  Future<void> addProject(Map<String, dynamic> projectData) async {
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


Future<void> updateProject(String projectId, Map<String, dynamic> projectData) async {
  String? authToken = await SharedPrefs.getAuthToken();

  print("updating project $projectId");
  try {
    final Uri uri = Uri.parse('$apiUrl/updateProject/$projectId');
    final String requestBody = jsonEncode(projectData);

    print("Request URL: $uri");
    print("Request Headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $authToken'}");
    print("Request Body: $requestBody");

    final response = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: requestBody,
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 201) {
      print("Project updated successfully");
    } else {
      print("Failed to update project. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to update project. Server error.');
    }
  } catch (error) {
    print("Error updating project: $error");
    throw Exception('Failed to update project. $error');
  }
}


  Future<void> updateProjectStatus(String projectId, String newStatus) async {
  String? authToken = await SharedPrefs.getAuthToken();

    try {
      print("updating project::::$projectId to ::::$newStatus ");
      final response = await http.patch(
        Uri.parse("$apiUrl/updateStatus/$projectId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'status': newStatus,
        }),
      );

      if (response.statusCode == 200) {
        print('Project status updated successfully');
      } else {
        print('Failed to update project status. ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating project status: $error');
    }
  }


  Future<void> noteClient(String projectId, int rate) async {
    try {
      print("Adding client note");
      final response = await http.patch(
        Uri.parse("$apiUrl/updateStatus/$projectId"), 
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'note_Client': rate,
        }),
      );

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        print('Note added successfully');
      } else {
        print('Failed to add note. ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding note: $error');
    }
  }

  // Future<void> noteClient(String projectId,int rate) async{
  //   try {
  //     print("adding client note");
  //     final response = await http.patch(
  //       Uri.parse("$apiUrl/noteCleint/$projectId"),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({
  //         'note_Client': rate,
  //       }),
  //     );

  //     if (response.statusCode == 201) {
  //       print('Note added successfully');
  //     } else {
  //       print('Failed to add note . ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     print('Error adding note : $error');
  //   }
  // }




  

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