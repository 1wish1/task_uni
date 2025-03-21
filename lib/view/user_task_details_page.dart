import 'package:flutter/material.dart';

class TaskDetailsPage extends StatelessWidget {
  final String category;
  final String title;
  final String dueDate;
  final String description;
  final String priority;
  final String status;

  TaskDetailsPage({required this.category, required this.title, required this.dueDate, required this.priority, required this.description, required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task Details")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Category: $category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Task: $title"),
            Text("Due Date: $dueDate"),
            Text("Priority: $priority"),
            Text("description: $description"),
            Text("status: $status")
          ],
        ),
      ),
    );
  }
}