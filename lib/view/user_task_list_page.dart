import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_project/bloc/task_bloc.dart';
import 'package:task_project/bloc/task_event.dart';
import 'package:task_project/bloc/task_state.dart';
import 'package:task_project/view/user_task_details_page.dart';
import 'package:task_project/view/user_edit_dialog.dart';


class TaskListPage extends StatelessWidget {
  final String? status;

  
  
  TaskListPage({this.status});



  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
  appBar: AppBar(title: Text("$status Tasks")),
  body: BlocBuilder<UserBloc, TaskState>(
    builder: (context, state) {
      if (state is TaskLoading) {
        return Center(child: CircularProgressIndicator());
      }
      if (state is TaskError) {
        return Center(child: Text(state.message));
      }
      if (state is TaskLoaded) {
        final filteredTasks = state.tasks
            .where((task) => task.status == status) // Filter based on status
            .toList();

        if (filteredTasks.isEmpty) {
          return Center(child: Text("No tasks available"));
        }

        return ListView.builder(
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            final task = filteredTasks[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskDetailsPage(
                      title: task.title,
                      category: task.category,
                      dueDate: task.dueDate,
                      priority: task.priority,
                      description: task.description,
                      status: task.status,
                    ),
                  ),
                );
              },
              child: TaskItem(
                id: task.id,
                category: task.category,
                title: task.title,
                dueDate: task.dueDate,
                priority: task.priority,
                description: task.description,
                status: task.status,
              ),
            );
          },
        );
      }
      return Container(); // Default return if no state matches
    },
  ),
);

  }
}



class TaskItem extends StatefulWidget {
  final int id;
  final String category;
  final String title;
  final String dueDate;
  final String priority;
  final String description;
  final String status;

  TaskItem({
    required this.id,
    required this.category,
    required this.title,
    required this.dueDate,
    required this.priority,
    required this.description,
    required this.status,
  });

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late String currentStatus;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.status;
  }

  void toggleStatus() {
    setState(() {
      currentStatus = (currentStatus == "Completed") ? "Pending" : "Completed";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.category, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(widget.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    String newStatus = (currentStatus == "Completed") ? "Pending" : "Completed";  
                    print(newStatus);
                    context.read<UserBloc>().add(UpdateStatusTask(widget.id, newStatus));
                    setState(() {
                      currentStatus = newStatus;  // Update UI immediately
                    });
                  },
                  child: Text(currentStatus == "Completed" ? "Undone" : "Done"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentStatus == "Completed" ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Due: ${widget.dueDate}", style: TextStyle(color: Colors.grey[600])),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(widget.priority),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.priority,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        // Show Dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Edit Task'),
                              content: EditTaskDialog(
                                category: widget.category,
                                title: widget.title,
                                dueDate: widget.dueDate,
                                priority: widget.priority,
                                description: widget.description, id: widget.id, status: widget.status,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context.read<UserBloc>().add(DeleteTask(widget.id));
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

