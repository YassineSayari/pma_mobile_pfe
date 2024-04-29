import 'dart:convert';

import 'package:pma/const.dart';
import 'package:http/http.dart' as http;
import 'package:pma/models/task_model.dart';
import 'package:pma/services/shared_preferences.dart';
//import 'package:pma/services/shared_preferences.dart';


class TaskService {

  final String apiUrl = '$baseUrl/api/v1/tasks';
  

 Future<List<Task>> getAllTasks() async {
    print("getting tasks");
    final response = await http.get(
      Uri.parse('$apiUrl/getAllTasks'),
    );

    if (response.statusCode == 200) {
      print("got tasks");
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((eventData) => Task.fromJson(eventData)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

   Future<List<Task>> getTasksByExecutor(String id) async {
    String? authToken = await SharedPrefs.getAuthToken();
    print("getting tasks for $id");
    final response = await http.get(
      Uri.parse('$apiUrl/getTaskByExecutor/$id'),
      headers: {
          'Authorization': 'Bearer $authToken',
        },
    );

    if (response.statusCode == 200) {
      print("got tasks");
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((eventData) => Task.fromJson(eventData)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }


   Future<List<Task>> getTasksByTeamLeader(String id) async {
    print("getting tasks for $id");
    final response = await http.get(
      Uri.parse('$apiUrl/gettskks/$id'),
      // headers: {
      //     'Authorization': 'Bearer $authToken',
      //   },
    );

    if (response.statusCode == 200) {
      print("got tasks");
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((eventData) => Task.fromJson(eventData)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }


Future<void> addTask(Map<String, dynamic> task) async {
  try {
    String? authToken = await SharedPrefs.getAuthToken();
    if (authToken == null) {
      throw Exception('Failed to get authentication token.');
    }

      final response = await http.post(
    Uri.parse('$apiUrl/createTask'),
    headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    },
    body: json.encode(task),
  );

    print("Request body: ${json.encode(task)}");
    print("Response code: ${response.statusCode}");
    print("Response headers: ${response.headers}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      print("Task added successfully!");
    } else if (response.statusCode == 400) {
      throw Exception('Failed to add task. Bad request.');
    } else if (response.statusCode == 401) {
      throw Exception('Failed to add task. Unauthorized.');
    } else {
      throw Exception(
          'Failed to add task. Error: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error adding task: $e');
    throw Exception('Failed to add task. $e');
  }
}


Future<void> updateTask(String id, Task updatedTask) async {

  print("------------updating task $id");

  final response = await http.put(
    Uri.parse('$apiUrl/updateTask/$id'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(updatedTask.toJson()),
  );

  print("Response code: ${response.statusCode}");
  print("Response body: ${response.body}");

  if (response.statusCode == 200) {
    print("Task updated successfully!");
  } else {
    print("Failed to update task. Error: ${response.reasonPhrase}");
    throw Exception('Failed to update task');
  }
}




  Future<void> deleteTask(String id) async{
    String? authToken = await SharedPrefs.getAuthToken();
    print("deleting task");
    final response=await http.delete(
      Uri.parse('$apiUrl/deleteTaks/$id'),
       headers: {
          'Authorization': 'Bearer $authToken',
        },
    );
     if (response.statusCode == 200) {
      print("task deleted");
       }
      else{
         throw Exception('Failed to delete task');
      }
    
  }


}