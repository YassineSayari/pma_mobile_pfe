import 'dart:convert';
import 'package:pma/const.dart';
import 'package:http/http.dart' as http;
import 'package:pma/models/risk_model.dart';
//import 'package:pma/services/shared_preferences.dart';


class RiskService {

  final String apiUrl = '$baseUrl/api/v1/problems';
  

 Future<List<Risk>> getAllProblemes() async {
    print("getting problems");
    final response = await http.get(
      Uri.parse('$apiUrl/getAllProblemes'),
    );

    if (response.statusCode == 200) {
      print("got problems");
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((eventData) => Risk.fromJson(eventData)).toList();
    } else {
      throw Exception('Failed to load problems');
    } 
  }

  Future<List<Risk>> getAllProblemesByUser(String id) async {
    print("getting problems for $id");
    final response = await http.get(
      Uri.parse('$apiUrl/getProbyUSer/$id'),
    );

    if (response.statusCode == 200) {
      print("got problems");
      final List<dynamic> jsonData = json.decode(response.body);
      print("PROBLEMS::::${response.body}");
      return jsonData.map((eventData) => Risk.fromJson(eventData)).toList();
    } else {
      throw Exception('Failed to load problems');
    } 
  }

  Future<void> addRisk(Map<String, dynamic> risk) async {
  try {
    print("adding risk-----");
    print("new risk data::::::::: $risk");

    final response = await http.post(
      Uri.parse('$apiUrl/createProb'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(risk),
    );

    if (response.statusCode == 200) {
      print("risk added");
    } else {
      print("Failed to add risk. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to add risk');
    }
  } catch (error) {
    print('Error adding risk: $error');
    throw error; 
  }
}



Future<void> updateRisk(String id,  Map<String, dynamic> updatedRisk) async {
  try {
    print('Updating risk with ID: $id');
    print('Updated risk data: $updatedRisk');

    final response = await http.patch(
      Uri.parse('$apiUrl/updateProbleme/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(updatedRisk),
    );

    print("Response code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 201) {
      print("Risk updated successfully!");
    } else {
      print("Failed to update risk. Error: ${response.reasonPhrase}");
      throw Exception('Failed to update risk');
    }
  } catch (error) {
    print('Error updating risk: $error');
    throw error; // Rethrow the error to handle it in the calling function
  }
}





    Future<void> deleteRisk(String id) async{
    print("deleting risk");
    final response=await http.delete(
      Uri.parse('$apiUrl/deleteProbleme/$id'),
    
    );
     if (response.statusCode == 200) {
      print("risk deleted");
       }
      else{
         throw Exception('Failed to delete risk');
      }
    
  }

}