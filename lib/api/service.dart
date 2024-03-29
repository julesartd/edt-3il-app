import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://julesartd.alwaysdata.net';
  // static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<List<Map<String, dynamic>>> getClasses() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/classes'));
      if (response.statusCode == 200) {
        print(response.body);
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to load classes with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Caught error: $e');
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> getCalendar(String className) async {
    final response = await http.get(Uri.parse('$baseUrl/api/edt?class_param=$className'));
    try {
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        print('Failed to load calendar with status code: ${response.statusCode}');
        throw Exception('Failed to load calendar');
        
      }
    } catch (e) {
      print('Caught error: $e');
    }
    return [];
  }
}
