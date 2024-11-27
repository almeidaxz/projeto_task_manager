import 'package:flutter/material.dart';
import 'package:task_manager/models/task/task.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final void Function(int index, bool isTaskTab) onToggleSelection;
  final void Function(Task task, int index, bool isTaskTab) onToggleDone;
  final bool isDarkTheme;
  final bool isTaskTab;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onToggleSelection,
    required this.onToggleDone,
    required this.isDarkTheme,
    required this.isTaskTab,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        Color tileColor = task.isSelected
            ? (isDarkTheme
                ? const Color.fromARGB(255, 131, 131, 131)
                : const Color.fromARGB(255, 158, 158, 158))
            : (isDarkTheme
                ? const Color.fromARGB(255, 44, 44, 44)
                : const Color.fromARGB(255, 224, 224, 224));
        return ListTile(
          title: Text(task.name),
          subtitle:
              Text("${task.description}\n${task.due_date} ${task.due_time}"),
          trailing: Switch(
            value: task.is_done,
            onChanged: (_) => onToggleDone(task, index, isTaskTab),
          ),
          tileColor: tileColor,
          onTap: () => onToggleSelection(index, isTaskTab),
        );
      },
    );
  }
}
