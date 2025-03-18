import 'package:flutter/material.dart';

class EditTaskDialog extends StatefulWidget {
  final String category;
  final String title;
  final String dueDate;
  final String priority;
  final String description;

  EditTaskDialog({
    required this.category,
    required this.title,
    required this.dueDate,
    required this.priority,
    required this.description,
  });

  @override
  _EditTaskDialogState createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late TextEditingController titleController;
  late TextEditingController dueDateController;
  late TextEditingController descriptionController;
  late String selectedPriority;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    dueDateController = TextEditingController(text: widget.dueDate);
    descriptionController = TextEditingController(text: widget.description);
    selectedPriority = widget.priority;
  }

  @override
  void dispose() {
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
                // Here you can update the task in your list.
                // You can call a method to save the updated data
                Navigator.of(context).pop(); // Close the dialog
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