import 'package:flutter/material.dart';
import 'package:task_manager/models/reminder/reminder.dart';
import 'package:task_manager/utils/format_date.dart';

class RemindersList extends StatelessWidget {
  final List<Reminder> reminders;
  final bool isTaskTab;
  final Function(int index, bool isTaskTab) onTap;
  final bool isDarkTheme;

  const RemindersList({
    super.key,
    required this.reminders,
    required this.isTaskTab,
    required this.onTap,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: reminders.length,
      itemBuilder: (context, index) {
        final item = reminders[index];

        Color tileColor;
        if (item.isSelected && !isDarkTheme) {
          tileColor = const Color.fromARGB(255, 158, 158, 158);
        } else if (item.isSelected && isDarkTheme) {
          tileColor = const Color.fromARGB(255, 131, 131, 131);
        } else if (!item.isSelected && isDarkTheme) {
          tileColor = const Color.fromARGB(255, 44, 44, 44);
        } else {
          tileColor = const Color.fromARGB(255, 224, 224, 224);
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
          child: ListTile(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            onTap: () => onTap(index, isTaskTab),
            leading: formatDate("${item.due_date} ${item.due_time}")
                    .isBefore(DateTime.now())
                ? const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 32,
                  )
                : const Icon(
                    Icons.tag_faces_sharp,
                    color: Colors.green,
                    size: 32,
                  ),
            title: Center(child: Text(item.name)),
            subtitle: Center(child: Text(item.description)),
            trailing: Text("${item.due_date} ${item.due_time}"),
            tileColor: tileColor,
          ),
        );
      },
    );
  }
}
