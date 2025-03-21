import 'package:task_project/model/Task_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart';
import 'task_event.dart';
import 'task_state.dart';


class UserBloc extends Bloc<UserEvent, TaskState> {
  final ApiService apiService;
 

  UserBloc(this.apiService) : super(TaskInitial()) {
    final priorityOrder = {"high": 3, "medium": 2, "low": 1};  // Priority mapping (make sure to use lowercase)

    on<LoadTasks>((event, emit) async {
      emit(TaskLoading());
      try {
        final tasks = await apiService.getTasks();

        tasks.sort((a, b) {
          final priorityA = priorityOrder[a.priority.toLowerCase()];
          final priorityB = priorityOrder[b.priority.toLowerCase()];

          // If the priority is not found in the map, return 0 (no sorting), or handle the case as needed
          if (priorityA == null || priorityB == null) {
            return 0;  // or you can return a default value to handle undefined priorities
          }

          return priorityB.compareTo(priorityA); // Sorting in descending order (High -> Low)
        });

        emit(TaskLoaded(tasks));  // Emit the sorted tasks
      } catch (e) {
        print('Error: $e');  // Log error for debugging
        emit(TaskError("Failed to fetch tasks"));
      }
    });
  


    on<AddTask>((event, emit) async {
      try {
        final newTask = await apiService.createTask(event.category,event.title,event.priority,event.description,event.status,event.dueDate);
        final updatedUsers = List<Task>.from((state as TaskLoaded).tasks)..add(newTask);

        updatedUsers.sort((a, b) {
          final priorityA = priorityOrder[a.priority.toLowerCase()];
          final priorityB = priorityOrder[b.priority.toLowerCase()];

          // If the priority is not found in the map, return 0 (no sorting), or handle the case as needed
          if (priorityA == null || priorityB == null) {
            return 0;  // or you can return a default value to handle undefined priorities
          }

          return priorityB.compareTo(priorityA); // Sorting in descending order (High -> Low)
        });
        
        emit(TaskLoaded(updatedUsers));// Refresh user list
      } catch (e) {
        emit(TaskError("Failed to add user"));
      }
    });

    on<UpdateTask>((event, emit) async {
      try {
        final updatedUser = await apiService.updateTask(event.id, event.category, event.title,event.description,event.priority,event.dueDate);
        final updatedUsers = (state as TaskLoaded).tasks.map((user){
          return user.id == event.id ? updatedUser : user;
        }).toList();


        updatedUsers.sort((a, b){
        return priorityOrder[b.priority.toLowerCase()]!.compareTo(priorityOrder[a.priority.toLowerCase()]!);
 
        });
        emit(TaskLoaded(updatedUsers));
      } catch (e) {
        emit(TaskError("Failed to update user"));
      }
    });


    on<UpdateStatusTask>((event, emit) async {
      try {
        final updatedUser = await apiService.updateStatusTask(event.id,event.Status);
        final updatedUsers = (state as TaskLoaded).tasks.map((user){
          return user.id == event.id ? updatedUser : user;
        }).toList();


        updatedUsers.sort((a, b){
        return priorityOrder[b.priority.toLowerCase()]!.compareTo(priorityOrder[a.priority.toLowerCase()]!);
 
        });
        emit(TaskLoaded(updatedUsers));
      } catch (e) {
        emit(TaskError("Failed to update user"));
      }
    });

    on<DeleteTask>((event, emit) async {
      try {
        await apiService.deleteTask(event.id);
        final updatedUsers = (state as TaskLoaded).tasks.where((user) => user.id != event.id).toList();
        emit(TaskLoaded(updatedUsers));// Refresh user list
      } catch (e) {
        emit(TaskError("Failed to delete user"));
      }
    });
  }
}
