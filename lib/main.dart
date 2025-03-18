import 'package:flutter/material.dart';
import 'package:task_project/view/user_home_page.dart';

void main() {
  runApp(TaskManager());
}

class TaskManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}


