import 'package:flutter/material.dart';
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
