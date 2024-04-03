
import 'package:pma/const.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pma/models/procesv_model.dart';
import 'package:pma/services/shared_preferences.dart';

class ProcesVService {

  final String apiUrl = '$baseUrl/api/v1/procesV';
  

 Future<List<Procesv>> getAllProcesV() async {
      String? authToken = await SharedPrefs.getAuthToken();
    print("getting pvs");
    final response = await http.get(
      Uri.parse('$apiUrl/getAllProcesV'),
      headers: {
          'Authorization': 'Bearer $authToken',
        },
    );

    if (response.statusCode == 200) {
      print("got pvs");
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((eventData) => Procesv.fromJson(eventData)).toList();
    } else {
      throw Exception('Failed to load pvs');
    }
  }

  //  Future<List<Procesv>> getProcesvByProject(Map<String, dynamic> project) async {
  //   print("getting proces for project ${project['_id']}");
  //   final response = await http.get(
  //     Uri.parse('$apiUrl/getProcesByProject')
  //   );

  //   if (response.statusCode == 200) {
  //     print("got proces for project");
  //     final List<dynamic> jsonData = json.decode(response.body);
  //     return jsonData.map((eventData) => Procesv.fromJson(eventData)).toList();
  //   } else {
  //     throw Exception('Failed to load proces for project');
  //   }
  // }

Future<List<Procesv>> getProcesvByProject(Map<String, dynamic> project) async {
  try {
    print("Getting proces for project ${project['_id']}");

    // Construct the URL with the project ID

    final response = await http.get(Uri.parse('$apiUrl/getProcesByProject/${project['_id']}'));

    if (response.statusCode == 200) {
      print("Got proces for project");

      final List<dynamic> jsonData = json.decode(response.body);

      List<Procesv> procesvList = jsonData.map((eventData) => Procesv.fromJson(eventData)).toList();

      return procesvList;
    } else {
      print("Failed to load proces for project. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load proces for project. Server error.');
    }
  } catch (error) {
    print("Error loading proces for project: $error");
    throw Exception('Failed to load proces for project. $error');
  }
}
Future<List<Procesv>> getProcesvByUser(String id) async {
  try {
    print("Getting proces for user:::: $id");

    final response = await http.get(Uri.parse('$apiUrl/getProcesByUser/$id'));

    if (response.statusCode == 200) {
      print("Got proces for user");

      final List<dynamic> jsonData = json.decode(response.body);

      List<Procesv> procesvList = jsonData.map((eventData) => Procesv.fromJson(eventData)).toList();

      return procesvList;
    } else {
      print("Failed to load proces for user. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load proces for user. Server error.');
    }
  } catch (error) {
    print("Error loading proces for user: $error");
    throw Exception('Failed to load proces for user. $error');
  }
}


  Future<void> addProcesv(Map<String, dynamic> procesv) async {

  print("------------adding pv-----------$procesv");

  final response = await http.post(
    Uri.parse('$apiUrl/addProcesV'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(procesv),
  );

  print("Response code: ${response.statusCode}");
  print("Response body: ${response.body}");

  if (response.statusCode == 200) {
    print("pv added successfully!");
  } else {
    print("Failed to add pv. Error: ${response.reasonPhrase}");
    throw Exception('Failed to add pv');
  }
}


  Future<void> updateProcesv(String id,  Map<String, dynamic> updatedProcesV) async {
  String? authToken = await SharedPrefs.getAuthToken();

  print("------------updating pv");
  print("updated pv::::::$updatedProcesV");
  final response = await http.put(
    Uri.parse('$apiUrl/updateProcesv/$id'),
    headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    },
    body: json.encode(updatedProcesV),
  );

  if (response.statusCode == 201) {
    print("pv updated");
  } else {
    throw Exception('Failed to update pv');
  }
}

    Future<void> deleteProcesv(String id) async{
    String? authToken = await SharedPrefs.getAuthToken();
    print("deleting pv:::$id");
    final response=await http.delete(
      Uri.parse('$apiUrl/deleteProcesV/$id'),
       headers: {
          'Authorization': 'Bearer $authToken',
        },
    );
     if (response.statusCode == 200) {
      print("pv deleted");
       }
      else{
         throw Exception('Failed to delete pv');
      }
    
  }
}