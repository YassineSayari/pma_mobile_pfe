import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pma/const.dart';

final String apiUrl = '$baseUrl/api/v1/events';
Future<int> fetchDataCount(String endpoint) async {
 final response = await http.get(
      Uri.parse('$apiUrl/getAllEvent'));

  if (response.statusCode == 200) {
    // Assuming the response body contains a JSON array of items
    final data = jsonDecode(response.body);
    return data.length; // Return the count of items
  } else {
    throw Exception('Failed to load data');
  }
}
