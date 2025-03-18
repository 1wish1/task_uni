class Task {
  final int id;
  final String name;
  final String email;


  Task({required this.id, required this.name, required this.email});


  // Convert JSON to User object
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }


  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}


