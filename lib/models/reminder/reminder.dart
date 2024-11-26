class Reminder {
  int id;
  String title;
  String description;
  DateTime dueDate;
  DateTime dueTime;
  bool isDone;

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.dueTime,
    required this.isDone,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        dueDate: json['due_date'],
        dueTime: json['due_time'],
        isDone: json['is_done']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate,
      'due_time': dueTime,
      'is_done': isDone,
    };
  }
}
