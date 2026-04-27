import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

class ApiService {
  static final FirebaseDatabase _db = FirebaseDatabase.instance;

  // Fetch all tasks from Firebase Realtime Database
  static Future<List<dynamic>> getTasks() async {
    try {
      final snapshot = await _db.ref('tasks').get();
      if (snapshot.exists) {
        final Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        List<dynamic> tasks = [];
        data.forEach((key, value) {
          tasks.add({...value as Map, 'id': key});
        });
        return tasks;
      }
      return [];
    } catch (e) {
      print('Error fetching tasks: $e');
      return [];
    }
  }

  // Fetch AI recommended tasks (Mocking AI logic for now by filtering by skills)
  static Future<List<dynamic>> getAIRecommendedTasks(String userId) async {
    try {
      // In a full implementation, this would call a Cloud Function or Gemini API.
      // For now, we return high-urgency tasks as "AI matches".
      final tasks = await getTasks();
      return tasks.where((t) => t['urgency'] == 'Critical' || t['urgency'] == 'High').toList();
    } catch (e) {
      return [];
    }
  }

  // Create a new task in Firebase
  static Future<void> createTask(
    String title, 
    String description, 
    String location, 
    String urgency, {
    double? lat,
    double? lng,
  }) async {
    try {
      final newPostRef = _db.ref('tasks').push();
      await newPostRef.set({
        'title': title,
        'description': description,
        'location': location,
        'urgency': urgency,
        'latitude': lat ?? 12.9716,
        'longitude': lng ?? 77.5946,
        'createdAt': ServerValue.timestamp,
      });
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }
}
