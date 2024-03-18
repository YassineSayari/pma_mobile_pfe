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
      return jsonData.map((eventData) => Risk.fromJson(eventData)).toList();
    } else {
      throw Exception('Failed to load problems');
    } 
  }



  Future<void> updateRisk(String id, Risk updatedRisk) async {

  print("------------updating risk $id");
  print("updated risk:::${updatedRisk.toJson()}");

  final response = await http.patch(
    Uri.parse('$apiUrl/updateProbleme/$id'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(updatedRisk.toJson()),
  );

  print("Response code: ${response.statusCode}");
  print("Response body: ${response.body}");

  if (response.statusCode == 201) {
    print("Risk updated successfully!");
  } else {
    print("Failed to update risk. Error: ${response.reasonPhrase}");
    throw Exception('Failed to update risk');
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