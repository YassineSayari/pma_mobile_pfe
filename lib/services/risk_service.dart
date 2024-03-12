import 'dart:convert';
import 'package:pma/const.dart';
import 'package:http/http.dart' as http;
import 'package:pma/models/risk_model.dart';
import 'package:pma/services/shared_preferences.dart';


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