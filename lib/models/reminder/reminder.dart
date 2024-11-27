class Reminder {
  final int user_id;
  final int id;
  final String name;
  final String description;
  final String due_date;
  final String due_time;
  bool isOverdue;
  bool isSelected;

  Reminder({
    required this.user_id,
    required this.id,
    required this.name,
    required this.description,
    required this.due_date,
    required this.due_time,
    this.isOverdue = false,
    this.isSelected = false,
  });
}
