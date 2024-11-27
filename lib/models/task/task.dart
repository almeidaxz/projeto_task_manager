class Task {
  final int user_id;
  final int id;
  final String name;
  final String description;
  final String categories;
  final String due_date;
  final String due_time;
  bool is_done;
  bool isSelected;

  Task({
    required this.user_id,
    required this.id,
    required this.name,
    required this.description,
    required this.categories,
    required this.due_date,
    required this.due_time,
    this.is_done = false,
    this.isSelected = false,
  });
}
