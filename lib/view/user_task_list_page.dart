import 'package:flutter/material.dart';
import 'package:task_project/view/user_task_details_page.dart';
class TaskListPage extends StatelessWidget {
  final String? status;

   final List<Map<String, String>> _tasks = [
      {"category": "Work", "title": "Complete Report", "dueDate": "2025-03-16", "priority": "High", "status": "Pending"},
      {"category": "Personal", "title": "Buy Groceries", "dueDate": "2025-03-17", "priority": "Medium", "status": "Completed"},
      {"category": "Work", "title": "Finish Presentation", "dueDate": "2025-03-18", "priority": "Low", "status": "Pending"},
      {"category": "Personal", "title": "Call Mom", "dueDate": "2025-03-19", "priority": "Medium", "status": "Completed"},
    ];
  
  List<Map<String, String>> get tasks => List.unmodifiable(_tasks);

  TaskListPage({this.status});

  int get count => _tasks.where((task) => task["status"] == status).length;


  @override
  Widget build(BuildContext context) {
    

    final filteredTasks = _tasks.where((task) => task["status"] == status).toList();

    return Scaffold(
      appBar: AppBar(title: Text("$status Tasks")),
      body: ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          final task = filteredTasks[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailsPage(
                    title: task["title"]!,
                    category: task["category"]!,
                    dueDate: task["dueDate"]!,
                    priority: task["priority"]!,
                  ),
                ),
              );
            },
            child: TaskItem(
              category: task["category"]!,
              title: task["title"]!,
              dueDate: task["dueDate"]!,
              priority: task["priority"]!,
            ),
          );
        },
      ),
    );
  }
}



class TaskItem extends StatelessWidget {
  final String category;
  final String title;
  final String dueDate;
  final String priority;

  TaskItem({required this.category, required this.title, required this.dueDate, required this.priority});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start (left side)
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out Column and ElevatedButton
              children: [
                // Column for category and title, aligned to the left
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align texts to the start (left side)
                  children: [
                    Text(category, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                
                // Row for the done button, aligned to the right
                ElevatedButton(
                  onPressed: () {
                   
                  },
                  child: Text('Done'),
                ),
              ],
            )
          ],
        ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Due: $dueDate", style: TextStyle(color: Colors.grey[600])),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(priority),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        priority,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: const Color.fromARGB(255, 37, 0, 250)),
                      onPressed: () {
                        // Define your action here, like opening an edit dialog
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: const Color.fromARGB(255, 248, 1, 14)),
                      onPressed: () {
                        // Define your action here, like opening an edit dialog
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      case "Low":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}