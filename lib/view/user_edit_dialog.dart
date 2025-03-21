import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_project/bloc/task_bloc.dart';
import 'package:task_project/bloc/task_event.dart';

class EditTaskDialog extends StatefulWidget {
  final int id;
  final String category;
  final String title;
  final String dueDate;
  final String priority;
  final String description;
  final String status;

  EditTaskDialog({
    
    required this.category,
    required this.title,
    required this.dueDate,
    required this.priority,
    required this.description, required this.id, required this.status,
  });

  @override
  _EditTaskDialogState createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
   late TextEditingController categoryController;
  late TextEditingController titleController;
  late TextEditingController dueDateController;
  late TextEditingController descriptionController;
  late String selectedPriority;

  @override
  void initState() {
    super.initState();
    categoryController = TextEditingController(text: widget.category);
    titleController = TextEditingController(text: widget.title);
    dueDateController = TextEditingController(text: widget.dueDate);
    descriptionController = TextEditingController(text: widget.description);
    selectedPriority = widget.priority;
  }

  @override
  void dispose() {
    categoryController.dispose();
    titleController.dispose();
    dueDateController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: categoryController,
          decoration: InputDecoration(labelText: 'Category'),
        ),
        TextField(
          controller: titleController,
          decoration: InputDecoration(labelText: 'Title'),
        ),
        TextField(
          controller: dueDateController,
          decoration: InputDecoration(labelText: 'Due Date'),
        ),
        DropdownButtonFormField<String>(
          value: selectedPriority,
          items: ['High', 'Medium', 'Low']
              .map((priority) => DropdownMenuItem(value: priority, child: Text(priority)))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedPriority = value;
              });
            }
          },
          decoration: InputDecoration(labelText: 'Priority'),
        ),
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(labelText: 'Description'),
          maxLines: 3,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<UserBloc>().add(UpdateTask(widget.id, categoryController.text,titleController.text,descriptionController.text,selectedPriority,dueDateController.text));
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        ),
      ],
    );
  }
}