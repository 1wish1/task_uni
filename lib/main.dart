import 'package:flutter/material.dart';
import 'package:task_project/bloc/task_event.dart';
import 'package:task_project/services/api_service.dart';
import 'package:task_project/view/user_home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/task_bloc.dart';

void main() {
  runApp(TaskManager());
}

class TaskManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
       providers: [
       BlocProvider(
         create: (context) => UserBloc(ApiService())..add(LoadTasks()), // Initialize with LoadUsers event
       ),
     ],
     child: MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    ));
  }
}


