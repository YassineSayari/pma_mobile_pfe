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


Future<void> addEvent(Map<String,dynamic> event) async {
    String? authToken = await SharedPrefs.getAuthToken();

    try{
      print("event::::::$event");
    final response= await http.post(
      Uri.parse('$apiUrl/createEvent'),
       headers: {'Authorization': 'Bearer $authToken',
       'Content-Type': 'application/json',
       },
       body: jsonEncode(event),
    );
     if (response.statusCode == 200) {
        print("event added");
        print(response.statusCode);
      } else {
        print("Failed to add event. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to add event. Server error.');
      }
    } catch (error) {
      print("Error adding event: $error");
      throw Exception('Failed to add event. $error');
    }
}



Future<void> updatedEvent(String id,Event event) async{
    String? authToken = await SharedPrefs.getAuthToken();
  print("------------updating event $id");
  print("======updated Event: ${event.toJson()}========");
  final response = await http.patch(
    Uri.parse('$apiUrl/updateEvent/$id'),
    headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    },
    body: json.encode(event.toJson()),
  );

  print("Response code: ${response.statusCode}");
  print("Response body: ${response.body}");

  if (response.statusCode == 201) {
    print("Event updated successfully!");
  } else {
    print("Failed to update event. Error: ${response.reasonPhrase}");
    throw Exception('Failed to update event');
  }

}



  Future<void> deleteEvent(String id) async {
        String? authToken = await SharedPrefs.getAuthToken();
    final response = await http.delete(
      Uri.parse('$apiUrl/deleteEvent/$id'),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (response.statusCode == 200) {
      print('event deleted');
    } else {
      throw Exception('Failed to delete event');
    }
  }




}


