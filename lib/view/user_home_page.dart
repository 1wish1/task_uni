import 'package:flutter/material.dart';
import 'package:task_project/view/user_task_list_page.dart';
import 'package:task_project/view/user_task_details_page.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, String>> tasks = TaskListPage().tasks;

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


class AddTaskPage extends StatefulWidget {
  final Function(Map<String, String>) onAddTask;

  AddTaskPage({required this.onAddTask});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  String _selectedPriority = "High"; // Default priority selection
  DateTime? _selectedDate; // Stores the selected date

  Future<void> _pickDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Task")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Task Title"),
            ),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: "Category"),
            ),
            InkWell(
              onTap: () => _pickDueDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: "Due Date",
                ),
                child: Text(
                  _selectedDate == null
                      ? "Select Due Date"
                      : "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedPriority,
              decoration: InputDecoration(labelText: "Priority"),
              items: ["High", "Medium", "Low"].map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedPriority = newValue!;
                });
              },
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Description"),
              maxLines: 3, // Allows multiple lines for descriptions
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select a due date")),
                  );
                  return;
                }
                Map<String, String> newTask = {
                  "title": _titleController.text,
                  "category": _categoryController.text,
                  "dueDate": "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}",
                  "priority": _selectedPriority,
                  "description": _descriptionController.text,
                };
                widget.onAddTask(newTask);
                Navigator.pop(context);
              },
              child: Text("Add Task"),
            ),
          ],
        ),
      ),
    );
  }
}
