class Task {
  final int id;
  final String category;
  final String title;
  final String priority;
  final String dueDate;  // Make sure this matches 'duedate' from the serializer
  final String description;
  final String status;
  
  Task({
    required this.dueDate,
    required this.category,
    required this.title,
    required this.priority,
    required this.description,
    required this.status,
    required this.id,
  });

  // Convert JSON to Task object
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      category: json['category'],
      dueDate: json['duedate'],  // Ensure this matches 'duedate' from the serializer
      title: json['title'],
      priority: json['priority'],
      description: json['description'],
      status: json['status'],
    );
  }

  // Convert Task object to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "duedate": dueDate,  // Ensure this matches 'duedate' from the serializer
      "category": category,
      "title": title,
      "priority": priority,
      "description": description,
      "status": status,
    };
  }
}
