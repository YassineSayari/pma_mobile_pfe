import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pma/const.dart';
import 'package:pma/services/shared_preferences.dart';
import '../models/event_model.dart';


class EventService{

  final String apiUrl = '$baseUrl/api/v1/events';

  Future<List<Event>> getAllEvents() async {
        String? authToken = await SharedPrefs.getAuthToken();
    final response = await http.get(
      Uri.parse('$apiUrl/getAllEvent'),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((eventData) => Event.fromJson(eventData)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }


Future<List<Event>> getEventsByUser(String? userId) async {
  print('fetching event for user $userId');
  String? authToken = await SharedPrefs.getAuthToken();
  final response = await http.get(
    Uri.parse('$apiUrl/getEventbyUser/$userId'),
    headers: {'Authorization': 'Bearer $authToken'},
  );

  print('Response status code: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((eventData) => Event.fromJson(eventData)).toList();
  } else {
    throw Exception('Failed to load events for user');
  }
}




}


