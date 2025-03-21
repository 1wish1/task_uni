import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_project/bloc/task_bloc.dart';
import 'package:task_project/bloc/task_state.dart';
import 'package:task_project/view/user_task_list_page.dart';
import 'package:task_project/view/user_task_details_page.dart';
import 'package:task_project/view/user_add_page.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task Priority")),
      body: BlocBuilder<UserBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is TaskError) {
            return Center(child: Text(state.message));
          }
          if (state is TaskLoaded) {
            return Column(  // <-- Added return here
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
                      StatusCard(title: "Pending", color: Colors.orange),
                      StatusCard(title: "Completed", color: Colors.green),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: state.tasks.map((task) {  // <-- Changed `tasks` to `state.tasks`
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
                                title: task.title,
                                category: task.category,
                                dueDate: task.dueDate,
                                priority: task.priority,
                                description: task.description,
                                status: task.status,
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
                          builder: (context) => AddTaskPage(),
                        ),
                      );
                    },
                    child: Text("Add Task"),
                  ),
                ),
              ],
            );
          }
          return Container(); // Handle the default case to avoid returning null
        },
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
          ],
      ),
    );
  }
}


