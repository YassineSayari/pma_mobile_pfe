import 'dart:convert';

import 'package:pma/const.dart';
import 'package:http/http.dart' as http;
import 'package:pma/models/reclamation_model.dart';
import 'package:pma/services/shared_preferences.dart';


class ReclamationService {

  final String apiUrl = '$baseUrl/api/v1/reclamations';
  

 Future<List<Reclamation>> getAllReclamations() async {
    print("getting reclamations");
    final response = await http.get(
      Uri.parse('$apiUrl/getAllReclamations'),
    );

    if (response.statusCode == 200) {
      print("got reclamations");
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((eventData) => Reclamation.fromJson(eventData)).toList();
    } else {
      throw Exception('Failed to load reclamations');
    }
  }

   Future<List<Reclamation>> getReclamationsByClient(String id) async {
    String? authToken = await SharedPrefs.getAuthToken();
    print("getting reclamations for client:::$id");
    final response = await http.get(
      Uri.parse('$apiUrl/getReclamationsByclient/$id'),
      headers: {
      'Authorization': 'Bearer $authToken',
    },
    );

    if (response.statusCode == 200) {
      print("got reclamations for client");
      final List<dynamic> jsonData = json.decode(response.body);
      print(" reclamations::::: $jsonData");
      return jsonData.map((eventData) => Reclamation.fromJson(eventData)).toList();
    } else {
      throw Exception('Failed to load reclamations');
    }
  }



Future<void> addReclamation(Map<String, dynamic> reclamation) async {
  try {
    String? authToken = await SharedPrefs.getAuthToken();
    print("adding reclamation-----");
    print("new reclamation data::::::::: $reclamation");

    final response = await http.post(
      Uri.parse('$apiUrl/AddReclamation'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(reclamation),
    );

    if (response.statusCode == 200) {
      print("reclamation added");
    } else {
      print("Failed to add reclamation. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to add reclamation');
    }
  } catch (error) {
    print('Error adding reclamation: $error');
    throw error; 
  }
}


Future<void> updateReclamation(String id, Reclamation updatedReclamation) async {
  try {
    String? authToken = await SharedPrefs.getAuthToken();
    print("------------updating reclamation");
    print("Reclamation ID: $id");
    print("Updated Reclamation: ${updatedReclamation.toJson()}");
    
    final response = await http.patch(
      Uri.parse('$apiUrl/UpdateReclamation/$id'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(updatedReclamation.toJson()),
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 201) {
      print("Reclamation updated successfully");
    } else {
      throw Exception('Failed to update reclamation. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error updating reclamation: $error');
    throw Exception('Failed to update reclamation: $error');
  }
}



  Future<void> deleteReclamation(String id) async{
    String? authToken = await SharedPrefs.getAuthToken();
    print("deleting reclamation");
    final response=await http.delete(
      Uri.parse('$apiUrl/deleteReclamation/$id'),
       headers: {
          'Authorization': 'Bearer $authToken',
        },
    );
     if (response.statusCode == 200) {
      print("reclamation deleted");
       }
      else{
         throw Exception('Failed to delete reclamations');
      }
    
  }

  
}
