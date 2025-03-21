import 'package:http/http.dart' as http;
import 'dart:convert';
import "package:task_project/model/Task_model.dart";


class ApiService {
  final String baseUrl = "http://127.0.0.1:8000/api/tasks/";


  // Fetch all Tasks
Future<List<Task>> getTasks() async {
  try {
    final response = await http.get(Uri.parse(baseUrl));
    print(response.body);  // To see the raw JSON response

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);  // Decoding as a map

      // Extracting the list of tasks from the 'task' key
      if (data.containsKey('task') && data['task'] is List) {
        List<dynamic> taskList = data['task'];  // Extract the task list

        // Returning the list of Task objects
        return taskList.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('Task key missing or not a list in response');
      }
    } else {
      throw Exception("Failed to load Tasks, status code: ${response.statusCode}");
    }
  } catch (e) {
    print('Error fetching Tasks: $e');
    throw Exception("Error fetching Tasks");
  }
}



  // Create a new Task
  Future<Task> createTask(String category, String title,String priority,String description,String status,String duedate) async {
  final response = await http.post(
    Uri.parse(baseUrl),
    body: json.encode({
      'id': 3,  // Ensure you handle unique IDs appropriately
      'category': category,
      'title': title,
      'priority': priority,
      'description': description,
      'status': status,
      'duedate': duedate
    }),
    headers: {'Content-Type': 'application/json'},
  );
  

  if (response.statusCode == 201) {
    return Task.fromJson(json.decode(response.body));
  } else {
    throw Exception("Failed to create Task");
  }
}



  // Update an existing Task
  Future<Task> updateTask(int id, String category, String title, String description, String priority, String dueDate) async {
    final response = await http.put(
      Uri.parse("$baseUrl$id/"), // Ensure correct URL format
      body: json.encode({
      "id":id,
      "category": category,
      "title": title,
      "priority": priority,
      "description": description,
      "duedate": dueDate
      }),
      headers: {'Content-Type': 'application/json'},
    );

    print(response.body);
    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      print("Failed to update Task. Status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception("Failed to update Task");
    }
  }

  Future<Task> updateStatusTask(int id, String status) async {
    final response = await http.put(
      Uri.parse("$baseUrl$id/"), // Ensure correct URL format
      body: json.encode({
      "id":id,
      "status": status,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    print(response.body);
    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      print("Failed to update Task. Status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception("Failed to update Task");
    }
  }

  // Delete a Task
  Future<void> deleteTask(int id) async {
      final response = await http.delete(Uri.parse("$baseUrl$id/"));

      if (response.statusCode == 204) {
          print("Task deleted successfully.");
      } else {
          print('Failed to delete Task. Status: ${response.statusCode}');
          print('Response body: ${response.body}');
          throw Exception("Failed to delete Task");
      }
  }
}


