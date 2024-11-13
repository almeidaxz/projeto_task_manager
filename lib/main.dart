import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/add_reminder/add_reminder.dart';
import 'package:task_manager/add_task/add_task.dart';
import 'package:task_manager/edit_reminder/edit_reminder.dart';
import 'package:task_manager/edit_task/edit_task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TaskManagerPage(),
    );
  }
}

class Task {
  final String title;
  final String description;
  final String date;
  final String time;
  bool isDone = false;
  bool isSelected;

  Task({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.isDone,
    this.isSelected = false,
  });
}

class Reminders {
  final String title;
  final String description;
  final String date;
  final String time;
  bool isDone = false;
  bool isSelected;

  Reminders({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    this.isSelected = false,
  });
}

class TaskManagerPage extends StatefulWidget {
  const TaskManagerPage({super.key});

  @override
  TaskManagerPageState createState() => TaskManagerPageState();
}

class TaskManagerPageState extends State<TaskManagerPage>
    with SingleTickerProviderStateMixin {
  List<Task> tasks = [
    Task(
        title: "Tarefa n1",
        description: "Terminar protótipo do A3",
        date: "31/11/2024",
        time: "11:00",
        isDone: true),
    Task(
        title: "List item",
        description: "Supporting line text lorem ipsum dolor sit amet.",
        date: "12/12/2024",
        time: "12:00",
        isDone: false),
  ];

  List<Reminders> reminders = [
    Reminders(
        title: "Lembrete 1",
        description: "Ligar para o cliente",
        date: "15/10/2024",
        time: "09:00"),
    Reminders(
        title: "Lembrete 2",
        description: "Reunião com equipe",
        date: "16/12/2024",
        time: "14:00"),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _toggleSelection(int index, bool isTaskTab) {
    setState(() {
      if (isTaskTab) {
        tasks[index].isSelected = !tasks[index].isSelected;
      } else {
        reminders[index].isSelected = !reminders[index].isSelected;
      }
    });
  }

  void _toggleDone(int index, bool isTaskTab) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  void _add(bool isTaskTab) {
    if (isTaskTab) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddTaskPage(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddReminderPage(),
        ),
      );
    }
  }

  void _edit(bool isTaskTab) {
    if (isTaskTab) {
      final arg = tasks.firstWhere((task) => task.isSelected);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditTaskPage(
            taskName: arg.title,
            taskDescription: arg.description,
            taskDate: arg.date,
            taskTime: arg.time,
          ),
        ),
      );
    } else {
      final arg = reminders.firstWhere((reminder) => reminder.isSelected);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditReminderPage(
            reminderName: arg.title,
            reminderDescription: arg.description,
            reminderDate: arg.date,
            reminderTime: arg.time,
          ),
        ),
      );
    }
  }

  void _delete(bool isTaskTab) {
    setState(() {
      if (isTaskTab) {
        tasks.removeWhere((task) => task.isSelected);
      } else {
        reminders.removeWhere((reminder) => reminder.isSelected);
      }
    });
  }

  DateTime _formatDate(String date) {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm");
    return dateFormat.parse(date);
  }

  @override
  Widget build(BuildContext context) {
    int selectedCount = _tabController.index == 0
        ? tasks.where((task) => task.isSelected).length
        : reminders.where((reminder) => reminder.isSelected).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lucas - Tarefas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              // Implementar filtro
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Implementar configurações
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) => setState(() {
            tasks.map((task) => task.isSelected = false);
            reminders.map((reminder) => reminder.isSelected = false);
          }),
          tabs: const [
            Tab(text: "Tarefas"),
            Tab(text: "Lembretes"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList(tasks, isTaskTab: true),
          _buildRemindersList(reminders, isTaskTab: false),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (selectedCount == 0)
              FloatingActionButton.extended(
                onPressed: () => _add(_tabController.index == 0),
                icon: const Icon(Icons.add),
                extendedPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                label: Text(_tabController.index == 0
                    ? 'Nova Tarefa'
                    : 'Novo Lembrete'),
              ),
            if (selectedCount == 1)
              FloatingActionButton.extended(
                onPressed: () => _edit(_tabController.index == 0),
                icon: const Icon(Icons.edit),
                extendedPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                label: const Text("Editar"),
              ),
            if (selectedCount > 0)
              FloatingActionButton.extended(
                onPressed: () => _delete(_tabController.index == 0),
                extendedPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                backgroundColor: Colors.red,
                icon: const Icon(Icons.delete),
                label: const Text("Excluir"),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(List<Task> items, {required bool isTaskTab}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          onTap: () => _toggleSelection(index, isTaskTab),
          shape: const Border(
              bottom: BorderSide(color: Color.fromRGBO(212, 212, 212, 1))),
          title: Text(item.title),
          subtitle: Text("${item.description}\n${item.date} ${item.time}"),
          trailing: Checkbox(
            value: item.isDone,
            onChanged: (value) => _toggleDone(index, isTaskTab),
          ),
          tileColor: item.isSelected
              ? const Color.fromRGBO(218, 212, 222, 1)
              : Colors.white,
        );
      },
    );
  }

  Widget _buildRemindersList(List<Reminders> items, {required bool isTaskTab}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
            child: (ListTile(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              onTap: () => _toggleSelection(index, isTaskTab),
              leading: _formatDate("${item.date} ${item.time}")
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
              title: Center(child: Text(item.title)),
              subtitle: Center(child: Text(item.description)),
              trailing: Text("${item.date} ${item.time}"),
              tileColor: item.isSelected
                  ? const Color.fromRGBO(218, 212, 222, 1)
                  : const Color.fromRGBO(166, 166, 166, .1),
            )));
      },
    );
  }
}
