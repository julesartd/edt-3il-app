import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000';

  static Future<List<Map<String, dynamic>>> getClasses() async {
    print('cc');
    final response = await http.get(Uri.parse('$baseUrl/api/edt/classes'));

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
      final dynamic decodedData = jsonDecode(response.body);
      if (decodedData is List<dynamic>) {
        // Vérifiez que les données décodées sont bien une liste
        return List<Map<String, dynamic>>.from(decodedData);
      } else {
        throw Exception('Unexpected data format');
      }
    } else {
      throw Exception('Failed to load calendar');
    }
  }
}
