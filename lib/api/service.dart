import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://julesartd.alwaysdata.net';

  static Future<List<Map<String, dynamic>>> getClasses() async {
    final response = await http.get(Uri.parse('$baseUrl/api/classes'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load classes');
    }
  }

  static Future<List<Map<String, dynamic>>> getCalendar(
      String className) async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/edt?class_param=$className'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load classes');
    }
  }
}
