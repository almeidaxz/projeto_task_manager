class Task {
  int id;
  String title;
  String description;
  String categories;
  DateTime dueDate;
  DateTime dueTime;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.categories,
    required this.dueDate,
    required this.dueTime,
    required this.isDone,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        categories: json['categories'],
        dueDate: json['due_date'],
        dueTime: json['due_time'],
        isDone: json['is_done']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'categories': categories,
      'due_date': dueDate,
      'due_time': dueTime,
      'is_done': isDone,
    };
  }
}
