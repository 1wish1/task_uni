abstract class UserEvent {
  
}


class LoadTasks extends UserEvent {}

class AddTask extends UserEvent {
  final String category;
  final String title;
  final String priority;
  final String description;
  final String status;
  final String dueDate;


  AddTask(this.category, this.title,this.description,this.priority,this.status, this.dueDate);
}
class UpdateTask extends UserEvent {
  final int id;
  final String category;
  final String title;
  final String priority;
  final String description;
  final String dueDate;




  UpdateTask(this.id, this.category, this.title,this.description,this.priority, this.dueDate);
}
class UpdateStatusTask extends UserEvent {
  final int id;
  final String Status;


  UpdateStatusTask(this.id,this.Status);
}
class DeleteTask extends UserEvent {
  final int id;


  DeleteTask(this.id);
}
