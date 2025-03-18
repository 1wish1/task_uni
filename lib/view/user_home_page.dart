import 'package:flutter/material.dart';
import 'package:task_project/view/user_task_list_page.dart';
import 'package:task_project/view/user_task_details_page.dart';
import 'package:task_project/view/user_add_page.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, String>> tasks = List.from(TaskListPage().tasks);

  void _addTask(Map<String, String> newTask) {
    setState(() {
      tasks.add(newTask);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task Priority")),
      body: Column(
        children: [
          SizedBox(height: 10),
          Center(
            child: Text(
              "Task Priority",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatusCard(title: "Pending",  color: Colors.orange),
                StatusCard(title: "Completed", color: Colors.green),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: tasks.map((task) {
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
                          description: task["description"]!
                          
                        ),
                      ),
                    );
                  },
                  child: TaskItem(
                    category: task["category"]!,
                    title: task["title"]!,
                    dueDate: task["dueDate"]!,
                    priority: task["priority"]!,
                    description: task["description"]!,
                    status: task["status"]!,
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTaskPage(onAddTask: _addTask),
                  ),
                );
              },
              child: Text("Add Task"),
            ),
          ),
        ],
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final String title;

  final Color color;

  StatusCard({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskListPage(status: title),
          ),
        );
      },
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 18, color: Colors.white)),
          
          Text("${TaskListPage(status: title).count}", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}


