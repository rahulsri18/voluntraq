import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:5000/api';

  static Future<Map<String, dynamic>> register(
    String name, 
    String email, 
    String password, 
    String dob, {
    String? ngoName,
    String? emergencyLevel,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'dob': dob,
        'ngoName': ngoName,
        'emergencyLevel': emergencyLevel,
        'role': ngoName != null ? 'admin' : 'volunteer',
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Registration failed');
    }
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    // For now, we only pass email to the backend as password verification 
    // is normally done on frontend via Firebase Client SDK.
    // In a full implementation, we'd use Firebase Auth Client SDK directly here.
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Login failed');
    }
  }

  static Future<List<dynamic>> getTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/tasks'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  static Future<List<dynamic>> getAIRecommendedTasks(String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ai/recommend-tasks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return []; // Fallback to empty if AI matching fails
    }
  }

  static Future<void> createTask(
    String title, 
    String description, 
    String location, 
    String urgency, {
    double? lat,
    double? lng,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
        'location': location,
        'urgency': urgency,
        'latitude': lat,
        'longitude': lng,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create task');
    }
  }
}
